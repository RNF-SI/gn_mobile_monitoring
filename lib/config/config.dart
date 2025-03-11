// Define configs directly here for CI environments
class ConfigDev {
  static const String apiBase = 'https://dev-api-placeholder.example.com';
}

class ConfigProd {
  static const String apiBase = 'https://prod-api-placeholder.example.com';
}

// In normal environments, the above classes will be overridden 
// by the actual config_dev.dart and config_prod.dart files

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
