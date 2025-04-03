import 'dart:convert';

import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:http/http.dart' as http;

class TaxonApiImpl implements TaxonApi {
  final http.Client _client;
  final String _baseUrl;
  final String _token;

  TaxonApiImpl(this._client, this._baseUrl, this._token);

  @override
  Future<List<Taxon>> getTaxonsByList(int idListe) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/taxonomie/taxref/list/$idListe'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.body) as List;
        return parsed.map((json) => _parseTaxon(json)).toList();
      } else {
        throw ApiException(
          'Failed to load taxons for list $idListe',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(
        'Error fetching taxons for list $idListe: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<TaxonList> getTaxonList(int idListe) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/taxonomie/lists/$idListe'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return TaxonList(
          idListe: json['id_liste'],
          codeListe: json['code_liste'],
          nomListe: json['nom_liste'],
          descListe: json['desc_liste'],
          regne: json['regne'],
          group2Inpn: json['group2_inpn'],
        );
      } else {
        throw ApiException(
          'Failed to load taxon list with id $idListe',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(
        'Error fetching taxon list with id $idListe: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  @override
  Future<Taxon> getTaxonByCdNom(int cdNom) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/taxonomie/taxref/$cdNom'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return _parseTaxon(json);
      } else {
        throw ApiException(
          'Failed to load taxon with cd_nom $cdNom',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw ApiException(
        'Error fetching taxon with cd_nom $cdNom: ${e.toString()}',
        statusCode: 500,
      );
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
}
