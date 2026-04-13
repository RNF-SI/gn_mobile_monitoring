import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_site_by_id_use_case_test.mocks.dart';

@GenerateMocks([SitesRepository])
void main() {
  late GetSiteByIdUseCase useCase;
  late MockSitesRepository mockSitesRepository;

  setUp(() {
    mockSitesRepository = MockSitesRepository();
    useCase = GetSiteByIdUseCaseImpl(mockSitesRepository);
  });

  group('GetSiteByIdUseCase', () {
    final testSite = BaseSite(
      idBaseSite: 1,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TS001',
      baseSiteDescription: 'Test Description',
      altitudeMin: 100,
      altitudeMax: 200,
      isLocal: true,
    );

    test('should return site when found', () async {
      // Arrange
      when(mockSitesRepository.getSiteById(1))
          .thenAnswer((_) async => testSite);

      // Act
      final result = await useCase.execute(1);

      // Assert
      expect(result, isNotNull);
      expect(result!.idBaseSite, 1);
      expect(result.baseSiteName, 'Test Site');
      expect(result.isLocal, true);
      verify(mockSitesRepository.getSiteById(1));
      verifyNoMoreInteractions(mockSitesRepository);
    });

    test('should return null when site not found', () async {
      // Arrange
      when(mockSitesRepository.getSiteById(999))
          .thenAnswer((_) async => null);

      // Act
      final result = await useCase.execute(999);

      // Assert
      expect(result, isNull);
      verify(mockSitesRepository.getSiteById(999));
      verifyNoMoreInteractions(mockSitesRepository);
    });

    test('should propagate exceptions from repository', () async {
      // Arrange
      final testException = Exception('Database error');
      when(mockSitesRepository.getSiteById(1))
          .thenThrow(testException);

      // Act & Assert
      expect(() => useCase.execute(1), throwsA(testException));
      verify(mockSitesRepository.getSiteById(1));
    });

    test('should handle site with all fields', () async {
      // Arrange
      final fullSite = BaseSite(
        idBaseSite: 2,
        baseSiteName: 'Full Site',
        baseSiteCode: 'FS001',
        baseSiteDescription: 'Full Description',
        altitudeMin: 500,
        altitudeMax: 1000,
        firstUseDate: DateTime(2024, 1, 1),
        metaCreateDate: DateTime(2024, 1, 1),
        metaUpdateDate: DateTime(2024, 6, 1),
        isLocal: false,
        geom: '{"type":"Point","coordinates":[2.35,48.85]}',
      );

      when(mockSitesRepository.getSiteById(2))
          .thenAnswer((_) async => fullSite);

      // Act
      final result = await useCase.execute(2);

      // Assert
      expect(result, isNotNull);
      expect(result!.idBaseSite, 2);
      expect(result.altitudeMin, 500);
      expect(result.altitudeMax, 1000);
      expect(result.isLocal, false);
      expect(result.geom, isNotNull);
      verify(mockSitesRepository.getSiteById(2));
    });
  });
}
