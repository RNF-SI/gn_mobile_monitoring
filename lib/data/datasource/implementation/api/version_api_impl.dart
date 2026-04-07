import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/version_api.dart';

class VersionApiImpl extends BaseApi implements VersionApi {
  VersionApiImpl({Dio? dio}) : super(dio: dio);

  @override
  Future<String?> fetchMonitoringVersion(String token) async {
    try {
      final response = await dio.get(
        '/gn_commons/modules',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data is List) {
        final modules = response.data as List;

        for (final module in modules) {
          if (module is Map<String, dynamic>) {
            final moduleCode = module['module_code']?.toString() ?? '';
            if (moduleCode.toUpperCase() == 'MONITORINGS') {
              return module['version']?.toString();
            }
          }
        }
      }

      // Module MONITORINGS non trouvé dans la liste
      return null;
    } on DioException {
      // 404 ou erreur réseau → endpoint inexistant sur vieux GeoNature
      return null;
    } catch (_) {
      return null;
    }
  }
}
