import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/individuals_api.dart';
import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';

class IndividualsApiImpl extends BaseApi implements IndividualsApi {
  IndividualsApiImpl();

  /// Checks if a individual has sufficient CRUVED permissions
  /// Returns true if any of the CRUVED values is greater than 0
  bool _hasIndividualPermissions(Map<String, dynamic> cruved) {
    // Check if any of the CRUVED values is greater than 0
    return cruved.values.any((value) => value is num && value > 0);
  }

  @override
  Future<List<IndividualEntity>> fetchAllIndividuals(
      String token) async {
    try {
      final response = await dio.get(
        '/monitorings/refacto/individuals',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        List<dynamic> individualsList;
        
        // Gérer différents formats de réponse API
        if (data is List) {
          // Si la réponse est directement une liste
          individualsList = data;
        } else if (data is Map<String, dynamic>) {
          // Si la réponse est un objet, chercher la liste dans différentes clés possibles
          if (data.containsKey('individuals')) {
            individualsList = data['individuals'] as List<dynamic>;
          } else if (data.containsKey('data')) {
            individualsList = data['data'] as List<dynamic>;
          } else if (data.containsKey('results')) {
            individualsList = data['results'] as List<dynamic>;
          } else {
            // Si aucune clé connue, essayer de traiter l'objet comme un individual unique
            individualsList = [data];
          }
        } else {
          throw Exception('Unexpected response format: ${data.runtimeType}');
        }
        
        final individuals = <IndividualEntity>[];

        for (var item in individualsList) {
          final json = item as Map<String, dynamic>;

          // Check CRUVED permissions
          final cruved = json['cruved'] as Map<String, dynamic>?;
          if (!_hasIndividualPermissions(cruved ?? {})) {
            continue; // Skip this individual if no permissions
          }

          // Extract individual data
          final individualJson = {
              'id_individual': json['id_individual'],
              'individual_code': json['individual_code'],
              'individual_label': json['individual_label'],
              'individual_picto': json['individual_picto'],
              'individual_desc': json['individual_desc'],
              'individual_group': json['individual_group'],
              'individual_path': json['individual_path'],
              'individual_external_url': json['individual_external_url'],
              'individual_target': json['individual_target'],
              'individual_comment': json['individual_comment'],
              'active_frontend': json['active_frontend'],
              'active_backend': json['active_backend'],
              'individual_doc_url': json['individual_doc_url'],
              'individual_order': json['individual_order'],
              'ng_individual': json['ng_individual'],
              'meta_create_date': json['meta_create_date'],
              'meta_update_date': json['meta_update_date'],
              'cruved': json['cruved'],
            };
            individuals.add(IndividualEntity.fromJson(individualJson));
          }

        return (individuals);
      } else {
        throw Exception(
            'Failed to load individuals with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching individuals: $e');
    }
  }
}
