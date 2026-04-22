import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_sites_by_site_group_and_module_use_case_test.mocks.dart';

@GenerateMocks([SitesRepository])
void main() {
  late GetSitesBySiteGroupAndModuleUseCase useCase;
  late MockSitesRepository mockSitesRepository;

  const siteGroupId = 1;
  const moduleId = 42;

  setUp(() {
    mockSitesRepository = MockSitesRepository();
    useCase = GetSitesBySiteGroupAndModuleUseCaseImpl(mockSitesRepository);
  });

  group('GetSitesBySiteGroupAndModuleUseCase', () {
    final testSites = [
      BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Site 1',
        baseSiteCode: 'S001',
        baseSiteDescription: 'Description 1',
        altitudeMin: 100,
        altitudeMax: 200,
      ),
    ];

    test('delegates to repository with both siteGroupId and moduleId',
        () async {
      when(mockSitesRepository.getSitesBySiteGroupAndModule(
              siteGroupId, moduleId))
          .thenAnswer((_) async => testSites);

      final result = await useCase.execute(siteGroupId, moduleId);

      expect(result, equals(testSites));
      verify(mockSitesRepository.getSitesBySiteGroupAndModule(
          siteGroupId, moduleId));
      verifyNoMoreInteractions(mockSitesRepository);
    });

    test('returns an empty list when repository returns empty', () async {
      when(mockSitesRepository.getSitesBySiteGroupAndModule(
              siteGroupId, moduleId))
          .thenAnswer((_) async => []);

      final result = await useCase.execute(siteGroupId, moduleId);

      expect(result, isEmpty);
      verify(mockSitesRepository.getSitesBySiteGroupAndModule(
          siteGroupId, moduleId));
      verifyNoMoreInteractions(mockSitesRepository);
    });

    test('propagates exceptions from the repository', () async {
      final testException = Exception('Test exception');
      when(mockSitesRepository.getSitesBySiteGroupAndModule(
              siteGroupId, moduleId))
          .thenThrow(testException);

      expect(() => useCase.execute(siteGroupId, moduleId),
          throwsA(testException));
      verify(mockSitesRepository.getSitesBySiteGroupAndModule(
          siteGroupId, moduleId));
      verifyNoMoreInteractions(mockSitesRepository);
    });
  });
}
