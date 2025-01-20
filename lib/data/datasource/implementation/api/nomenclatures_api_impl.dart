import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';

import '../../interface/api/nomenclatures_api.dart';

class NomenclaturesApiImpl implements NomenclaturesApi {
  final Dio _dio;

  NomenclaturesApiImpl(this._dio);

  @override
  Future<List<NomenclatureEntity>> getNomenclatures() async {
    try {
      final response = await _dio.get('/monitorings/util/init_data/chiro');

      if (response.statusCode == 200) {
        final data = response.data['nomenclature'] as List<dynamic>;
        return data.map((json) => NomenclatureEntity.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch nomenclatures. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching nomenclatures: $e');
    }
  }
}
