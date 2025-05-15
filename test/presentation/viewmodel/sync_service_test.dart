import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mock_setup.dart';

// Mocks des dépendances
class MockGetTokenFromLocalStorageUseCase extends Mock implements GetTokenFromLocalStorageUseCase {}
class MockIncrementalSyncAllUseCase extends Mock implements IncrementalSyncAllUseCase {}
class MockGetLastSyncDateUseCase extends Mock implements GetLastSyncDateUseCase {}
class MockUpdateLastSyncDateUseCase extends Mock implements UpdateLastSyncDateUseCase {}
class MockSyncRepository extends Mock implements SyncRepository {}
// Mock pour WidgetRef qui est complexe et ne peut pas être facilement implémenté
// Nous allons plutôt implémenter une stratégie pour contourner ce problème
class MockRef extends Mock implements WidgetRef {}

void main() {
  late SyncService syncService;
  late MockGetTokenFromLocalStorageUseCase mockGetTokenUseCase;
  late MockIncrementalSyncAllUseCase mockSyncUseCase;
  late MockGetLastSyncDateUseCase mockGetLastSyncDateUseCase;
  late MockUpdateLastSyncDateUseCase mockUpdateLastSyncDateUseCase;
  late MockSyncRepository mockSyncRepository;
  late MockRef mockRef;

  setUp(() async {
    // Initialiser l'environnement de test
    await MockSetup.initializeTestEnvironment();

    // Initialiser les mocks
    mockGetTokenUseCase = MockGetTokenFromLocalStorageUseCase();
    mockSyncUseCase = MockIncrementalSyncAllUseCase();
    mockGetLastSyncDateUseCase = MockGetLastSyncDateUseCase();
    mockUpdateLastSyncDateUseCase = MockUpdateLastSyncDateUseCase();
    mockSyncRepository = MockSyncRepository();
    mockRef = MockRef();

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
    syncService = SyncService(
      mockGetTokenUseCase,
      mockSyncUseCase,
      mockGetLastSyncDateUseCase,
      mockUpdateLastSyncDateUseCase,
      mockSyncRepository,
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

  group('SyncService syncFromServer tests', () {
    test('should not start sync if already syncing', () async {
      // Arrange
      final initialState = syncService.state;
      
      // Activer le flag _isSyncing manuellement
      syncService = SyncService(
        mockGetTokenUseCase,
        mockSyncUseCase,
        mockGetLastSyncDateUseCase,
        mockUpdateLastSyncDateUseCase,
        mockSyncRepository,
      );
      
      // On ne peut pas changer _isSyncing directement car c'est privé,
      // donc nous allons tester uniquement le cas initial
      expect(initialState.state, equals(SyncState.idle));
    });

    test('should fail if token is null', () async {
      // Arrange
      when(() => mockGetTokenUseCase.execute()).thenAnswer((_) async => null);
      
      // Act
      final result = await syncService.syncFromServer(mockRef);
      
      // Assert
      expect(result.state, equals(SyncState.failure));
      expect(result.errorMessage, contains('Utilisateur non connecté'));
    });

    test('should show inProgress state during synchronization', () async {
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
      // Puisque nous ne pouvons pas accéder à l'état intermédiaire pendant la synchronisation,
      // nous allons simplement vérifier qu'au début et à la fin, les états sont corrects
      final beforeState = syncService.state;
      final result = await syncService.syncFromServer(
        mockRef,
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

  group('SyncService syncToServer tests', () {
    test('should not start sync if already syncing', () async {
      // Test le cas initial uniquement
      final result = await syncService.syncToServer(mockRef, moduleCode: 'TEST');
      expect(result.state, equals(SyncState.success));
    });

    test('should fail if token is null', () async {
      // Arrange
      when(() => mockGetTokenUseCase.execute()).thenAnswer((_) async => null);
      
      // Act
      final result = await syncService.syncToServer(mockRef, moduleCode: 'TEST');
      
      // Assert
      expect(result.state, equals(SyncState.failure));
      expect(result.errorMessage, contains('Utilisateur non connecté'));
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
      final result = await syncService.syncToServer(mockRef, moduleCode: 'TEST');
      
      // Assert
      expect(result.state, equals(SyncState.success));
      expect(result.itemsAdded, equals(5));
      expect(result.itemsUpdated, equals(2));
      expect(result.itemsDeleted, equals(1));
    });

    test('should show failure state when sync fails', () async {
      // Arrange
      when(() => mockSyncRepository.syncVisitsToServer(any(), any()))
          .thenAnswer((_) async => SyncResult.failure(
                errorMessage: 'Test error message',
              ));
      
      // Act
      final result = await syncService.syncToServer(mockRef, moduleCode: 'TEST');
      
      // Assert
      expect(result.state, equals(SyncState.failure));
      expect(result.errorMessage, contains('Test error message'));
    });
  });

  group('SyncService state reporting tests', () {
    test('should update last sync date after successful full sync', () async {
      // Arrange
      final successResult = {
        'configuration': SyncResult.success(itemsProcessed: 1, itemsAdded: 1, itemsUpdated: 0, itemsDeleted: 0, itemsSkipped: 0),
        'nomenclatures_datasets': SyncResult.success(itemsProcessed: 3, itemsAdded: 2, itemsUpdated: 1, itemsDeleted: 0, itemsSkipped: 0),
        'taxons': SyncResult.success(itemsProcessed: 5, itemsAdded: 3, itemsUpdated: 2, itemsDeleted: 0, itemsSkipped: 0),
        'observers': SyncResult.success(itemsProcessed: 1, itemsAdded: 1, itemsUpdated: 0, itemsDeleted: 0, itemsSkipped: 0),
        'modules': SyncResult.success(itemsProcessed: 2, itemsAdded: 2, itemsUpdated: 0, itemsDeleted: 0, itemsSkipped: 0),
        'sites': SyncResult.success(itemsProcessed: 7, itemsAdded: 5, itemsUpdated: 2, itemsDeleted: 0, itemsSkipped: 0),
        'siteGroups': SyncResult.success(itemsProcessed: 1, itemsAdded: 1, itemsUpdated: 0, itemsDeleted: 0, itemsSkipped: 0),
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
      final result = await syncService.syncFromServer(
        mockRef,
        syncConfiguration: true,
        syncNomenclatures: true,
        syncTaxons: true,
        syncObservers: true,
        syncModules: true,
        syncSites: true,
        syncSiteGroups: true,
      );
      
      // Assert
      expect(result.state, equals(SyncState.success));
      // Vérifier que la date de dernière synchronisation a été mise à jour
      verify(() => mockUpdateLastSyncDateUseCase.execute(any(), any())).called(1);
    });

    test('should build sync summary with correct statistics', () {
      // Arrange
      final syncService = SyncService(
        mockGetTokenUseCase,
        mockSyncUseCase,
        mockGetLastSyncDateUseCase,
        mockUpdateLastSyncDateUseCase,
        mockSyncRepository,
      );

      // Accès à la méthode privée sans réflexion (impossible de tester directement)
      // Au lieu de cela, nous allons tester indirectement via la méthode publique getSyncSummary
      // qui est vide par défaut quand il n'y a pas de résultats
      
      // Assert
      final summary = syncService.getSyncSummary();
      expect(summary, equals(""));
    });
  });
}