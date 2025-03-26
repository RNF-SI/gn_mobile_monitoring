import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_sites_by_site_group_use_case_test.mocks.dart';

@GenerateMocks([SitesRepository])
void main() {
  late GetSitesBySiteGroupUseCase useCase;
  late MockSitesRepository mockSitesRepository;

  setUp(() {
    mockSitesRepository = MockSitesRepository();
    useCase = GetSitesBySiteGroupUseCaseImpl(mockSitesRepository);
  });

  group('GetSitesBySiteGroupUseCase', () {
    final testSiteGroup = SiteGroup(
      idSitesGroup: 1,
      sitesGroupName: 'Test Group',
      sitesGroupCode: 'TG001',
      sitesGroupDescription: 'Test Description',
    );

    final testSites = [
      BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Site 1',
        baseSiteCode: 'S001',
        baseSiteDescription: 'Description 1',
        altitudeMin: 100,
        altitudeMax: 200,
      ),
      BaseSite(
        idBaseSite: 2,
        baseSiteName: 'Site 2',
        baseSiteCode: 'S002',
        baseSiteDescription: 'Description 2',
        altitudeMin: 150,
        altitudeMax: 250,
      ),
    ];

    test('should return a list of sites associated with the site group', () async {
      // Arrange
      when(mockSitesRepository.getSitesBySiteGroup(testSiteGroup.idSitesGroup))
          .thenAnswer((_) async => testSites);

      // Act
      final result = await useCase.execute(testSiteGroup.idSitesGroup);

      // Assert
      expect(result, equals(testSites));
      verify(mockSitesRepository.getSitesBySiteGroup(testSiteGroup.idSitesGroup));
      verifyNoMoreInteractions(mockSitesRepository);
    });

    test('should return an empty list when no sites are associated with the site group', () async {
      // Arrange
      when(mockSitesRepository.getSitesBySiteGroup(testSiteGroup.idSitesGroup))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute(testSiteGroup.idSitesGroup);

      // Assert
      expect(result, isEmpty);
      verify(mockSitesRepository.getSitesBySiteGroup(testSiteGroup.idSitesGroup));
      verifyNoMoreInteractions(mockSitesRepository);
    });

    test('should propagate exceptions from the repository', () async {
      // Arrange
      final testException = Exception('Test exception');
      when(mockSitesRepository.getSitesBySiteGroup(testSiteGroup.idSitesGroup))
          .thenThrow(testException);

      // Act & Assert
      expect(() => useCase.execute(testSiteGroup.idSitesGroup), throwsA(testException));
      verify(mockSitesRepository.getSitesBySiteGroup(testSiteGroup.idSitesGroup));
      verifyNoMoreInteractions(mockSitesRepository);
    });
  });
}