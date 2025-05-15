import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 300), // 5 minutes pour les listes de taxons volumineuses
          sendTimeout: const Duration(seconds: 120),
        ));

  @override
  Future<List<Taxon>> getTaxonsByList(int idListe) async {
    try {
      debugPrint('Récupération des taxons pour la liste $idListe avec pagination');
      
      List<Taxon> allTaxons = [];
      int currentPage = 1;
      int limit = 100; // Augmenter la limite pour réduire le nombre de requêtes
      bool hasMoreData = true;
      
      while (hasMoreData) {
        debugPrint('Récupération de la page $currentPage (limite=$limit) pour la liste $idListe');
        
        final response = await _dio.get(
          '/taxhub/api/taxref/allnamebylist/$idListe',
          queryParameters: {
            'limit': limit,
            'page': currentPage,
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> parsed = response.data;
          final pageTaxons = parsed.map((json) => _parseTaxonFromList(json)).toList();
          
          allTaxons.addAll(pageTaxons);
          debugPrint('Reçu ${pageTaxons.length} taxons sur la page $currentPage pour la liste $idListe');
          
          // Si nous avons reçu moins de résultats que la limite, nous avons atteint la fin
          if (pageTaxons.length < limit) {
            hasMoreData = false;
            debugPrint('Fin de la pagination pour la liste $idListe, total: ${allTaxons.length} taxons');
          } else {
            // Sinon, passer à la page suivante
            currentPage++;
          }
        } else {
          throw ApiException(
            'Failed to load taxons for list $idListe on page $currentPage',
            statusCode: response.statusCode,
          );
        }
      }
      
      debugPrint('Total de ${allTaxons.length} taxons récupérés pour la liste $idListe');
      return allTaxons;
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
  Future<SyncResult> syncTaxonsFromAPI(
      String token, List<String> downloadedModuleCodes, List<int> taxonomyListIds,
      {DateTime? lastSync}) async {
    try {
      debugPrint('syncTaxonsFromAPI - Début de la synchronisation des taxons pour ${downloadedModuleCodes.length} modules avec ${taxonomyListIds.length} listes taxonomiques');
      // Vérifier la connectivité réseau
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        debugPrint('syncTaxonsFromAPI - Aucune connexion réseau disponible');
        return SyncResult.failure(
          errorMessage: 'Aucune connexion réseau disponible',
        );
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;

      // Collections pour stocker les données à passer au repository
      final List<TaxonList> taxonLists = [];
      final List<Taxon> allTaxons = [];
      final Map<int, List<int>> listToTaxonMap = {};

      // Utiliser directement les IDs de listes taxonomiques fournis
      final Set<int> uniqueListIds = taxonomyListIds.toSet();
      debugPrint('syncTaxonsFromAPI - ${uniqueListIds.length} listes taxonomiques uniques à traiter: $uniqueListIds');

      // Pour chaque liste taxonomique unique
      for (final listId in uniqueListIds) {
        try {
          debugPrint('syncTaxonsFromAPI - Traitement de la liste taxonomique $listId');
          // Récupérer la liste taxonomique complète
          debugPrint('syncTaxonsFromAPI - Récupération des détails de la liste $listId');
          final taxonList = await getTaxonList(listId);
          taxonLists.add(taxonList); // Ajouter à la collection
          debugPrint('syncTaxonsFromAPI - Liste $listId récupérée: ${taxonList.nomListe}');
          itemsProcessed++;

          // Récupérer les taxons associés à cette liste
          debugPrint('syncTaxonsFromAPI - Récupération des taxons pour la liste $listId');
          final taxons = await getTaxonsByList(listId);
          debugPrint('syncTaxonsFromAPI - ${taxons.length} taxons récupérés pour la liste $listId');
          
          allTaxons.addAll(taxons); // Ajouter à la collection globale

          // Stocker la relation liste-taxons
          listToTaxonMap[listId] = taxons.map((t) => t.cdNom).toList();
          debugPrint('syncTaxonsFromAPI - Relation liste-taxons stockée pour la liste $listId avec ${taxons.length} taxons');

          itemsProcessed += taxons.length;
          itemsAdded += taxons
              .length; // Approximation avant traitement réel dans le repository
        } catch (e) {
          debugPrint('syncTaxonsFromAPI - Erreur lors de la synchronisation de la liste $listId: $e');
          itemsSkipped++;
          continue;
        }
      }

      // Sauvegarder les listes taxonomiques
      for (final list in taxonLists) {
        try {
          // Logique pour sauvegarder en base de données
          // (sera réalisée dans le repository)
        } catch (e) {
          print('Erreur lors de la sauvegarde de la liste ${list.idListe}: $e');
          itemsSkipped++;
        }
      }

      // Sauvegarder tous les taxons
      try {
        // Éliminer les doublons potentiels par cd_nom
        final Map<int, Taxon> uniqueTaxons = {};
        for (final taxon in allTaxons) {
          uniqueTaxons[taxon.cdNom] = taxon;
        }

        // Logique pour sauvegarder en base de données
        // (sera réalisée dans le repository)
        itemsAdded = uniqueTaxons.length;
      } catch (e) {
        print('Erreur lors de la sauvegarde des taxons: $e');
        itemsSkipped++;
      }

      // Sauvegarder les associations liste-taxons
      for (final entry in listToTaxonMap.entries) {
        try {
          final listId = entry.key;
          final taxonIds = entry.value;

          // Logique pour sauvegarder les relations en base de données
          // (sera réalisée dans le repository)
        } catch (e) {
          print(
              'Erreur lors de la sauvegarde des relations pour la liste ${entry.key}: $e');
          itemsSkipped++;
        }
      }

      // Éliminer les doublons potentiels par cd_nom
      final Map<int, Taxon> uniqueTaxons = {};
      for (final taxon in allTaxons) {
        uniqueTaxons[taxon.cdNom] = taxon;
      }
      
      // Mettre à jour les statistiques après déduplication
      final List<Taxon> uniqueTaxonsList = uniqueTaxons.values.toList();
      debugPrint('syncTaxonsFromAPI - ${uniqueTaxonsList.length} taxons uniques après déduplication (sur ${allTaxons.length} taxons au total)');
      
      // Le décompte précis des ajouts sera fait dans le repository en comparant avec les données existantes
      // Ici, on envoie juste le count total pour aider au diagnostic
      debugPrint('syncTaxonsFromAPI - Fin de la synchronisation des taxons - retour avec succès');
      debugPrint('syncTaxonsFromAPI - Résumé: ${taxonLists.length} listes taxonomiques, ${uniqueTaxonsList.length} taxons, ${listToTaxonMap.length} relations liste-taxons');
      
      // Important: On retourne le nombre réel de taxons renvoyés par les API, qu'il y ait une date de dernière synchro ou non
      return SyncResult.success(
        itemsProcessed: itemsProcessed,
        itemsAdded: uniqueTaxonsList.length, // Nombre brut sans tenir compte de lastSync
        itemsUpdated: 0, // Les mises à jour seront calculées dans le repository
        itemsSkipped: itemsSkipped,
        data: {
          'taxon_lists': taxonLists,
          'taxons': uniqueTaxonsList,
          'list_to_taxon_map': listToTaxonMap,
          'raw_taxon_count': uniqueTaxonsList.length, // Information additionnelle
        },
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
