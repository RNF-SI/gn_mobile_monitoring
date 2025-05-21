import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockAuthenticationViewModel extends Mock
    implements AuthenticationViewModel {}

class MockUserModulesViewModel extends Mock implements UserModulesViewModel {}

class MockRef extends Mock implements Ref {}

class MockFetchModulesUseCase extends Mock implements FetchModulesUseCase {}

void main() {
  late DatabaseSyncService databaseSyncService;
  late MockDatabaseService mockDatabaseService;
  late MockAuthenticationViewModel mockAuthViewModel;
  late MockUserModulesViewModel mockModulesViewModel;
  late MockRef mockRef;
  late MockFetchModulesUseCase mockFetchModulesUseCase;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockAuthViewModel = MockAuthenticationViewModel();
    mockModulesViewModel = MockUserModulesViewModel();
    mockRef = MockRef();
    mockFetchModulesUseCase = MockFetchModulesUseCase();

    when(() => mockRef.read(fetchModulesUseCaseProvider))
        .thenReturn(mockFetchModulesUseCase);

    databaseSyncService = DatabaseSyncService(
      mockDatabaseService,
      mockAuthViewModel,
      mockModulesViewModel,
      mockRef,
    );
  });

  group('deleteAndReinitializeDatabase', () {
    const testToken = 'test-token';

    test('should successfully delete and reinitialize database', () async {
      // Arrange
      when(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .thenAnswer((_) async {});
      when(() => mockFetchModulesUseCase.execute(testToken))
          .thenAnswer((_) async {});
      when(() => mockModulesViewModel.loadModules()).thenAnswer((_) async {});

      // Act
      await databaseSyncService.deleteAndReinitializeDatabase(testToken);

      // Assert - verify operations happen in correct order
      verifyInOrder([
        () => mockDatabaseService.deleteAndReinitializeDatabase(),
        () => mockFetchModulesUseCase.execute(testToken),
        () => mockModulesViewModel.loadModules(),
      ]);
    });

    test('should throw when database deletion fails', () async {
      // Arrange
      when(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .thenThrow(Exception('Database deletion failed'));

      // Act & Assert
      expect(
        () => databaseSyncService.deleteAndReinitializeDatabase(testToken),
        throwsException,
      );

      verify(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .called(1);
      verifyNever(() => mockFetchModulesUseCase.execute(any()));
      verifyNever(() => mockModulesViewModel.loadModules());
    });

    test('should throw when fetch modules fails', () async {
      // Arrange
      when(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .thenAnswer((_) async {});
      when(() => mockFetchModulesUseCase.execute(testToken))
          .thenThrow(Exception('Fetch modules failed'));

      // Act & Assert
      expect(
        () => databaseSyncService.deleteAndReinitializeDatabase(testToken),
        throwsException,
      );
    });

    test('should throw when loadModules fails', () async {
      // Arrange
      when(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .thenAnswer((_) async {});
      when(() => mockFetchModulesUseCase.execute(testToken))
          .thenAnswer((_) async {});
      when(() => mockModulesViewModel.loadModules())
          .thenThrow(Exception('Load modules failed'));

      // Act & Assert
      expect(
        () => databaseSyncService.deleteAndReinitializeDatabase(testToken),
        throwsException,
      );
    });
  });

  group('refreshAllLists', () {
    test('should call loadModules', () async {
      // Arrange
      when(() => mockModulesViewModel.loadModules()).thenAnswer((_) async {});

      // Act
      await databaseSyncService.refreshAllLists();

      // Assert
      verify(() => mockModulesViewModel.loadModules()).called(1);
    });

    test('should throw when loadModules fails', () async {
      // Arrange
      when(() => mockModulesViewModel.loadModules())
          .thenThrow(Exception('Load modules failed'));

      // Act & Assert
      expect(
        () => databaseSyncService.refreshAllLists(),
        throwsException,
      );

      verify(() => mockModulesViewModel.loadModules()).called(1);
    });
  });
}