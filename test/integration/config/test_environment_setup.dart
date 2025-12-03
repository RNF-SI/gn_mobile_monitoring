import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'test_server_config.dart';

/// Classe utilitaire pour initialiser et nettoyer l'environnement de tests d'intégration
class TestEnvironmentSetup {
  static TestServerConfig? _config;
  static AppDatabase? _database;

  /// Récupère la configuration du serveur de test (singleton)
  /// Retourne null si la configuration n'est pas disponible
  static Future<TestServerConfig?> getConfig() async {
    _config ??= await TestServerConfig.load();
    return _config;
  }

  /// Initialise la base de données de test
  static Future<AppDatabase> initDatabase() async {
    if (_database == null) {
      AppDatabase.setTestingMode(true);
      _database = await AppDatabase.getTestInstance();
    }
    return _database!;
  }

  /// Nettoie la base de données de test
  /// Pour les tests d'intégration, on réinitialise complètement l'instance
  static Future<void> cleanDatabase() async {
    await AppDatabase.resetInstance();
    _database = null;
    // Réinitialiser pour le prochain test
    await initDatabase();
  }

  /// Ferme la base de données de test
  static Future<void> closeDatabase() async {
    await AppDatabase.resetInstance();
    _database = null;
  }

  /// Setup global avant tous les tests
  static Future<void> setUpAll() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Charger la configuration
    final config = await getConfig();
    if (config != null) {
      print('📋 Configuration de test chargée: ${config.url}');
    } else {
      print('⚠️  Aucune configuration de test disponible - tests skippés');
    }

    // Initialiser la base de données
    await initDatabase();
    print('🗄️  Base de données de test initialisée');
  }

  /// Teardown global après tous les tests
  static Future<void> tearDownAll() async {
    await closeDatabase();
    print('✅ Base de données de test fermée');
  }

  /// Setup avant chaque test individuel
  static Future<void> setUp() async {
    // Nettoyer la base de données avant chaque test
    await cleanDatabase();
    print('🧹 Base de données nettoyée pour le test');
  }

  /// Teardown après chaque test individuel
  static Future<void> tearDown() async {
    // Optionnel: cleanup supplémentaire si nécessaire
  }
}
