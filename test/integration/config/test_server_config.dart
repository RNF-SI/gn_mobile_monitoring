import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration du serveur GeoNature de test pour les tests d'intégration.
///
/// Charge les credentials et l'URL du serveur depuis le fichier .env.test
/// ou depuis les variables d'environnement (pour la CI/CD).
class TestServerConfig {
  final String url;
  final String username;
  final String password;
  final List<String> availableModules;

  TestServerConfig({
    required this.url,
    required this.username,
    required this.password,
    required this.availableModules,
  });

  /// Charge la configuration depuis .env.test ou variables d'environnement
  /// Retourne null si la configuration n'est pas disponible (permet de skip les tests)
  static Future<TestServerConfig?> load() async {
    // Essayer de charger depuis .env.test (développement local)
    try {
      // Essayer plusieurs chemins possibles pour le fichier .env.test
      String? envFilePath;
      
      // Dans le répertoire de travail actuel
      var envFile = File('.env.test');
      if (await envFile.exists()) {
        envFilePath = '.env.test';
      } else {
        // Essayer depuis la racine du projet (chemin relatif depuis test/)
        var possiblePaths = [
          '../../../../.env.test',  // Depuis test/integration/config/
          '../../../.env.test',     // Depuis test/integration/
          '../../.env.test',        // Depuis test/
          '.env.test',              // Répertoire courant
        ];
        
        for (final path in possiblePaths) {
          envFile = File(path);
          if (await envFile.exists()) {
            envFilePath = path;
            break;
          }
        }
      }
      
      if (envFilePath != null) {
        await dotenv.load(fileName: envFilePath, mergeWith: Platform.environment);
        print('✅ Fichier .env.test chargé depuis: $envFilePath');
      } else {
        throw FileSystemException('Fichier .env.test non trouvé');
      }
    } catch (e) {
      // Si le fichier n'existe pas, on utilisera les variables d'environnement (CI/CD)
      print('⚠️  Fichier .env.test non trouvé, utilisation des variables d\'environnement');
      print('   Erreur: $e');
    }

    // Récupérer les valeurs (depuis .env.test ou variables d'environnement)
    try {
      final url = _getEnvVar('TEST_SERVER_URL');
      final username = _getEnvVar('TEST_USERNAME');
      final password = _getEnvVar('TEST_PASSWORD');
      final modulesStr = _getEnvVar('TEST_MODULES', defaultValue: 'POPAAMPHIBIEN,POPREPTILE');

      final modules = modulesStr
          .split(',')
          .map((m) => m.trim())
          .where((m) => m.isNotEmpty)
          .toList();

      return TestServerConfig(
        url: url,
        username: username,
        password: password,
        availableModules: modules,
      );
    } catch (e) {
      // Si la configuration n'est pas disponible, retourner null
      // Cela permet aux tests d'intégration de se skip proprement
      print('⚠️  Configuration de test non disponible: $e');
      print('💡 Les tests d\'intégration seront skippés');
      return null;
    }
  }

  /// Récupère une variable d'environnement depuis .env.test ou Platform.environment
  static String _getEnvVar(String key, {String? defaultValue}) {
    // Essayer depuis dotenv (.env.test) si disponible
    try {
      if (dotenv.isInitialized && dotenv.env.containsKey(key) && dotenv.env[key]!.isNotEmpty) {
        return dotenv.env[key]!;
      }
    } catch (e) {
      // dotenv not initialized, skip
    }

    // Essayer depuis les variables d'environnement système (CI/CD)
    if (Platform.environment.containsKey(key)) {
      return Platform.environment[key]!;
    }

    // Si aucune valeur trouvée et qu'il y a une valeur par défaut
    if (defaultValue != null) {
      return defaultValue;
    }

    // Sinon, erreur
    throw Exception(
      'Variable d\'environnement "$key" manquante. '
      'Vérifiez votre fichier .env.test ou vos variables d\'environnement.'
    );
  }

  @override
  String toString() {
    return 'TestServerConfig(url: $url, username: $username, modules: $availableModules)';
  }
}
