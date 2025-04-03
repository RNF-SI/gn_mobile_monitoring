import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

class TaxonApiImpl implements TaxonApi {
  final Dio _dio;

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
}
