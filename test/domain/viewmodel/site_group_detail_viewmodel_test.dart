import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_detail_viewmodel.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'site_group_detail_viewmodel_test.mocks.dart';

// Créer un provider modifié pour les tests qui n'appelle pas loadSites() automatiquement
final testSiteGroupDetailViewModelProvider = StateNotifierProvider.family<
    SiteGroupDetailViewModel, AsyncValue<List<BaseSite>>, SiteGroup>(
  (ref, siteGroup) => SiteGroupDetailViewModel(
    ref.watch(getSitesBySiteGroupUseCaseProvider),
    siteGroup,
  ),
);

@GenerateMocks([GetSitesBySiteGroupUseCase])
void main() {
  late MockGetSitesBySiteGroupUseCase mockGetSitesBySiteGroupUseCase;
  late ProviderContainer container;

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

  setUp(() {
    mockGetSitesBySiteGroupUseCase = MockGetSitesBySiteGroupUseCase();

    container = ProviderContainer(
      overrides: [
        getSitesBySiteGroupUseCaseProvider
            .overrideWithValue(mockGetSitesBySiteGroupUseCase),
      ],
    );

    // Add a listener to the provider we're testing to trigger updates
    container.listen(
      testSiteGroupDetailViewModelProvider(testSiteGroup),
      (previous, next) {},
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state should be loading', () {
    // Arrange
    when(mockGetSitesBySiteGroupUseCase.execute(testSiteGroup.idSitesGroup))
        .thenAnswer((_) async => testSites);

    // Act & Assert
    expect(
      container.read(testSiteGroupDetailViewModelProvider(testSiteGroup)),
      const AsyncValue<List<BaseSite>>.loading(),
    );
  });

  test('should return data when use case succeeds', () async {
    // Arrange
    when(mockGetSitesBySiteGroupUseCase.execute(testSiteGroup.idSitesGroup))
        .thenAnswer((_) async => testSites);

    // Act - simulate the callback being triggered after the future completes
    await container
        .read(testSiteGroupDetailViewModelProvider(testSiteGroup).notifier)
        .loadSites();

    // Assert
    expect(
      container.read(testSiteGroupDetailViewModelProvider(testSiteGroup)),
      AsyncValue<List<BaseSite>>.data(testSites),
    );
    verify(mockGetSitesBySiteGroupUseCase.execute(testSiteGroup.idSitesGroup))
        .called(1);
  });

  test('should return error when use case fails', () async {
    // Arrange
    final exception = Exception('Test error');
    when(mockGetSitesBySiteGroupUseCase.execute(testSiteGroup.idSitesGroup))
        .thenThrow(exception);

    // Act
    await container
        .read(testSiteGroupDetailViewModelProvider(testSiteGroup).notifier)
        .loadSites();

    // Assert
    expect(
      container.read(testSiteGroupDetailViewModelProvider(testSiteGroup)),
      isA<AsyncError<List<BaseSite>>>(),
    );
    verify(mockGetSitesBySiteGroupUseCase.execute(testSiteGroup.idSitesGroup))
        .called(1);
  });
}
