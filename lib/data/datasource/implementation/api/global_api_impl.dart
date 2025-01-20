import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';

class GlobalApiImpl implements GlobalApi {
  final Dio _dio;
  final String apiBase = Config.apiBase;

  GlobalApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        ));

  @override
  Future<Map<String, dynamic>> getNomenclaturesAndDatasets() async {
    try {
      final response =
          await _dio.get('$apiBase/monitorings/util/init_data/chiro');

      if (response.statusCode == 200) {
        final nomenclatures = (response.data['nomenclature'] as List<dynamic>)
            .map((json) => NomenclatureEntity.fromJson(json))
            .toList();

        final datasets = (response.data['dataset'] as List<dynamic>)
            .map((json) => DatasetEntity.fromJson(json))
            .toList();

        return {
          'nomenclatures': nomenclatures,
          'datasets': datasets,
        };
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}
