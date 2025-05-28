import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockSyncRepository extends Mock implements SyncRepository {}
class MockGetModulesUseCase extends Mock implements GetModulesUseCase {}

void main() {
  late SyncCompleteUseCase syncCompleteUseCase;
  late MockSyncRepository mockSyncRepository;
  late MockGetModulesUseCase mockGetModulesUseCase;

  setUp(() {
    mockSyncRepository = MockSyncRepository();
    mockGetModulesUseCase = MockGetModulesUseCase();
    syncCompleteUseCase = SyncCompleteUseCaseImpl(
      mockSyncRepository,
      mockGetModulesUseCase,
    );
  });

  group('SyncCompleteUseCase', () {
    test('should return failure when no modules available', () async {
      // Arrange
      when(() => mockGetModulesUseCase.execute())
          .thenAnswer((_) async => <Module>[]);

      // Act
      final result = await syncCompleteUseCase.execute('test-token');

      // Assert
      expect(result.success, isFalse);
      expect(result.errorMessage, contains('Aucun module disponible'));
    });

    test('should sync all modules successfully', () async {
      // Arrange
      final testModules = <Module>[
        Module(
          id: 1,
          moduleLabel: 'Test Module 1',
          moduleCode: 'TEST1',
          activeFrontend: true,
        ),
        Module(
          id: 2,
          moduleLabel: 'Test Module 2',
          moduleCode: 'TEST2',
          activeFrontend: true,
        ),
      ];

      when(() => mockGetModulesUseCase.execute())
          .thenAnswer((_) async => testModules);
      
      when(() => mockSyncRepository.syncVisitsToServer(any(), any()))
          .thenAnswer((_) async => SyncResult.success(
            itemsProcessed: 2,
            itemsAdded: 1,
            itemsUpdated: 1,
            itemsSkipped: 0,
            itemsDeleted: 0,
          ));

      // Act
      final result = await syncCompleteUseCase.execute('test-token');

      // Assert
      expect(result.success, isTrue);
      expect(result.itemsProcessed, equals(4)); // 2 modules * 2 items each
      expect(result.itemsAdded, equals(2)); // 2 modules * 1 item each
      verify(() => mockSyncRepository.syncVisitsToServer('test-token', 'TEST1')).called(1);
      verify(() => mockSyncRepository.syncVisitsToServer('test-token', 'TEST2')).called(1);
    });

    test('should handle partial failures correctly', () async {
      // Arrange
      final testModules = <Module>[
        Module(
          id: 1,
          moduleLabel: 'Test Module 1',
          moduleCode: 'TEST1',
          activeFrontend: true,
        ),
        Module(
          id: 2,
          moduleLabel: 'Test Module 2',
          moduleCode: 'TEST2',
          activeFrontend: true,
        ),
      ];

      when(() => mockGetModulesUseCase.execute())
          .thenAnswer((_) async => testModules);
      
      when(() => mockSyncRepository.syncVisitsToServer('test-token', 'TEST1'))
          .thenAnswer((_) async => SyncResult.success(
            itemsProcessed: 1,
            itemsAdded: 1,
            itemsUpdated: 0,
            itemsSkipped: 0,
            itemsDeleted: 0,
          ));
      
      when(() => mockSyncRepository.syncVisitsToServer('test-token', 'TEST2'))
          .thenAnswer((_) async => SyncResult.failure(
            errorMessage: 'Network error',
          ));

      // Act
      final result = await syncCompleteUseCase.execute('test-token');

      // Assert
      expect(result.success, isFalse);
      expect(result.errorMessage, contains('partiellement réussie'));
      expect(result.errorMessage, contains('Network error'));
      expect(result.itemsProcessed, equals(1));
    });

    test('should skip modules without code', () async {
      // Arrange
      final testModules = <Module>[
        Module(
          id: 1,
          moduleLabel: 'Test Module 1',
          moduleCode: 'TEST1',
          activeFrontend: true,
        ),
        Module(
          id: 2,
          moduleLabel: 'Test Module Without Code',
          moduleCode: null,
          activeFrontend: true,
        ),
      ];

      when(() => mockGetModulesUseCase.execute())
          .thenAnswer((_) async => testModules);
      
      when(() => mockSyncRepository.syncVisitsToServer(any(), any()))
          .thenAnswer((_) async => SyncResult.success(
            itemsProcessed: 1,
            itemsAdded: 1,
            itemsUpdated: 0,
            itemsSkipped: 0,
            itemsDeleted: 0,
          ));

      // Act
      final result = await syncCompleteUseCase.execute('test-token');

      // Assert
      expect(result.success, isTrue);
      verify(() => mockSyncRepository.syncVisitsToServer('test-token', 'TEST1')).called(1);
      // Verify that the second module (without code) was not synced
      verifyNever(() => mockSyncRepository.syncVisitsToServer('test-token', 'TEST2'));
    });
  });
}