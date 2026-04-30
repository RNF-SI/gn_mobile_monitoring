import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/bad_credentials_exception.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/base_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';

class AuthenticationApiImpl extends BaseApi implements AuthenticationApi {
  AuthenticationApiImpl({super.dio});

  /// Garde-fou contre les boucles : un serveur GeoNature normal n'enchaîne
  /// jamais plus d'une ou deux redirections sur /auth/login.
  static const int _maxRedirects = 3;

  @override
  Future<UserEntity> login(String identifiant, String password) async {
    final body = jsonEncode({
      'login': identifiant,
      'password': password,
      'id_application': 1,
    });

    Response response = await dio.post(
      "/auth/login",
      options: _postOptions(),
      data: body,
    );

    var redirectsFollowed = 0;
    while (true) {
      final statusCode = response.statusCode;

      if (statusCode != null && statusCode >= 300 && statusCode < 400) {
        final location = response.headers.value('location') ?? '';
        final requestScheme = response.requestOptions.uri.scheme;

        // Cas spécifique HTTP→HTTPS : c'est le seul où on doit demander à
        // l'utilisateur de modifier l'URL (sinon il continuera à envoyer en
        // clair son mot de passe sur un POST que Dio ne re-rejouerait pas).
        if (requestScheme == 'http' && location.startsWith('https://')) {
          throw Exception(
            "Le serveur redirige vers HTTPS. "
            "Modifiez l'URL du serveur pour qu'elle commence par « https:// ».",
          );
        }

        if (location.isEmpty) {
          throw Exception(
            "Redirection $statusCode du serveur sans en-tête Location.",
          );
        }

        final nextUri = response.requestOptions.uri.resolve(location);

        // GeoNature renvoie un 302 vers `/#/login` quand les identifiants sont
        // invalides au lieu d'un 401 propre. Suivre le redirect tomberait sur
        // la SPA HTML, alors qu'on attend un JSON. On traite donc comme un
        // échec d'auth : (a) tout redirect avec un fragment `#` (forcément
        // vers la SPA), ou (b) un redirect qui SORT de `/api/` quand la
        // requête y était (cas prod : Apache/Gunicorn). En mode dev local
        // (`http://localhost:8000/auth/login`) la requête n'est pas sous
        // `/api/` — on ne déclenche donc pas la règle (b) et un éventuel
        // redirect interne reste suivi normalement.
        final originUnderApi =
            response.requestOptions.uri.path.contains('/api/');
        final targetUnderApi = nextUri.path.contains('/api/');
        final hasFragment = nextUri.fragment.isNotEmpty;
        if (hasFragment || (originUnderApi && !targetUnderApi)) {
          throw BadCredentialsException();
        }

        if (redirectsFollowed >= _maxRedirects) {
          throw Exception(
            "Trop de redirections lors de la connexion ($redirectsFollowed).",
          );
        }

        // Re-POST manuel : Dio en `followRedirects: true` perdrait le body
        // d'un POST sur un 301/302. On re-poste explicitement vers la nouvelle
        // URL en réutilisant le body sérialisé.
        redirectsFollowed += 1;
        response = await dio.post(
          nextUri.toString(),
          options: _postOptions(),
          data: body,
        );
        continue;
      }

      if (statusCode == 401) {
        throw BadCredentialsException();
      }

      if (statusCode == 200) {
        final json = _decodeJsonBody(response.data);
        if (json != null && json['user'] != null) {
          return UserEntity.fromJson(json);
        }
        // Cas le plus fréquent : l'URL pointe sur la racine du site web de
        // GeoNature au lieu de l'API → le serveur sert la SPA en HTML.
        // Inutile de cracher 5 ko de balises à l'utilisateur, on lui dit ce
        // qu'il faut vraiment corriger.
        if (_looksLikeHtml(response.data)) {
          throw Exception(
            "L'URL saisie ne pointe pas vers une API GeoNature : le serveur "
            "a renvoyé une page web. Vérifiez l'URL (par exemple "
            "« https://demo.geonature.fr/geonature »).",
          );
        }
        throw Exception("Réponse du serveur invalide : ${response.data}");
      }

      throw Exception("Échec de la connexion (code $statusCode).");
    }
  }

  Options _postOptions() => Options(
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        // Ne pas suivre les redirections automatiquement : un POST suivi par
        // Dart perd le body, ce qui masquerait la vraie cause (HTTP→HTTPS).
        followRedirects: false,
        // Laisser passer les 3xx et 4xx pour les traiter explicitement.
        validateStatus: (status) => status != null && status < 500,
        responseType: ResponseType.json,
      );

  /// Détecte une réponse HTML (typiquement la SPA GeoNature servie quand
  /// l'URL ne pointe pas vers l'API). Utilisé pour produire un message
  /// d'erreur compréhensible plutôt que de recracher 5 ko de balises.
  bool _looksLikeHtml(dynamic raw) {
    if (raw is! String) return false;
    final start = raw.trimLeft().toLowerCase();
    return start.startsWith('<!doctype html') || start.startsWith('<html');
  }

  /// Certains serveurs GeoNature renvoient le JSON avec un Content-Type qui
  /// empêche Dio de l'auto-décoder : on récupère alors une [String] brute au
  /// lieu d'une [Map]. On retente un [jsonDecode] manuel pour rester robuste,
  /// sans quoi `data['user']` planterait avec un TypeError « 'String' is not
  /// a subtype of 'int' of 'index' ».
  Map<String, dynamic>? _decodeJsonBody(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is String && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is Map<String, dynamic>) return decoded;
      } catch (_) {
        // Body non-JSON : on laissera l'appelant lever une exception lisible.
      }
    }
    return null;
  }
}
