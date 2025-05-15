import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';

class AuthenticationApiImpl implements AuthenticationApi {
  @override
  Future<UserEntity> login(String identifiant, String password) async {
    final options = {
      'login': identifiant,
      'password': password,
      'id_application': 1,
    };

    var apiBase = Config.apiBase;
    try {
      Response response = await Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        )).post(
        "$apiBase/auth/login",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(options),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['user'] != null) {
          return UserEntity.fromJson(data);
        } else {
          throw Exception("Invalid response data: ${response.data}");
        }
      } else {
        throw Exception("Failed to login: ${response.statusCode}");
      }
    } catch (e) {
      // Error is thrown to be handled by calling code
      rethrow;
    }
  }
}
