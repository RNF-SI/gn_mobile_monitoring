import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart'; // Import to use suppressOutput function if needed

class MockIncrementalSyncModulesUseCase extends Mock
    implements IncrementalSyncModulesUseCase {}

class MockIncrementalSyncSitesUseCase extends Mock
    implements IncrementalSyncSitesUseCase {}

class MockIncrementalSyncSiteGroupsUseCase extends Mock
    implements IncrementalSyncSiteGroupsUseCase {}

void main() {
  late MockIncrementalSyncModulesUseCase mockSyncModulesUseCase;
  late MockIncrementalSyncSitesUseCase mockSyncSitesUseCase;
  late MockIncrementalSyncSiteGroupsUseCase mockSyncSiteGroupsUseCase;
  late IncrementalSyncAllUseCase useCase;

  setUp(() {
    mockSyncModulesUseCase = MockIncrementalSyncModulesUseCase();
    mockSyncSitesUseCase = MockIncrementalSyncSitesUseCase();
    mockSyncSiteGroupsUseCase = MockIncrementalSyncSiteGroupsUseCase();
    useCase = IncrementalSyncAllUseCaseImpl(
      mockSyncModulesUseCase,
      mockSyncSitesUseCase,
      mockSyncSiteGroupsUseCase,
    );
  });

  group('IncrementalSyncAllUseCase', () {
    const testToken = 'test_token';

    test('should execute all sync use cases in order', () async {
      // Arrange
      when(() => mockSyncModulesUseCase.execute(any())).thenAnswer((_) async {});
      when(() => mockSyncSitesUseCase.execute(any())).thenAnswer((_) async {});
      when(() => mockSyncSiteGroupsUseCase.execute(any())).thenAnswer((_) async {});

      // Act
      await useCase.execute(testToken);

      // Assert - Verify the correct order of calls
      verifyInOrder([
        () => mockSyncModulesUseCase.execute(testToken),
        () => mockSyncSitesUseCase.execute(testToken),
        () => mockSyncSiteGroupsUseCase.execute(testToken),
      ]);
    });

    test('should throw an exception when modules sync throws an exception', () async {
      // Arrange
      final testException = Exception('Module sync test error');
      when(() => mockSyncModulesUseCase.execute(any())).thenThrow(testException);
      
      // Act & Assert
      await expectLater(
        () => suppressOutput(() => useCase.execute(testToken)),
        throwsA(same(testException)),
      );
      
      verify(() => mockSyncModulesUseCase.execute(testToken)).called(1);
      verifyNever(() => mockSyncSitesUseCase.execute(testToken));
      verifyNever(() => mockSyncSiteGroupsUseCase.execute(testToken));
    });

    test('should throw an exception when sites sync throws an exception', () async {
      // Arrange
      final testException = Exception('Sites sync test error');
      when(() => mockSyncModulesUseCase.execute(any())).thenAnswer((_) async {});
      when(() => mockSyncSitesUseCase.execute(any())).thenThrow(testException);
      
      // Act & Assert
      await expectLater(
        () => suppressOutput(() => useCase.execute(testToken)),
        throwsA(same(testException)),
      );
      
      verify(() => mockSyncModulesUseCase.execute(testToken)).called(1);
      verify(() => mockSyncSitesUseCase.execute(testToken)).called(1);
      // We use verifyNever with explicit parameters
      verifyNever(() => mockSyncSiteGroupsUseCase.execute(testToken));
    });

    test('should throw an exception when site groups sync throws an exception', () async {
      // Arrange
      final testException = Exception('Site groups sync test error');
      when(() => mockSyncModulesUseCase.execute(any())).thenAnswer((_) async {});
      when(() => mockSyncSitesUseCase.execute(any())).thenAnswer((_) async {});
      when(() => mockSyncSiteGroupsUseCase.execute(any())).thenThrow(testException);
      
      // Act & Assert
      await expectLater(
        () => suppressOutput(() => useCase.execute(testToken)),
        throwsA(same(testException)),
      );
      
      verify(() => mockSyncModulesUseCase.execute(testToken)).called(1);
      verify(() => mockSyncSitesUseCase.execute(testToken)).called(1);
      verify(() => mockSyncSiteGroupsUseCase.execute(testToken)).called(1);
    });
  });
}