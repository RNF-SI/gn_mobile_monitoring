import 'package:gn_mobile_monitoring/data/db/dao/app_metadata_dao.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:mocktail/mocktail.dart';

import 'app_metadata_dao_mock.dart';

/// Classe statique pour initialiser les mocks communs utilisés dans les tests
class MockSetup {
  /// Instance du mock AppMetadataDao
  static final MockAppMetadataDao _appMetadataDao = MockAppMetadataDao();
  
  /// Obtient le mock AppMetadataDao
  static MockAppMetadataDao get appMetadataDao => _appMetadataDao;
  
  /// Initialise tous les mocks avec leurs comportements par défaut
  static void initializeMocks() {
    // Ne rien faire ici car nous utilisons mocktail et non mockito
  }
  
  /// Initialise la base de données de test avec les mocks configurés
  static void setupTestDatabase(AppDatabase db) {
    // Remplacer les DAOs réels par des mocks
    db.appMetadataDao = _appMetadataDao;
  }
  
  /// Initialise l'environnement de test complet (à appeler dans setUp)
  static Future<void> initializeTestEnvironment() async {
    // Activer le mode test
    AppDatabase.setTestingMode(true);
    
    // Initialiser les mocks
    initializeMocks();
    
    // Configurer la base de données
    final db = await AppDatabase.getTestInstance();
    setupTestDatabase(db);
  }
  
  /// Réinitialise l'état des mocks (pour utilisation entre les tests)
  static void resetMocks() {
    // Ne rien faire ici car nous utilisons mocktail
  }
  
  /// Réinitialise l'environnement de test complet (à appeler dans tearDown)
  static Future<void> tearDownTestEnvironment() async {
    // Réinitialiser les mocks
    resetMocks();
    
    // Réinitialiser la base de données
    await AppDatabase.resetInstance();
  }
}