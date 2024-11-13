import 'config_dev.dart';
import 'config_prod.dart';

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
