import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case_impl.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockSitesRepository extends Mock implements SitesRepository {}

void main() {
  // Mocks et variables partagées
  late MockSitesRepository mockSitesRepo;
  late GetSitesUseCase getSitesUseCase;
  late UserSitesViewModel sitesViewModel;
  late ProviderContainer container;

  // Données de test
  final testSites = [
    BaseSite(
      idBaseSite: 1,
      baseSiteName: "Site Test 1",
      baseSiteDescription: "Description site 1",
      geom: "POINT(3.8889 43.5944)",
      altitudeMin: 0,
      altitudeMax: 100,
      metaUpdateDate: DateTime.now(),
      firstUseDate: DateTime.now(),
    ),
    BaseSite(
      idBaseSite: 2,
      baseSiteName: "Site Test 2",
      baseSiteDescription: "Description site 2",
      geom: "POINT(3.9007 43.6007)",
      altitudeMin: 10,
      altitudeMax: 110,
      metaUpdateDate: DateTime.now(),
      firstUseDate: DateTime.now(),
    ),
  ];

  setUp(() {
    // Initialisation des mocks
    mockSitesRepo = MockSitesRepository();

    // Configuration des use cases avec les mocks
    getSitesUseCase = GetSitesUseCaseImpl(mockSitesRepo);

    // Configuration des use cases via les providers
    container = ProviderContainer(
      overrides: [
        sitesRepositoryProvider.overrideWithValue(mockSitesRepo),
      ],
    );

    // Création du ViewModel avec les use cases réels (en utilisant les mocks)
    sitesViewModel = UserSitesViewModel(
      const AsyncValue<List<BaseSite>>.data([]),
      getSitesUseCase,
    );
  });

  tearDown(() {
    container.dispose();
    resetMocktailState();
  });

  group('Sites Repository with ViewModel Integration', () {
    setUp(() {
      // Reset the mock before each test
      reset(mockSitesRepo);
    });

    test('getSites should correctly integrate from Repository to ViewModel',
        () async {
      // Arrange
      when(() => mockSitesRepo.getSites()).thenAnswer((_) async => testSites);

      // Act
      await sitesViewModel.loadSites();

      // Assert
      // Vérifier que le repository a bien été appelé
      verify(() => mockSitesRepo.getSites()).called(1);

      // Vérifier que l'état du ViewModel est correct
      expect(sitesViewModel.state, isA<State<List<BaseSite>>>());
      expect(sitesViewModel.state.isSuccess, isTrue);
      expect(sitesViewModel.state.data, equals(testSites));
    });

    test('ViewModel should handle repository errors correctly', () async {
      // Arrange
      final testException = Exception('Failed to load sites');
      when(() => mockSitesRepo.getSites()).thenThrow(testException);

      // Act
      await sitesViewModel.loadSites();

      // Assert
      // Vérifier que le repository a bien été appelé
      verify(() => mockSitesRepo.getSites()).called(1);

      // Vérifier que l'état du ViewModel est en erreur
      expect(sitesViewModel.state.isError, isTrue);
      expect(
          sitesViewModel.state.when(
            init: () => '',
            loading: () => '',
            success: (_) => '',
            error: (e) => e.toString(),
          ),
          contains('Failed to load sites'));
    });

    test('ViewModel should handle empty site list correctly', () async {
      // Arrange
      when(() => mockSitesRepo.getSites()).thenAnswer((_) async => []);

      // Act
      await sitesViewModel.loadSites();

      // Assert
      // Vérifier que le repository a bien été appelé
      verify(() => mockSitesRepo.getSites()).called(1);

      // Vérifier que l'état du ViewModel contient une liste vide (mais quand même success)
      expect(sitesViewModel.state.isSuccess, isTrue);
      expect(sitesViewModel.state.data, isEmpty);
    });
  });
}
