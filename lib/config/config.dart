// Configuration file for app-wide settings
//
// This file provides a central location for configuration values,
// especially the API URL which is set by the user in the login page.

// Main configuration facade
class Config {
  // Default base URL to use if no custom URL is provided
  static const String defaultBaseUrl = "http://127.0.0.1:8000";
  
  // Stored base URL from localStorage (without /api)
  static String? _storedBaseUrl;

  // Set the base URL from localStorage
  static void setStoredApiUrl(String? baseUrl) {
    if (baseUrl != null) {
      _storedBaseUrl = normalizeUserInputUrl(baseUrl);
    } else {
      _storedBaseUrl = null;
    }
  }

  /// Nettoie une URL saisie par l'utilisateur :
  /// - trim + ajout du schéma https:// par défaut si aucun n'est fourni
  /// - retrait de la query (`?...`) et du fragment (`#/login`, `#/home`, …)
  ///   typiquement présents quand l'URL est copiée depuis la SPA GeoNature
  /// - retrait du slash final et du suffixe /api
  static String normalizeUserInputUrl(String rawUrl) {
    String cleanUrl = rawUrl.trim();
    if (cleanUrl.isEmpty) return cleanUrl;

    if (!cleanUrl.startsWith('http://') &&
        !cleanUrl.startsWith('https://')) {
      cleanUrl = 'https://$cleanUrl';
    }

    Uri parsed;
    try {
      parsed = Uri.parse(cleanUrl);
    } catch (_) {
      return cleanUrl;
    }
    if (!parsed.hasAuthority) return cleanUrl;

    String path = parsed.path;
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    if (path.endsWith('/api')) {
      path = path.substring(0, path.length - 4);
    }

    final cleaned = Uri(
      scheme: parsed.scheme,
      userInfo: parsed.userInfo.isEmpty ? null : parsed.userInfo,
      host: parsed.host,
      port: parsed.hasPort ? parsed.port : null,
      path: path,
    );
    return cleaned.toString();
  }

  /// Indique si l'URL utilise le schéma HTTP non sécurisé contre un host
  /// qui n'est pas un environnement de développement local.
  /// Utile pour afficher un avertissement dans l'écran de connexion.
  static bool isInsecureHttpForProduction(String url) {
    final trimmed = url.trim();
    if (!trimmed.startsWith('http://')) {
      return false;
    }
    return !_isDevEnvironment(trimmed);
  }

  // Clear the stored URL
  static void clearStoredApiUrl() {
    _storedBaseUrl = null;
  }

  // Get the base URL (without /api) - internal use only
  static String get baseUrl {
    // If a URL is stored in localStorage, use it
    if (_storedBaseUrl != null && _storedBaseUrl!.isNotEmpty) {
      return _storedBaseUrl!;
    }

    // If no URL is stored, return the default URL
    return defaultBaseUrl;
  }

  // Check if the current URL is a development environment (local server)
  static bool _isDevEnvironment(String url) {
    return url.contains('localhost') ||
           url.contains('127.0.0.1') ||
           url.contains(':8000') ||
           url.contains(':8001') ||
           url.contains(':5000') ||
           url.contains(':3000') ||
           url.contains(':4000');
  }

  // Get the API base URL - used for ALL API calls including authentication
  // Adapted for dev vs prod environment
  static String get apiBase {
    final base = baseUrl;
    
    // In development (local server), don't add /api
    if (_isDevEnvironment(base)) {
      return base;
    }
    
    // In production (with Apache), add /api for all routes including auth
    return "$base/api";
  }

  // Get debug information about the current configuration
  static String getDebugInfo() {
    final base = baseUrl;
    final api = apiBase;
    final isDev = _isDevEnvironment(base);
    
    return '''
Config Debug Info:
- Base URL: $base
- API URL (for all routes): $api  
- Environment: ${isDev ? 'Development' : 'Production'}
- Auth URL: $api/auth/login
- Modules URL: $api/monitorings/modules
''';
  }

  // Backward compatibility - keep the old property name
  static String get defaultApiUrl => defaultBaseUrl;
}
