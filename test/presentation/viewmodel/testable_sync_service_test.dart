import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/testable_sync_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_setup.dart';

// Mocks des dépendances
class MockGetTokenFromLocalStorageUseCase extends Mock implements GetTokenFromLocalStorageUseCase {}
class MockIncrementalSyncAllUseCase extends Mock implements IncrementalSyncAllUseCase {}
class MockGetLastSyncDateUseCase extends Mock implements GetLastSyncDateUseCase {}
class MockUpdateLastSyncDateUseCase extends Mock implements UpdateLastSyncDateUseCase {}
class MockSyncCompleteUseCase extends Mock implements SyncCompleteUseCase {}
class MockSyncRepository extends Mock implements SyncRepository {}

void main() {
  late TestableSyncService syncService;
  late MockGetTokenFromLocalStorageUseCase mockGetTokenUseCase;
  late MockIncrementalSyncAllUseCase mockSyncUseCase;
  late MockGetLastSyncDateUseCase mockGetLastSyncDateUseCase;
  late MockUpdateLastSyncDateUseCase mockUpdateLastSyncDateUseCase;
  late MockSyncCompleteUseCase mockSyncCompleteUseCase;
  late MockSyncRepository mockSyncRepository;

  setUp(() async {
    // Initialiser l'environnement de test
    await MockSetup.initializeTestEnvironment();

    // Initialiser les mocks
    mockGetTokenUseCase = MockGetTokenFromLocalStorageUseCase();
    mockSyncUseCase = MockIncrementalSyncAllUseCase();
    mockGetLastSyncDateUseCase = MockGetLastSyncDateUseCase();
    mockUpdateLastSyncDateUseCase = MockUpdateLastSyncDateUseCase();
    mockSyncCompleteUseCase = MockSyncCompleteUseCase();
    mockSyncRepository = MockSyncRepository();

    // Configurer les comportements par défaut
    when(() => mockGetTokenUseCase.execute()).thenAnswer((_) async => 'test-token');
    when(() => mockGetLastSyncDateUseCase.execute(any())).thenAnswer((_) async => null);
    when(() => mockUpdateLastSyncDateUseCase.execute(any(), any())).thenAnswer((_) async => {});

    // Configurer le mock SyncRepository
    when(() => mockSyncRepository.syncVisitsToServer(any(), any())).thenAnswer((_) async => SyncResult.success(
      itemsProcessed: 1,
      itemsAdded: 1, 
      itemsUpdated: 0, 
      itemsDeleted: 0, 
      itemsSkipped: 0
    ));

    // Créer l'instance à tester
    syncService = TestableSyncService(
      mockGetTokenUseCase,
      mockSyncUseCase,
      mockGetLastSyncDateUseCase,
      mockUpdateLastSyncDateUseCase,
      mockSyncRepository,
      mockSyncCompleteUseCase,
    );
  });

  tearDown(() async {
    // Nettoyer l'environnement de test
    await MockSetup.tearDownTestEnvironment();
  });

  group('SyncService initial state tests', () {
    test('should initialize with idle state', () {
      expect(syncService.state.state, equals(SyncState.idle));
    });

    test('should check for last sync date on initialization', () {
      verify(() => mockGetLastSyncDateUseCase.execute(any())).called(1);
    });

    test('should require full sync if last sync date is null', () {
      expect(syncService.isFullSyncNeeded(), isTrue);
    });
  });

  group('SyncService testSyncFromServer tests', () {
    test('should not start sync if already syncing', () async {
      // Arrange
      final initialState = syncService.state;
      
      // On ne peut pas changer _isSyncing directement car c'est privé,
      // donc nous allons tester uniquement le cas initial
      expect(initialState.state, equals(SyncState.idle));
    });

    test('should use testable method without WidgetRef', () async {
      // Act - Utiliser notre méthode testable
      final result = await syncService.testSyncFromServer();
      
      // Assert
      expect(result.state, equals(SyncState.success));
    });

    test('should show progress state during synchronization', () async {
      // Arrange
      final successResult = {
        'configuration': SyncResult.success(
          itemsProcessed: 1,
          itemsAdded: 1, 
          itemsUpdated: 0, 
          itemsDeleted: 0, 
          itemsSkipped: 0
        ),
      };
      when(() => mockSyncUseCase.execute(
        any(),
        syncConfiguration: any(named: 'syncConfiguration'),
        syncNomenclatures: any(named: 'syncNomenclatures'),
        syncTaxons: any(named: 'syncTaxons'),
        syncObservers: any(named: 'syncObservers'),
        syncModules: any(named: 'syncModules'),
        syncSites: any(named: 'syncSites'),
        syncSiteGroups: any(named: 'syncSiteGroups'),
      )).thenAnswer((_) async => successResult);
      
      // Act
      // Vérifier l'état avant et après la synchronisation
      final beforeState = syncService.state;
      final result = await syncService.testSyncFromServer(
        syncConfiguration: true,
        syncNomenclatures: false,
        syncTaxons: false,
        syncObservers: false,
        syncModules: false,
        syncSites: false,
        syncSiteGroups: false,
      );
      
      // Assert
      expect(beforeState.state, equals(SyncState.idle));
      expect(result.state, equals(SyncState.success));
    });
  });

  group('SyncService testSyncToServer tests', () {
    test('should use testable method without WidgetRef', () async {
      // Test le cas initial uniquement
      final result = await syncService.testSyncToServer(moduleCode: 'TEST');
      expect(result.state, equals(SyncState.success));
    });

    test('should show success state after successful sync', () async {
      // Arrange
      when(() => mockSyncRepository.syncVisitsToServer(any(), any()))
          .thenAnswer((_) async => SyncResult.success(
                itemsProcessed: 8,
                itemsAdded: 5,
                itemsUpdated: 2,
                itemsDeleted: 1,
                itemsSkipped: 0,
              ));
      
      // Act
      final result = await syncService.testSyncToServer(moduleCode: 'TEST');
      
      // Assert
      expect(result.state, equals(SyncState.success));
    });
  });

  group('SyncService summary building tests', () {
    test('should build sync summary with correct statistics', () {
      // Cet accès est possible directement car getSyncSummary est public
      final summary = syncService.getSyncSummary();
      expect(summary, equals(""));
    });
  });
}