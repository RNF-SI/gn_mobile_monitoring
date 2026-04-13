import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/mobile_app_api.dart';

class MobileAppApiImpl extends BaseApi implements MobileAppApi {
  MobileAppApiImpl({super.dio});

  @override
  Future<List<Map<String, dynamic>>?> fetchMobileApps(
      String token, String appCode) async {
    try {
      final response = await dio.get(
        '/gn_commons/t_mobile_apps',
        queryParameters: {'app_code': appCode},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .whereType<Map<String, dynamic>>()
            .toList();
      }

      return null;
    } on DioException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
