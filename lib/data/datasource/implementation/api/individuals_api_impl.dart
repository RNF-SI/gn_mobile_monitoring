import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/individuals_api.dart';
import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/individuals_with_modules.dart';

class IndividualsApiImpl extends BaseApi implements IndividualsApi {
  IndividualsApiImpl();

  @override
  Dio get dio => createDio(
    receiveTimeout: const Duration(seconds: 300), // 5 minutes pour les grosses quantités de données
    sendTimeout: const Duration(seconds: 120),
  );

  @override
  Future<List<IndividualsWithModulesLabel>> fetchEnrichedIndividualsForModule(
      String moduleCode, String token) async {
    try {
      final response = await dio.get(
        '/monitorings/object/$moduleCode/module',
        queryParameters: {
          'depth': 2,
          'field_name': 'module_code',
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // 204 (No Content) signifie qu'il n'y a pas de groupes de sites disponibles,
      // mais c'est un cas valide - retourner une liste vide
      if (response.statusCode == 204) {
        final logger = AppLogger();
        logger.i(
          'Module $moduleCode: réponse 204 (No Content) pour les groupes de sites. '
          'Aucun groupe de sites disponible pour ce module.',
          tag: 'sync',
        );
        return <IndividualsWithModulesLabel>[];
      }

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final result = <IndividualsWithModulesLabel>[];

        // Debug print to understand the response structure
        print('API Response structure for module $moduleCode: ${data.keys.toList()}');
        
        // Handle different API response structures
        List<dynamic>? individualsList;
        
        // Try to find individuals in different possible locations
        if (data['children'] != null &&
            data['children']['individual'] != null) {
          // Original structure: data.children.individual
          individualsList = data['children']['individual'] as List;
          print('Found individuals in children.individual: ${individualsList.length} groups');
        } else if (data['individual'] != null) {
          // Alternative structure: data.individual directly
          individualsList = data['individual'] as List;
          print('Found individuals directly in individual: ${individualsList.length} groups');
        } else if (data['properties'] != null && 
                   data['properties']['individual'] != null) {
          // Another possible structure: data.properties.individual
          individualsList = data['properties']['individual'] as List;
          print('Found individuals in properties.individual: ${individualsList.length} groups');
        } else {
          // No individuals found - this might be normal for modules without individuals
          print('No individuals found for module $moduleCode. Response keys: ${data.keys.toList()}');
          if (data['children'] != null) {
            print('Children keys: ${(data['children'] as Map<String, dynamic>).keys.toList()}');
          }
          if (data['properties'] != null) {
            print('Properties keys: ${(data['properties'] as Map<String, dynamic>).keys.toList()}');
          }
        }
        
        // Process individuals if found
        if (individualsList != null) {
          for (var group in individualsList) {
            try {
              final groupData = group as Map<String, dynamic>;
              
              // Extract properties - handle different structures
              Map<String, dynamic>? properties;
              if (groupData['properties'] != null) {
                properties = groupData['properties'] as Map<String, dynamic>;
              } else {
                // If no properties field, use the group data itself
                properties = groupData;
              }

              // Extract individual data from the properties
              final Map<String, dynamic> formattedGroupData = {
                'id_individual': properties['id_individual'] ?? 
                                 groupData['id_individual'] ?? 
                                 groupData['id'],
                'individual_name': properties['individual_name'] ?? 
                                   groupData['individual_name'] ?? 
                                   groupData['name'] ?? 
                                   '',
                'id_digitiser': properties['id_digitiser'] ?? groupData['id_digitiser'],
                'cd_nom': properties['cd_nom'] ?? groupData['cd_nom'],
                'comment': properties['comment'] ?? groupData['comment'],
                'id_nomenclature_sex': properties['id_nomenclature_sex'] ?? groupData['id_nomenclature_sex'],
                'active_individual': properties['active_individual'] ?? groupData['active_individual'],
                'uuid_individual': properties['uuid_individual'] ?? groupData['uuid_individual'],
                'meta_create_date': properties['meta_create_date'] ?? groupData['meta_create_date'],
                'meta_update_date': properties['meta_update_date'] ?? groupData['meta_update_date'],
                'modules': [
                  moduleCode
                ], // We know this individual belongs to this module
              };

              result.add(IndividualsWithModulesLabel(
                individual: IndividualEntity.fromJson(formattedGroupData),
                moduleLabelList: [
                  moduleCode
                ], // We know this individual belongs to this module
              ));
            } catch (e) {
              print('Error processing individual: $e');
              print('Group data: $group');
            }
          }
        }

        return result;
      }

      throw ApiException(
        'Failed to fetch individuals for module $moduleCode',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
          'Network error while fetching individuals: ${e.message}',
          originalDioException: e);
    } catch (e) {
      throw ApiException('Failed to fetch individuals: $e');
    }
  }
}