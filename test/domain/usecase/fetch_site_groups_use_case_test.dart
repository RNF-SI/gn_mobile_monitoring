import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late FetchSiteGroupsUseCase useCase;
  late MockSitesRepository mockSitesRepository;

  setUp(() {
    mockSitesRepository = MockSitesRepository();
    useCase = FetchSiteGroupsUseCaseImpl(mockSitesRepository);
  });

  group('FetchSiteGroupsUseCase', () {
    test('should call repository fetchSiteGroupsAndSitesGroupModules with provided token', () async {
      // Arrange
      final token = 'test_token';
      when(() => mockSitesRepository.fetchSiteGroupsAndSitesGroupModules(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(token);

      // Assert
      verify(() => mockSitesRepository.fetchSiteGroupsAndSitesGroupModules(token)).called(1);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      final token = 'test_token';
      final exception = Exception('Failed to fetch site groups');
      when(() => mockSitesRepository.fetchSiteGroupsAndSitesGroupModules(any()))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(token),
        throwsA(equals(exception)),
      );
    });
  });
}
