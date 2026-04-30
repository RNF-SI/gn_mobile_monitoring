import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_detail_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'site_group_detail_viewmodel_test.mocks.dart';

// Provider de test qui n'appelle pas loadSites() automatiquement
final testSiteGroupDetailViewModelProvider = StateNotifierProvider.family<
    SiteGroupDetailViewModel,
    AsyncValue<List<BaseSite>>,
    SiteGroupDetailArgs>(
  (ref, args) => SiteGroupDetailViewModel(
    ref.watch(getSitesBySiteGroupAndModuleUseCaseProvider),
    args.siteGroup,
    args.moduleId,
  ),
);

@GenerateMocks([GetSitesBySiteGroupAndModuleUseCase])
void main() {
  late MockGetSitesBySiteGroupAndModuleUseCase mockUseCase;
  late ProviderContainer container;

  const moduleId = 42;
  final testSiteGroup = SiteGroup(
    idSitesGroup: 1,
    sitesGroupName: 'Test Group',
    sitesGroupCode: 'TG001',
    sitesGroupDescription: 'Test Description',
  );
  final args = SiteGroupDetailArgs(testSiteGroup, moduleId);

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

  setUp(() {
    mockUseCase = MockGetSitesBySiteGroupAndModuleUseCase();

    container = ProviderContainer(
      overrides: [
        getSitesBySiteGroupAndModuleUseCaseProvider
            .overrideWithValue(mockUseCase),
      ],
    );

    container.listen(
      testSiteGroupDetailViewModelProvider(args),
      (previous, next) {},
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state should be loading', () {
    when(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .thenAnswer((_) async => testSites);

    expect(
      container.read(testSiteGroupDetailViewModelProvider(args)),
      const AsyncValue<List<BaseSite>>.loading(),
    );
  });

  test('should return data when use case succeeds', () async {
    when(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .thenAnswer((_) async => testSites);

    await container
        .read(testSiteGroupDetailViewModelProvider(args).notifier)
        .loadSites();

    expect(
      container.read(testSiteGroupDetailViewModelProvider(args)),
      AsyncValue<List<BaseSite>>.data(testSites),
    );
    verify(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .called(1);
  });

  test('should forward the moduleId to the use case', () async {
    when(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .thenAnswer((_) async => testSites);

    await container
        .read(testSiteGroupDetailViewModelProvider(args).notifier)
        .loadSites();

    verify(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .called(1);
    verifyNever(mockUseCase.execute(testSiteGroup.idSitesGroup, any));
  });

  test('should return error when use case fails', () async {
    final exception = Exception('Test error');
    when(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .thenThrow(exception);

    await container
        .read(testSiteGroupDetailViewModelProvider(args).notifier)
        .loadSites();

    expect(
      container.read(testSiteGroupDetailViewModelProvider(args)),
      isA<AsyncError<List<BaseSite>>>(),
    );
    verify(mockUseCase.execute(testSiteGroup.idSitesGroup, moduleId))
        .called(1);
  });
}
