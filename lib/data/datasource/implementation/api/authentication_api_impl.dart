import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/bad_credentials_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';

class AuthenticationApiImpl extends BaseApi implements AuthenticationApi {
  AuthenticationApiImpl({super.dio});

  @override
  Future<UserEntity> login(String identifiant, String password) async {
    final options = {
      'login': identifiant,
      'password': password,
      'id_application': 1,
    };

    try {
      Response response = await dio.post(
        "/auth/login",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          // Ne pas suivre les redirections : un POST suivi par Dart perd le body,
          // ce qui masque la vraie cause (typiquement un redirect http→https).
          followRedirects: false,
          // Laisser passer les 3xx et 4xx pour les traiter explicitement ci-dessous.
          validateStatus: (status) => status != null && status < 500,
        ),
        data: jsonEncode(options),
      );

      final statusCode = response.statusCode;

      // Redirection renvoyée par le serveur (typiquement Apache http→https).
      if (statusCode != null && statusCode >= 300 && statusCode < 400) {
        final location = response.headers.value('location') ?? '';
        if (location.startsWith('https://')) {
          throw Exception(
            "Le serveur redirige vers HTTPS. "
            "Modifiez l'URL du serveur pour qu'elle commence par « https:// ».",
          );
        }
        throw Exception(
          "Redirection inattendue du serveur ($statusCode) vers : $location",
        );
      }

      if (statusCode == 401) {
        throw BadCredentialsException();
      }

      if (statusCode == 200) {
        final data = response.data;
        if (data != null && data['user'] != null) {
          return UserEntity.fromJson(data);
        } else {
          throw Exception("Réponse du serveur invalide : ${response.data}");
        }
      }

      throw Exception("Échec de la connexion (code $statusCode).");
    } catch (e) {
      // Error is thrown to be handled by calling code
      rethrow;
    }
  }
}
