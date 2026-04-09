import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

/// Fonction top-level pour le parsing JSON des taxons (exécutable dans un isolate via compute)
/// Compatible avec la réponse de /api/taxref (format occtax) et /allnamebylist (ancien format)
@visibleForTesting
List<Taxon> parseTaxonListFromJson(List<dynamic> jsonList) {
  return jsonList
      .map((json) => Taxon(
            cdNom: json['cd_nom'],
            cdRef: json['cd_ref'],
            regne: json['regne'],
            lbNom: json['lb_nom'],
            nomComplet:
                json['nom_complet'] ?? json['search_name'] ?? json['lb_nom'] ?? 'Sans nom',
            nomVern: json['nom_vern'],
            nomValide: json['nom_valide'],
            group2Inpn: json['group2_inpn'],
            group3Inpn: json['group3_inpn'],
          ))
      .toList();
}

class TaxonApiImpl extends BaseApi implements TaxonApi {
  TaxonApiImpl({Dio? dio}) : super(dio: dio);

  @override
  Dio get dio => createDio(
    receiveTimeout: const Duration(seconds: 300), // 5 minutes pour les listes de taxons volumineuses
    sendTimeout: const Duration(seconds: 120),
  );

  @override
  Future<List<Taxon>> fetchTaxonPage(int idListe,
      {required int page, int limit = 5000}) async {
    // Retry avec backoff exponentiel (similaire à occtax mobile)
    const maxRetries = 3;
    for (var attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // Utilise /api/taxref comme occtax mobile (mieux optimisé pour la pagination)
        final response = await dio.get(
          '/taxhub/api/taxref',
          queryParameters: {
            'limit': limit,
            'page': page,
            'id_liste': idListe.toString(),
            'orderby': 'cd_nom',
            'fields': 'listes',
          },
        );

        if (response.statusCode == 200) {
          // Format réponse /api/taxref : {items: [...], total, limit, page}
          final Map<String, dynamic> data = response.data;
          final List<dynamic> items = data['items'] ?? [];
          // Parsing dans un isolate séparé pour ne pas bloquer l'UI
          return await compute(parseTaxonListFromJson, items);
        }

        throw ApiException(
          'Failed to load taxons for list $idListe on page $page',
          statusCode: response.statusCode,
        );
      } on DioException catch (e) {
        if (attempt < maxRetries &&
            (e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.sendTimeout)) {
          final delay = Duration(seconds: 5 * attempt);
          debugPrint(
              'fetchTaxonPage - List $idListe page $page timeout (tentative $attempt/$maxRetries), retry dans ${delay.inSeconds}s');
          await Future.delayed(delay);
          continue;
        }
        throw NetworkException(
            'Network error while fetching taxons for list $idListe page $page: ${e.message}',
            originalDioException: e);
      } on ApiException {
        rethrow;
      } catch (e) {
        throw ApiException(
            'Failed to fetch taxons for list $idListe page $page: $e');
      }
    }
    // Ne devrait pas arriver, mais par sécurité
    throw ApiException(
        'Failed to fetch taxons for list $idListe page $page after $maxRetries retries');
  }

  @override
  Future<List<Taxon>> getTaxonsByList(int idListe) async {
    List<Taxon> allTaxons = [];
    int currentPage = 1;
    const int limit = 5000;
    bool hasMore = true;

    while (hasMore) {
      final pageTaxons =
          await fetchTaxonPage(idListe, page: currentPage, limit: limit);
      allTaxons.addAll(pageTaxons);
      hasMore = pageTaxons.length >= limit;
      currentPage++;
    }

    return allTaxons;
  }

  @override
  Future<TaxonList> getTaxonList(int idListe) async {
    try {
      final response = await dio.get(
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
          'Network error while fetching taxon list: ${e.message}',
          originalDioException: e);
    } catch (e) {
      throw ApiException('Failed to fetch taxon list: $e');
    }
  }

  @override
  Future<Taxon> getTaxonByCdNom(int cdNom) async {
    try {
      final response = await dio.get(
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
          'Network error while fetching taxon: ${e.message}',
          originalDioException: e);
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
      final response = await dio.get(
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
        originalDioException: e,
      );
    } catch (e) {
      throw ApiException('Erreur lors de la recherche de taxons: $e');
    }
  }
}
