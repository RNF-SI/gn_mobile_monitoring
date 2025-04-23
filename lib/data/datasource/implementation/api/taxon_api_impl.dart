import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

class TaxonApiImpl implements TaxonApi {
  final Dio _dio;
  final Connectivity _connectivity = Connectivity();

  TaxonApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ));

  @override
  Future<List<Taxon>> getTaxonsByList(int idListe) async {
    try {
      final response = await _dio.get(
        '/taxhub/api/taxref/allnamebylist/$idListe',
      );

      if (response.statusCode == 200) {
        final List<dynamic> parsed = response.data;
        return parsed.map((json) => _parseTaxonFromList(json)).toList();
      }

      throw ApiException(
        'Failed to load taxons for list $idListe',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching taxons for list $idListe: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch taxons for list $idListe: $e');
    }
  }

  @override
  Future<TaxonList> getTaxonList(int idListe) async {
    try {
      final response = await _dio.get(
        '/monitorings/util/taxonomy_list/$idListe',
      );

      if (response.statusCode == 200) {
        final json = response.data;
        return TaxonList(
          idListe: json['id_liste'],
          codeListe: json['code_liste'],
          nomListe: json['nom_liste'],
          descListe: json['desc_liste'],
          regne: json['regne'],
          group2Inpn: json['group2_inpn'],
        );
      }

      throw ApiException(
        'Failed to load taxon list with id $idListe',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching taxon list: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch taxon list: $e');
    }
  }

  @override
  Future<Taxon> getTaxonByCdNom(int cdNom) async {
    try {
      final response = await _dio.get(
        '/taxonomie/taxref/$cdNom',
      );

      if (response.statusCode == 200) {
        final json = response.data;
        return _parseTaxon(json);
      }

      throw ApiException(
        'Failed to load taxon with cd_nom $cdNom',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching taxon: ${e.message}');
    } catch (e) {
      throw ApiException('Failed to fetch taxon: $e');
    }
  }

  Taxon _parseTaxon(Map<String, dynamic> json) {
    return Taxon(
      cdNom: json['cd_nom'],
      cdRef: json['cd_ref'],
      idStatut: json['id_statut'],
      idHabitat: json['id_habitat'],
      idRang: json['id_rang'],
      regne: json['regne'],
      phylum: json['phylum'],
      classe: json['classe'],
      ordre: json['ordre'],
      famille: json['famille'],
      sousFamille: json['sous_famille'],
      tribu: json['tribu'],
      cdTaxsup: json['cd_taxsup'],
      cdSup: json['cd_sup'],
      lbNom: json['lb_nom'],
      lbAuteur: json['lb_auteur'],
      nomComplet: json['nom_complet'] ?? 'Sans nom',
      nomCompletHtml: json['nom_complet_html'],
      nomVern: json['nom_vern'],
      nomValide: json['nom_valide'],
      nomVernEng: json['nom_vern_eng'],
      group1Inpn: json['group1_inpn'],
      group2Inpn: json['group2_inpn'],
      group3Inpn: json['group3_inpn'],
      url: json['url'],
    );
  }

  // Méthode spécifique pour parser les taxons venant de l'endpoint allnamebylist
  Taxon _parseTaxonFromList(Map<String, dynamic> json) {
    return Taxon(
      cdNom: json['cd_nom'],
      cdRef: json['cd_ref'],
      regne: json['regne'],
      lbNom: json['lb_nom'],
      nomComplet: json['search_name'] ?? json['lb_nom'] ?? 'Sans nom',
      nomVern: json['nom_vern'],
      nomValide: json['nom_valide'],
      group2Inpn: json['group2_inpn'],
      group3Inpn: json['group3_inpn'],
      // Champs facultatifs
      idStatut: null,
      idHabitat: null,
      idRang: null,
      phylum: null,
      classe: null,
      ordre: null,
      famille: null,
      sousFamille: null,
      tribu: null,
      cdTaxsup: null,
      cdSup: null,
      lbAuteur: null,
      nomCompletHtml: null,
      nomVernEng: null,
      group1Inpn: null,
      url: null,
    );
  }

  @override
  Future<SyncResult> syncTaxons(
      String token, List<String> downloadedModuleCodes,
      {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité réseau
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return SyncResult.failure(
          errorMessage: 'Aucune connexion réseau disponible',
        );
      }

      // Récupérer la liste des modules
      final response = await _dio.get(
        '/monitorings/modules',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Erreur lors de la récupération des modules',
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> modules = response.data;
      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;

      // Ensemble pour stocker les IDs de listes uniques
      final Set<int> uniqueListIds = {};

      // Extraire les IDs de listes taxonomiques des modules téléchargés
      for (final moduleData in modules) {
        try {
          final String? moduleCode = moduleData['module_code'];
          if (moduleCode != null &&
              downloadedModuleCodes.contains(moduleCode) &&
              moduleData['module_complement'] != null &&
              moduleData['module_complement']['id_list_taxonomy'] != null) {
            uniqueListIds
                .add(moduleData['module_complement']['id_list_taxonomy']);
          }
        } catch (e) {
          print(
              'Erreur lors de l\'extraction de l\'ID de liste du module ${moduleData['id_module']}: $e');
          continue;
        }
      }

      // Pour chaque liste taxonomique unique
      for (final listId in uniqueListIds) {
        try {
          // Récupérer la liste taxonomique complète
          final taxonList = await getTaxonList(listId);
          itemsProcessed++;

          // Récupérer les taxons associés à cette liste
          final taxons = await getTaxonsByList(listId);
          itemsProcessed += taxons.length;
          itemsAdded += taxons.length; // Simplifié pour l'exemple
        } catch (e) {
          print('Erreur lors de la synchronisation de la liste $listId: $e');
          itemsSkipped++;
          continue;
        }
      }

      return SyncResult.success(
        itemsProcessed: itemsProcessed,
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
      );
    } on DioException catch (e) {
      return SyncResult.failure(
        errorMessage: 'Erreur réseau: ${e.message}',
      );
    } catch (e) {
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des taxons: $e',
      );
    }
  }

  @override
  Future<List<Taxon>> searchTaxons(String token, String searchTerm,
      {int? idListe}) async {
    try {
      // Paramètres de recherche
      final queryParams = <String, dynamic>{
        'search': searchTerm,
        'limit': 50,
      };

      if (idListe != null) {
        queryParams['id_liste'] = idListe.toString();
      }

      // Appel API
      final response = await _dio.get(
        '/taxonomie/taxref/search',
        queryParameters: queryParams,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode != 200) {
        throw ApiException(
          'Erreur lors de la recherche de taxons',
          statusCode: response.statusCode,
        );
      }

      final List<dynamic> data = response.data;
      return data.map((json) => _parseTaxon(json)).toList();
    } on DioException catch (e) {
      throw NetworkException(
        'Erreur réseau lors de la recherche de taxons: ${e.message}',
      );
    } catch (e) {
      throw ApiException('Erreur lors de la recherche de taxons: $e');
    }
  }
}
