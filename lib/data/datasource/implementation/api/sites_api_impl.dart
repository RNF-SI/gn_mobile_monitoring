import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';

class SitesApiImpl implements SitesApi {
  final Dio _dio;

  SitesApiImpl()
      : _dio = Dio(BaseOptions(
          baseUrl: Config.apiBase,
          connectTimeout: const Duration(milliseconds: 5000),
          receiveTimeout: const Duration(milliseconds: 3000),
        ));

  @override
  Future<List<BaseSiteEntity>> fetchSitesFromApi(String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/sites',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        return jsonData
            .map(
                (json) => BaseSiteEntity.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch sites');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching sites: $e');
    }
  }

  @override
  Future<List<SiteGroupEntity>> fetchSiteGroupsFromApi(String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/site-groups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data['items'];
        return jsonData
            .map((json) =>
                SiteGroupEntity.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch site groups');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching site groups: $e');
    }
  }
}
