import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart'; // Import to use suppressOutput function if needed

class MockSyncRepository extends Mock implements SyncRepository {}

void main() {
  late MockSyncRepository mockSyncRepository;
  late IncrementalSyncAllUseCase useCase;

  setUp(() {
    mockSyncRepository = MockSyncRepository();
    useCase = IncrementalSyncAllUseCaseImpl(mockSyncRepository);
    // Set up default behavior for checkConnectivity
    when(() => mockSyncRepository.checkConnectivity()).thenAnswer((_) async => true);
  });

  group('IncrementalSyncAllUseCase', () {
    const testToken = 'test_token';
    final successResult = SyncResult.success(
      itemsProcessed: 5,
      itemsAdded: 2,
      itemsUpdated: 3,
      itemsSkipped: 0,
    );

    test('should call all sync methods in repository', () async {
      // Arrange
      when(() => mockSyncRepository.syncConfiguration(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncNomenclaturesAndDatasets(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncTaxons(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncObservers(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncModules(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncSites(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncSiteGroups(any())).thenAnswer((_) async => successResult);

      // Act
      final results = await useCase.execute(testToken);

      // Assert - Verify all methods were called
      verify(() => mockSyncRepository.syncConfiguration(testToken)).called(1);
      verify(() => mockSyncRepository.syncNomenclaturesAndDatasets(testToken)).called(1);
      verify(() => mockSyncRepository.syncTaxons(testToken)).called(1);
      verify(() => mockSyncRepository.syncObservers(testToken)).called(1);
      verify(() => mockSyncRepository.syncModules(testToken)).called(1);
      verify(() => mockSyncRepository.syncSites(testToken)).called(1);
      verify(() => mockSyncRepository.syncSiteGroups(testToken)).called(1);
      
      // Verify results were returned correctly
      expect(results.containsKey('configuration'), isTrue);
      expect(results.containsKey('nomenclatures_datasets'), isTrue);
      expect(results.containsKey('taxons'), isTrue);
      expect(results.containsKey('observers'), isTrue);
      expect(results.containsKey('modules'), isTrue);
      expect(results.containsKey('sites'), isTrue);
      expect(results.containsKey('siteGroups'), isTrue);
    });

    test('should handle individual repository method failures gracefully', () async {
      // Arrange
      final configException = Exception('Configuration sync error');
      when(() => mockSyncRepository.syncConfiguration(any())).thenThrow(configException);
      when(() => mockSyncRepository.syncNomenclaturesAndDatasets(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncTaxons(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncObservers(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncModules(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncSites(any())).thenAnswer((_) async => successResult);
      when(() => mockSyncRepository.syncSiteGroups(any())).thenAnswer((_) async => successResult);
      
      // Act
      final results = await suppressOutput(() => useCase.execute(testToken));
      
      // Assert - Function should complete without throwing and other methods should still be called
      expect(results['configuration']!.success, isFalse);
      expect(results['configuration']!.errorMessage, contains('Erreur lors de la synchronisation de la configuration'));
      
      // Other results should be successful
      expect(results['nomenclatures_datasets']!.success, isTrue);
      expect(results['taxons']!.success, isTrue);
    });

    test('should handle global connectivity failure', () async {
      // Arrange
      when(() => mockSyncRepository.checkConnectivity()).thenAnswer((_) async => false);
      
      // Act
      final results = await useCase.execute(testToken);
      
      // Assert - All results should be failure
      expect(results['configuration']!.success, isFalse);
      expect(results['nomenclatures_datasets']!.success, isFalse);
      expect(results['taxons']!.success, isFalse);
      expect(results['observers']!.success, isFalse);
      expect(results['modules']!.success, isFalse);
      expect(results['sites']!.success, isFalse);
      expect(results['siteGroups']!.success, isFalse);
      
      // All should have the same error message
      expect(results['configuration']!.errorMessage, 'Pas de connexion Internet');
      
      // Verify no sync methods were called
      verifyNever(() => mockSyncRepository.syncConfiguration(any()));
      verifyNever(() => mockSyncRepository.syncNomenclaturesAndDatasets(any()));
    });
  });
}