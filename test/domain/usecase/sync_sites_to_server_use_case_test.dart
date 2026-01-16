import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_sites_to_server_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_sites_to_server_use_case_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sync_sites_to_server_use_case_test.mocks.dart';

@GenerateMocks([UpstreamSyncRepository])
void main() {
  late SyncSitesToServerUseCase useCase;
  late MockUpstreamSyncRepository mockUpstreamSyncRepository;

  setUp(() {
    mockUpstreamSyncRepository = MockUpstreamSyncRepository();
    useCase = SyncSitesToServerUseCaseImpl(mockUpstreamSyncRepository);
  });

  group('SyncSitesToServerUseCase', () {
    const testToken = 'test-token';
    const testModuleCode = 'TEST_MODULE';

    test('should return success result when sync succeeds', () async {
      // Arrange
      final successResult = SyncResult.success(
        itemsProcessed: 5,
        itemsAdded: 3,
        itemsUpdated: 2,
        itemsSkipped: 0,
      );
      when(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode))
          .thenAnswer((_) async => successResult);

      // Act
      final result = await useCase.execute(testToken, testModuleCode);

      // Assert
      expect(result.success, true);
      expect(result.itemsProcessed, 5);
      expect(result.itemsAdded, 3);
      expect(result.itemsUpdated, 2);
      verify(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode));
      verifyNoMoreInteractions(mockUpstreamSyncRepository);
    });

    test('should return failure result when sync fails', () async {
      // Arrange
      final failureResult = SyncResult.failure(
        errorMessage: 'Network error',
        itemsProcessed: 2,
        itemsSkipped: 2,
      );
      when(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode))
          .thenAnswer((_) async => failureResult);

      // Act
      final result = await useCase.execute(testToken, testModuleCode);

      // Assert
      expect(result.success, false);
      expect(result.errorMessage, 'Network error');
      expect(result.itemsProcessed, 2);
      expect(result.itemsSkipped, 2);
      verify(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode));
    });

    test('should return empty success when no local sites', () async {
      // Arrange
      final emptyResult = SyncResult.success(
        itemsProcessed: 0,
        itemsAdded: 0,
        itemsUpdated: 0,
        itemsSkipped: 0,
      );
      when(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode))
          .thenAnswer((_) async => emptyResult);

      // Act
      final result = await useCase.execute(testToken, testModuleCode);

      // Assert
      expect(result.success, true);
      expect(result.itemsProcessed, 0);
      verify(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode));
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final testException = Exception('Repository error');
      when(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode))
          .thenThrow(testException);

      // Act & Assert
      expect(
        () => useCase.execute(testToken, testModuleCode),
        throwsA(testException),
      );
      verify(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode));
    });

    test('should handle partial success with errors', () async {
      // Arrange
      final partialResult = SyncResult.failure(
        errorMessage: 'Site 123: Server error',
        itemsProcessed: 3,
        itemsAdded: 2,
        itemsUpdated: 0,
        itemsSkipped: 1,
      );
      when(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode))
          .thenAnswer((_) async => partialResult);

      // Act
      final result = await useCase.execute(testToken, testModuleCode);

      // Assert
      expect(result.success, false);
      expect(result.itemsAdded, 2);
      expect(result.itemsSkipped, 1);
      expect(result.errorMessage, contains('Site 123'));
      verify(mockUpstreamSyncRepository.syncSitesToServer(testToken, testModuleCode));
    });
  });
}
