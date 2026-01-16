import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_complements_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_complements_use_case_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_site_complements_use_case_test.mocks.dart';

@GenerateMocks([SitesRepository])
void main() {
  late GetSiteComplementsUseCase useCase;
  late MockSitesRepository mockSitesRepository;

  setUp(() {
    mockSitesRepository = MockSitesRepository();
    useCase = GetSiteComplementsUseCaseImpl(mockSitesRepository);
  });

  group('GetSiteComplementsUseCase', () {
    final testComplements = [
      SiteComplement(
        idBaseSite: 1,
        idSitesGroup: 10,
        data: '{"field1": "value1"}',
      ),
      SiteComplement(
        idBaseSite: 2,
        idSitesGroup: 10,
        data: '{"field2": "value2"}',
      ),
      SiteComplement(
        idBaseSite: 3,
        idSitesGroup: 20,
        data: '{"field3": "value3"}',
      ),
    ];

    group('execute', () {
      test('should return all site complements', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => testComplements);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, equals(testComplements));
        expect(result.length, 3);
        verify(mockSitesRepository.getAllSiteComplements());
      });

      test('should return empty list when no complements exist', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => []);

        // Act
        final result = await useCase.execute();

        // Assert
        expect(result, isEmpty);
        verify(mockSitesRepository.getAllSiteComplements());
      });

      test('should propagate exceptions from repository', () async {
        // Arrange
        final testException = Exception('Database error');
        when(mockSitesRepository.getAllSiteComplements())
            .thenThrow(testException);

        // Act & Assert
        expect(() => useCase.execute(), throwsA(testException));
      });
    });

    group('executeForSites', () {
      test('should return complements for specified site IDs', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => testComplements);

        // Act
        final result = await useCase.executeForSites([1, 2]);

        // Assert
        expect(result.length, 2);
        expect(result[1]?.idBaseSite, 1);
        expect(result[2]?.idBaseSite, 2);
        verify(mockSitesRepository.getAllSiteComplements());
      });

      test('should return null for site IDs without complements', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => testComplements);

        // Act
        final result = await useCase.executeForSites([1, 999]);

        // Assert
        expect(result.length, 2);
        expect(result[1]?.idBaseSite, 1);
        expect(result[999], isNull);
        verify(mockSitesRepository.getAllSiteComplements());
      });

      test('should return empty map for empty site IDs list', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => testComplements);

        // Act
        final result = await useCase.executeForSites([]);

        // Assert
        expect(result, isEmpty);
        verify(mockSitesRepository.getAllSiteComplements());
      });
    });

    group('executeForSite', () {
      test('should return complement for specified site ID', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => testComplements);

        // Act
        final result = await useCase.executeForSite(1);

        // Assert
        expect(result, isNotNull);
        expect(result!.idBaseSite, 1);
        verify(mockSitesRepository.getAllSiteComplements());
      });

      test('should return null for site ID without complement', () async {
        // Arrange
        when(mockSitesRepository.getAllSiteComplements())
            .thenAnswer((_) async => testComplements);

        // Act
        final result = await useCase.executeForSite(999);

        // Assert
        expect(result, isNull);
        verify(mockSitesRepository.getAllSiteComplements());
      });
    });
  });
}
