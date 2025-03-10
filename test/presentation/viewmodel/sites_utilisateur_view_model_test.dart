import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mock des dépendances
class MockGetSitesUseCase extends Mock implements GetSitesUseCase {}

void main() {
  group('SitesUtilisateurViewModel', () {
    late UserSitesViewModel viewModel;
    late MockGetSitesUseCase mockGetSitesUseCase;
    
    // Créer des sites de test selon la structure de BaseSite
    final testSites = [
      BaseSite(
        idBaseSite: 1,
        baseSiteName: "Site Test 1",
        baseSiteDescription: "Description du site 1",
        geom: "POINT(1.23 45.67)",
        altitudeMin: 100,
        altitudeMax: 100,
        metaUpdateDate: DateTime.now(),
        firstUseDate: DateTime.now(),
      ),
    ];

    setUp(() {
      mockGetSitesUseCase = MockGetSitesUseCase();
    });

    test('should initialize with init state and then transition to loading', () {
      // Arrange
      when(() => mockGetSitesUseCase.execute())
          .thenAnswer((_) async => <BaseSite>[]);
        
      // Act - Utiliser AsyncValue.data([]) comme le fait le provider
      viewModel = UserSitesViewModel(
        const AsyncValue<List<BaseSite>>.data([]),
        mockGetSitesUseCase
      );
      
      // Assert - on s'attend à ce que l'état soit "loading" car loadSites() est appelé au constructeur
      expect(viewModel.state.isLoading, isTrue);
    });
    
    test('should transition to success state with sites data when loadSites succeeds', () async {
      // Arrange
      when(() => mockGetSitesUseCase.execute())
          .thenAnswer((_) async => testSites);
      
      // Act
      viewModel = UserSitesViewModel(
        const AsyncValue<List<BaseSite>>.data([]),
        mockGetSitesUseCase
      );
      
      // Attendre que le chargement initial se termine
      await Future.delayed(Duration.zero);
      
      // Assert
      expect(viewModel.state, isA<State<List<BaseSite>>>());
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.state.data, equals(testSites));
    });
    
    test('should transition to error state when loadSites fails', () async {
      // Arrange
      when(() => mockGetSitesUseCase.execute())
          .thenThrow(Exception('Failed to load sites'));
      
      // Act
      viewModel = UserSitesViewModel(
        const AsyncValue<List<BaseSite>>.data([]),
        mockGetSitesUseCase
      );
      
      // Attendre que le chargement initial se termine
      await Future.delayed(Duration.zero);
      
      // Assert
      expect(viewModel.state.isError, isTrue);
    });
    
    test('should reload sites when loadSites is called manually', () async {
      // Arrange - Premier appel retourne des sites
      when(() => mockGetSitesUseCase.execute())
          .thenAnswer((_) async => testSites);
      
      // Act - Initialiser le ViewModel
      viewModel = UserSitesViewModel(
        const AsyncValue<List<BaseSite>>.data([]),
        mockGetSitesUseCase
      );
      
      // Attendre que le chargement initial se termine
      await Future.delayed(Duration.zero);
      
      // Vérifier le premier état
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.state.data, equals(testSites));
      
      // Reconfigurer le mock pour le second appel
      final newSites = [
        BaseSite(
          idBaseSite: 2,
          baseSiteName: "Site Test 2",
          baseSiteDescription: "Description du site 2",
          geom: "POINT(2.34 46.78)",
          altitudeMin: 200,
          altitudeMax: 200,
          metaUpdateDate: DateTime.now(),
          firstUseDate: DateTime.now(),
        ),
      ];
      when(() => mockGetSitesUseCase.execute())
          .thenAnswer((_) async => newSites);
      
      // Act - Second appel à loadSites
      await viewModel.loadSites();
      
      // Assert
      expect(viewModel.state.isSuccess, isTrue, reason: 'État devrait être success après le rechargement');
      expect(viewModel.state.data, equals(newSites), reason: 'Les données devraient correspondre au second appel');
      verify(() => mockGetSitesUseCase.execute()).called(2); // 1 appel au init, 1 appel explicite à loadSites
    });
  });
}
