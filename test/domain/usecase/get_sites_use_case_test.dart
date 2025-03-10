import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case_impl.dart';

// Mock des dépendances
class MockSitesRepository extends Mock implements SitesRepository {}

void main() {
  late GetSitesUseCase useCase;
  late MockSitesRepository mockRepository;

  setUp(() {
    mockRepository = MockSitesRepository();
    useCase = GetSitesUseCaseImpl(mockRepository);
  });

  group('GetSitesUseCase', () {
    test('should return sites from repository', () async {
      // Arrange
      final testSites = [
        BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Test Site 1',
          baseSiteCode: 'TS1',
          firstUseDate: DateTime.now(),
        ),
        BaseSite(
          idBaseSite: 2,
          baseSiteName: 'Test Site 2', 
          baseSiteCode: 'TS2',
          firstUseDate: DateTime.now(),
        ),
      ];
      
      when(() => mockRepository.getSites())
          .thenAnswer((_) async => testSites);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(testSites));
      verify(() => mockRepository.getSites()).called(1);
    });

    test('should return empty list when repository returns empty', () async {
      // Arrange
      when(() => mockRepository.getSites())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getSites()).called(1);
    });
    
    test('should propagate exceptions from repository', () async {
      // Arrange
      when(() => mockRepository.getSites())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.getSites()).called(1);
    });
  });
}
