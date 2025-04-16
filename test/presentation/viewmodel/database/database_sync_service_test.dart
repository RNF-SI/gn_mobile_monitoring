import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

class MockAuthenticationViewModel extends Mock
    implements AuthenticationViewModel {}

class MockUserModulesViewModel extends Mock implements UserModulesViewModel {}

class MockUserSitesViewModel extends Mock implements UserSitesViewModel {}

class MockSiteGroupsViewModel extends Mock implements SiteGroupsViewModel {}

class MockRef extends Mock implements Ref {}

class MockFetchModulesUseCase extends Mock implements FetchModulesUseCase {}

class MockFetchSitesUseCase extends Mock implements FetchSitesUseCase {}

class MockFetchSiteGroupsUseCase extends Mock
    implements FetchSiteGroupsUseCase {}

void main() {
  late DatabaseSyncService databaseSyncService;
  late MockDatabaseService mockDatabaseService;
  late MockAuthenticationViewModel mockAuthViewModel;
  late MockUserModulesViewModel mockModulesViewModel;
  late MockUserSitesViewModel mockSitesViewModel;
  late MockSiteGroupsViewModel mockSiteGroupsViewModel;
  late MockRef mockRef;
  late MockFetchModulesUseCase mockFetchModulesUseCase;
  late MockFetchSitesUseCase mockFetchSitesUseCase;
  late MockFetchSiteGroupsUseCase mockFetchSiteGroupsUseCase;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockAuthViewModel = MockAuthenticationViewModel();
    mockModulesViewModel = MockUserModulesViewModel();
    mockSitesViewModel = MockUserSitesViewModel();
    mockSiteGroupsViewModel = MockSiteGroupsViewModel();
    mockRef = MockRef();
    mockFetchModulesUseCase = MockFetchModulesUseCase();
    mockFetchSitesUseCase = MockFetchSitesUseCase();
    mockFetchSiteGroupsUseCase = MockFetchSiteGroupsUseCase();

    when(() => mockRef.read(fetchModulesUseCaseProvider))
        .thenReturn(mockFetchModulesUseCase);
    when(() => mockRef.read(fetchSitesUseCaseProvider))
        .thenReturn(mockFetchSitesUseCase);
    when(() => mockRef.read(fetchSiteGroupsUseCaseProvider))
        .thenReturn(mockFetchSiteGroupsUseCase);

    databaseSyncService = DatabaseSyncService(
      mockDatabaseService,
      mockAuthViewModel,
      mockModulesViewModel,
      mockSitesViewModel,
      mockSiteGroupsViewModel,
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
      when(() => mockFetchSitesUseCase.execute(testToken))
          .thenAnswer((_) async {});
      when(() => mockFetchSiteGroupsUseCase.execute(testToken))
          .thenAnswer((_) async {});
      when(() => mockModulesViewModel.loadModules()).thenAnswer((_) async {});
      when(() => mockSitesViewModel.loadSites()).thenAnswer((_) async {});
      when(() => mockSiteGroupsViewModel.refreshSiteGroups())
          .thenAnswer((_) async {});

      // Act
      await databaseSyncService.deleteAndReinitializeDatabase(testToken);

      // Assert - verify operations happen in correct order
      verifyInOrder([
        () => mockDatabaseService.deleteAndReinitializeDatabase(),
        () => mockFetchModulesUseCase.execute(testToken),
        () => mockFetchSitesUseCase.execute(testToken),
        () => mockFetchSiteGroupsUseCase.execute(testToken),
        () => mockModulesViewModel.loadModules(),
        () => mockSitesViewModel.loadSites(),
        () => mockSiteGroupsViewModel.refreshSiteGroups(),
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
      verifyNever(() => mockFetchSitesUseCase.execute(any()));
      verifyNever(() => mockFetchSiteGroupsUseCase.execute(any()));
      verifyNever(() => mockModulesViewModel.loadModules());
      verifyNever(() => mockSitesViewModel.loadSites());
      verifyNever(() => mockSiteGroupsViewModel.refreshSiteGroups());
    });

    test('should throw when fetch modules fails', () async {
      // Arrange
      when(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .thenAnswer((_) async => true);
      when(() => mockFetchModulesUseCase.execute(testToken))
          .thenThrow(Exception('Failed to fetch modules'));

      // Act & Assert
      await expectLater(
        () => databaseSyncService.deleteAndReinitializeDatabase(testToken),
        throwsA(isA<Exception>()),
      );

      // Wait for all async operations to complete
      await Future.delayed(Duration.zero);

      // Verify the order of calls
      verify(() => mockDatabaseService.deleteAndReinitializeDatabase())
          .called(1);
      verify(() => mockFetchModulesUseCase.execute(testToken)).called(1);
      verifyNoMoreInteractions(mockDatabaseService);
      verifyNoMoreInteractions(mockFetchModulesUseCase);
    });
  });

  group('refreshAllLists', () {
    test('should refresh all lists in correct order', () async {
      // Arrange
      when(() => mockModulesViewModel.loadModules()).thenAnswer((_) async {});
      when(() => mockSitesViewModel.loadSites()).thenAnswer((_) async {});
      when(() => mockSiteGroupsViewModel.refreshSiteGroups())
          .thenAnswer((_) async {});

      // Act
      await databaseSyncService.refreshAllLists();

      // Assert - verify operations happen in correct order
      verifyInOrder([
        () => mockModulesViewModel.loadModules(),
        () => mockSitesViewModel.loadSites(),
        () => mockSiteGroupsViewModel.refreshSiteGroups(),
      ]);
    });

    test('should throw when loadModules fails', () async {
      // Arrange
      when(() => mockModulesViewModel.loadModules())
          .thenThrow(Exception('Load modules failed'));

      // Act & Assert
      expect(() => databaseSyncService.refreshAllLists(), throwsException);

      verify(() => mockModulesViewModel.loadModules()).called(1);
      verifyNever(() => mockSitesViewModel.loadSites());
      verifyNever(() => mockSiteGroupsViewModel.refreshSiteGroups());
    });
  });
}

// Mock UseCase class for testing
class MockUseCase {
  Future<void> execute(String token) async {}
}
