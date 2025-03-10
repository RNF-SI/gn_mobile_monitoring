import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mock des dépendances
class MockGetSiteGroupsUseCase extends Mock implements GetSiteGroupsUseCase {}

void main() {
  group('SiteGroupsViewModel', () {
    late SiteGroupsViewModel viewModel;
    late MockGetSiteGroupsUseCase mockGetSiteGroupsUseCase;
    
    // Créer des groupes de sites de test selon la structure de SiteGroup
    final testSiteGroups = [
      SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: "Groupe de sites Test 1",
        sitesGroupDescription: "Description du groupe de sites 1",
        geom: "POLYGON((1.23 45.67, 1.24 45.67, 1.24 45.68, 1.23 45.68, 1.23 45.67))",
        altitudeMin: 100,
        altitudeMax: 200,
        metaCreateDate: DateTime.now(),
        metaUpdateDate: DateTime.now(),
      ),
    ];

    setUp(() {
      mockGetSiteGroupsUseCase = MockGetSiteGroupsUseCase();
    });

    test('should initialize with init state and then transition to loading', () {
      // Arrange
      when(() => mockGetSiteGroupsUseCase.execute())
          .thenAnswer((_) async => <SiteGroup>[]);
        
      // Act - Utiliser AsyncValue.data([]) comme le fait le provider
      viewModel = SiteGroupsViewModel(
        const AsyncValue<List<SiteGroup>>.data([]),
        mockGetSiteGroupsUseCase
      );
      
      // Assert - on s'attend à ce que l'état soit "loading" car _loadSiteGroups() est appelé au constructeur
      expect(viewModel.state.isLoading, isTrue);
    });
    
    test('should transition to success state with site groups data when _loadSiteGroups succeeds', () async {
      // Arrange
      when(() => mockGetSiteGroupsUseCase.execute())
          .thenAnswer((_) async => testSiteGroups);
      
      // Act
      viewModel = SiteGroupsViewModel(
        const AsyncValue<List<SiteGroup>>.data([]),
        mockGetSiteGroupsUseCase
      );
      
      // Attendre que le chargement initial se termine
      await Future.delayed(Duration.zero);
      
      // Assert
      expect(viewModel.state, isA<State<List<SiteGroup>>>());
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.state.data, equals(testSiteGroups));
    });
    
    test('should transition to error state when _loadSiteGroups fails', () async {
      // Arrange
      when(() => mockGetSiteGroupsUseCase.execute())
          .thenThrow(Exception('Failed to load site groups'));
      
      // Act
      viewModel = SiteGroupsViewModel(
        const AsyncValue<List<SiteGroup>>.data([]),
        mockGetSiteGroupsUseCase
      );
      
      // Attendre que le chargement initial se termine
      await Future.delayed(Duration.zero);
      
      // Assert
      expect(viewModel.state.isError, isTrue);
    });
    
    test('should reload site groups when refreshSiteGroups is called', () async {
      // Arrange - Premier appel retourne des site groups
      when(() => mockGetSiteGroupsUseCase.execute())
          .thenAnswer((_) async => testSiteGroups);
      
      // Act - Initialiser le ViewModel
      viewModel = SiteGroupsViewModel(
        const AsyncValue<List<SiteGroup>>.data([]),
        mockGetSiteGroupsUseCase
      );
      
      // Attendre que le chargement initial se termine
      await Future.delayed(Duration.zero);
      
      // Vérifier le premier état
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.state.data, equals(testSiteGroups));
      
      // Reconfigurer le mock pour le second appel
      final newSiteGroups = [
        SiteGroup(
          idSitesGroup: 2,
          sitesGroupName: "Groupe de sites Test 2",
          sitesGroupDescription: "Description du groupe de sites 2",
          geom: "POLYGON((2.34 46.78, 2.35 46.78, 2.35 46.79, 2.34 46.79, 2.34 46.78))",
          altitudeMin: 300,
          altitudeMax: 400,
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
      ];
      when(() => mockGetSiteGroupsUseCase.execute())
          .thenAnswer((_) async => newSiteGroups);
      
      // Act - Appel à refreshSiteGroups
      await viewModel.refreshSiteGroups();
      
      // Assert
      expect(viewModel.state.isSuccess, isTrue, reason: 'État devrait être success après le rechargement');
      expect(viewModel.state.data, equals(newSiteGroups), reason: 'Les données devraient correspondre au second appel');
      verify(() => mockGetSiteGroupsUseCase.execute()).called(2); // 1 appel au init, 1 appel explicite à refreshSiteGroups
    });
  });
}
