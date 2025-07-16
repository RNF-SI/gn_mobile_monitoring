import 'package:dio/dio.dart';
import '../../../../domain/model/permission.dart';
import '../../interface/permission_api_datasource.dart';

class PermissionApiImpl implements PermissionApiDataSource {
  final Dio dio;

  PermissionApiImpl({required this.dio});

  @override
  Future<Permission> getPermissions(String moduleCode) async {
    try {
      final response = await dio.get(
        '/api/monitorings/permissions/$moduleCode',
      );

      if (response.statusCode == 200) {
        final data = response.data;
        
        return Permission(
          moduleCode: moduleCode,
          visits: PermissionLevel.fromJson(data['visits']),
          sites: PermissionLevel.fromJson(data['sites']),
          lastSync: DateTime.now(),
        );
      } else {
        throw Exception('Failed to get permissions: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}