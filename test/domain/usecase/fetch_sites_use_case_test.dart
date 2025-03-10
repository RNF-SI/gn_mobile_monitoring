import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late FetchSitesUseCase useCase;
  late MockSitesRepository mockSitesRepository;

  setUp(() {
    mockSitesRepository = MockSitesRepository();
    useCase = FetchSitesUseCaseImpl(mockSitesRepository);
  });

  group('FetchSitesUseCase', () {
    test('should call repository fetchSitesAndSiteModules with provided token', () async {
      // Arrange
      final token = 'test_token';
      when(() => mockSitesRepository.fetchSitesAndSiteModules(any()))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(token);

      // Assert
      verify(() => mockSitesRepository.fetchSitesAndSiteModules(token)).called(1);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      final token = 'test_token';
      final exception = Exception('Failed to fetch sites');
      when(() => mockSitesRepository.fetchSitesAndSiteModules(any()))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(token),
        throwsA(equals(exception)),
      );
    });
  });
}
