import 'package:dio/dio.dart';

/// Convertit n'importe quelle exception remontée pendant la connexion en un
/// message lisible pour l'utilisateur, accompagné de détails techniques pour
/// le report de bugs (affichés dans `showCopyableErrorDialog`).
///
/// Les messages génériques de Dio (« Connection closed before full header was
/// received », « SocketException: Failed host lookup ») ne sont pas exploitables
/// pour un utilisateur de terrain : on les traduit en explications + actions
/// concrètes.
class LoginErrorMessage {
  final String message;
  final Map<String, Object?> details;

  const LoginErrorMessage({required this.message, required this.details});

  factory LoginErrorMessage.from(Object error) {
    if (error is DioException) return _fromDio(error);

    // Les Exception levées par AuthenticationApiImpl portent déjà un message
    // français lisible (« Le serveur redirige vers HTTPS… », etc.). Garder
    // tel quel, sans le préfixe « Exception: » de Dart.
    final raw = error.toString();
    return LoginErrorMessage(
      message: _stripExceptionPrefix(raw),
      details: const {},
    );
  }

  static LoginErrorMessage _fromDio(DioException e) {
    final details = <String, Object?>{
      'type': e.type.name,
      if (e.message != null) 'message': e.message,
      if (e.response?.statusCode != null) 'statusCode': e.response!.statusCode,
      if (e.response?.data != null) 'data': e.response!.data,
      if (e.requestOptions.uri.toString().isNotEmpty)
        'url': e.requestOptions.uri.toString(),
    };

    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message =
            'Délai dépassé : le serveur ne répond pas. Vérifiez votre connexion '
            "réseau et l'URL du serveur.";
        break;
      case DioExceptionType.connectionError:
        message = "Connexion impossible. Vérifiez que vous avez Internet et "
            "que l'URL du serveur est correcte.";
        break;
      case DioExceptionType.badCertificate:
        message = "Le certificat HTTPS du serveur est invalide ou expiré. "
            "Contactez l'administrateur du serveur.";
        break;
      case DioExceptionType.cancel:
        message = 'Connexion interrompue.';
        break;
      case DioExceptionType.badResponse:
        message = _formatBadResponse(e);
        break;
      case DioExceptionType.unknown:
        message = _formatUnknown(e);
        break;
    }

    return LoginErrorMessage(message: message, details: details);
  }

  static String _formatBadResponse(DioException e) {
    final code = e.response?.statusCode;
    if (code == null) {
      return 'Réponse invalide du serveur.';
    }
    if (code == 404) {
      return "URL introuvable (404). Vérifiez que l'URL du serveur pointe bien "
          'sur une instance GeoNature.';
    }
    if (code >= 500 && code < 600) {
      return 'Le serveur a renvoyé une erreur interne ($code). '
          "Réessayez plus tard ou contactez l'administrateur du serveur.";
    }
    if (code >= 400 && code < 500) {
      return 'Le serveur a refusé la requête ($code).';
    }
    return 'Réponse inattendue du serveur (code $code).';
  }

  static String _formatUnknown(DioException e) {
    final raw = e.message ?? '';
    // Erreur DNS la plus fréquente quand l'URL est mal saisie.
    if (raw.contains('Failed host lookup')) {
      return "Impossible de joindre le serveur : le nom de domaine n'a pas pu "
          "être résolu. Vérifiez l'URL et votre connexion.";
    }
    if (raw.contains('Connection refused')) {
      return "Le serveur a refusé la connexion. Vérifiez l'URL et le port.";
    }
    return "Erreur réseau inattendue. Réessayez ou contactez l'administrateur.";
  }

  static String _stripExceptionPrefix(String raw) {
    const prefix = 'Exception: ';
    return raw.startsWith(prefix) ? raw.substring(prefix.length) : raw;
  }
}
