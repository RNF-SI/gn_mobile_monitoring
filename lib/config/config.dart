// Configuration file that works in both local development and CI environments
//
// The imports are commented out to allow CI builds to pass.
// In a local development environment, uncomment these imports and 
// create the corresponding files with appropriate API endpoints.
//
// import 'config_dev.dart';
// import 'config_prod.dart'; 

// Configuration classes for development and production
// These will be used when the real config files are not available (CI)
class ConfigDev {
  static const String apiBase = 'https://dev-api-placeholder.example.com';
}

class ConfigProd {
  static const String apiBase = 'https://prod-api-placeholder.example.com';
}

// Main configuration facade
class Config {
  static String get apiBase {
    const environment = String.fromEnvironment('ENV', defaultValue: 'DEV');
    if (environment == 'PROD') {
      return ConfigProd.apiBase;
    } else {
      return ConfigDev.apiBase;
    }
  }
}
