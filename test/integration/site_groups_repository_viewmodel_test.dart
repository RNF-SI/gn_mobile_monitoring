import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase_impl.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockSitesRepository extends Mock implements SitesRepository {}

void main() {
  // Mocks et variables partagées
  late MockSitesRepository mockSitesRepo;
  late GetSiteGroupsUseCase getSiteGroupsUseCase;
  late SiteGroupsViewModel siteGroupsViewModel;
  late ProviderContainer container;

  // Données de test
  final testSiteGroups = [
    SiteGroup(
      idSitesGroup: 1,
      sitesGroupName: "Groupe Test 1",
      sitesGroupDescription: "Description groupe 1",
    ),
    SiteGroup(
      idSitesGroup: 2,
      sitesGroupName: "Groupe Test 2",
      sitesGroupDescription: "Description groupe 2",
    ),
  ];

  setUp(() {
    // Initialisation des mocks
    mockSitesRepo = MockSitesRepository();

    // Configuration des use cases avec les mocks
    getSiteGroupsUseCase = GetSiteGroupsUseCaseImpl(mockSitesRepo);

    // Définit des valeurs par défaut pour les mocks
    when(() => mockSitesRepo.getSiteGroups())
        .thenAnswer((_) async => testSiteGroups);

    // Configuration des use cases via les providers
    container = ProviderContainer(
      overrides: [
        getSiteGroupsUseCaseProvider.overrideWithValue(getSiteGroupsUseCase),
      ],
    );

    // Création du ViewModel avec les use cases réels (en utilisant les mocks)
    siteGroupsViewModel = SiteGroupsViewModel(
      const AsyncValue<List<SiteGroup>>.data([]),
      getSiteGroupsUseCase,
    );
  });

  group('SiteGroups Repository with ViewModel Integration', () {
    test('Initial load should correctly integrate from Repository to ViewModel',
        () async {
      // Arrange
      when(() => mockSitesRepo.getSiteGroups())
          .thenAnswer((_) async => testSiteGroups);

      // Act - initial load happens in constructor
      await Future.delayed(Duration.zero); // Wait for async operations

      // Assert
      verify(() => mockSitesRepo.getSiteGroups()).called(1);
      expect(siteGroupsViewModel.state,
          isA<custom_async_state.State<List<SiteGroup>>>());
      expect(siteGroupsViewModel.state.isSuccess, isTrue);
      expect(siteGroupsViewModel.state.data, equals(testSiteGroups));
    });

    test('refreshSiteGroups should reload data from repository', () async {
      // Arrange
      when(() => mockSitesRepo.getSiteGroups())
          .thenAnswer((_) async => testSiteGroups);

      // Act
      await siteGroupsViewModel.refreshSiteGroups();

      // Assert
      verify(() => mockSitesRepo.getSiteGroups())
          .called(2); // Once in init, once in refresh
      expect(siteGroupsViewModel.state.isSuccess, isTrue);
      expect(siteGroupsViewModel.state.data, equals(testSiteGroups));
    });

    test('ViewModel should handle repository errors correctly', () async {
      // Arrange
      final testException = Exception('Failed to fetch site groups');
      when(() => mockSitesRepo.getSiteGroups()).thenThrow(testException);

      // Act
      await siteGroupsViewModel.refreshSiteGroups();

      // Assert
      verify(() => mockSitesRepo.getSiteGroups())
          .called(2); // Once in init, once in refresh
      expect(siteGroupsViewModel.state,
          isA<custom_async_state.State<List<SiteGroup>>>());
      expect(siteGroupsViewModel.state.isError, isTrue);

      String? errorMessage;
      siteGroupsViewModel.state.maybeWhen(
        error: (exception) => errorMessage = exception.toString(),
        orElse: () => errorMessage = null,
      );
      expect(errorMessage, contains('Failed to load site groups'));
    });

    test('ViewModel should handle empty site groups list correctly', () async {
      // Arrange
      when(() => mockSitesRepo.getSiteGroups()).thenAnswer((_) async => []);

      // Act
      await siteGroupsViewModel.refreshSiteGroups();

      // Assert
      verify(() => mockSitesRepo.getSiteGroups())
          .called(2); // Once in init, once in refresh
      expect(siteGroupsViewModel.state.isSuccess, isTrue);
      expect(siteGroupsViewModel.state.data, isEmpty);
    });
  });
}
