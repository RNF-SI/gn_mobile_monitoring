import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/data_parsing_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';

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
    List<BaseSiteEntity> allSites = [];
    int page = 1;
    const int limit = 50; // Adjust as needed

    try {
      while (true) {
        final response = await _dio.get(
          '/monitorings/sites',
          queryParameters: {'page': page, 'limit': limit},
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data;

          if (data == null || data['items'] == null) {
            throw DataParsingException('Response data or items are null');
          }

          final items = data['items'] as List<dynamic>;
          allSites.addAll(
            items.map(
              (json) => BaseSiteEntity.fromJson(json as Map<String, dynamic>),
            ),
          );

          // Break the loop if we have fetched all pages
          if (items.length < limit) break;

          page++;
        } else {
          throw ApiException(
            'Failed to fetch sites from API',
            statusCode: response.statusCode,
          );
        }
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      throw NetworkException(
        'Network error occurred: ${e.message}',
      );
    } on DataParsingException {
      rethrow; // Allow DataParsingException to propagate
    } catch (e) {
      // Catch any other unexpected errors
      throw ApiException('Unexpected error: $e');
    }

    return allSites;
  }

  @override
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsFromApi(
      String token) async {
    try {
      final response = await _dio.get(
        '/monitorings/sites_groups',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.data['items'];
        return jsonData
            .map((item) => SiteGroupsWithModulesLabel.fromJson(item))
            .toList();
      }
      throw ApiException('Failed to fetch site groups',
          statusCode: response.statusCode);
    } catch (e) {
      throw ApiException('Failed to fetch site groups from API: $e');
    }
  }
}
