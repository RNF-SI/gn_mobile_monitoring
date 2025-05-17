import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mock des ViewModels
class MockObservationsViewModel extends StateNotifier<AsyncValue<List<Observation>>>
    implements ObservationsViewModel {
  MockObservationsViewModel() : super(const AsyncValue.data([]));
  
  final List<Observation> _observations = [];
  
  @override
  Future<Observation> getObservationById(int observationId) async {
    return _observations.firstWhere((obs) => obs.idObservation == observationId);
  }
  
  @override
  Future<List<Observation>> getObservationsByVisitId() async {
    return _observations;
  }
  
  @override
  Future<void> loadObservations() async {
    // Simulate data loading
  }
  
  @override
  Future<bool> updateObservation(Map<String, dynamic> formData, int observationId) async {
    // Simulate observation update
    final index = _observations.indexWhere((obs) => obs.idObservation == observationId);
    if (index != -1) {
      _observations[index] = Observation(
        idObservation: observationId,
        idBaseVisit: _observations[index].idBaseVisit,
        cdNom: formData['cd_nom'] ?? _observations[index].cdNom,
        comments: formData['comments'] ?? _observations[index].comments,
        data: formData,
      );
      return true;
    }
    return false;
  }
  
  @override
  Future<int> createObservation(Map<String, dynamic> formData) async {
    return 1;
  }
  
  @override
  Future<bool> deleteObservation(int observationId) async {
    return true;
  }
  
  // Ajouter une observation pour les tests
  void addTestObservation(Observation observation) {
    _observations.add(observation);
  }
}

void main() {
  testWidgets('ObservationDetailPage refreshes data after edit', (WidgetTester tester) async {
    // Données de test
    final testObservation = Observation(
      idObservation: 1,
      idBaseVisit: 1,
      cdNom: 123,
      comments: 'Initial comment',
      data: {'test_field': 'initial value'},
    );
    
    final testVisit = BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idModule: 1,
      idDataset: 1,
      visitDateMin: '2024-03-20',
    );
    
    final testSite = BaseSite(
      idBaseSite: 1,
      baseSiteName: 'Test Site',
      baseSiteCode: 'SITE1',
    );
    
    final testModule = Module(
      id: 1,
      moduleCode: 'TEST',
      moduleLabel: 'Test Module',
      complement: ModuleComplement(
        idModule: 1,
        configuration: ModuleConfiguration(
          observation: ObjectConfig(
            label: 'Observation',
            displayProperties: ['test_field'],
            generic: {},
          ),
        ),
      ),
    );
    
    final moduleInfo = ModuleInfo(
      module: testModule,
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
    );
    
    // Mock ViewModels
    final mockObservationsViewModel = MockObservationsViewModel();
    mockObservationsViewModel.addTestObservation(testObservation);
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(testVisit.idBaseVisit).overrideWith(
            (_) => mockObservationsViewModel,
          ),
        ],
        child: MaterialApp(
          home: ObservationDetailPage(
            observation: testObservation,
            visit: testVisit,
            site: testSite,
            moduleInfo: moduleInfo,
          ),
        ),
      ),
    );
    
    await tester.pumpAndSettle();
    
    // Vérifier que les données initiales sont affichées
    expect(find.text('Initial comment'), findsOneWidget);
    expect(find.text('initial value'), findsOneWidget);
    
    // Simuler un tap sur le bouton d'édition
    final editButton = find.byIcon(Icons.edit);
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);
    await tester.pumpAndSettle();
    
    // Vérifier que la page de formulaire s'est ouverte
    expect(find.byType(ObservationFormPage), findsOneWidget);
    
    // Simuler la modification et la sauvegarde
    // (Dans un vrai test, nous interagirions avec le formulaire)
    // Pour ce test, nous simulons juste le retour avec succès
    Navigator.of(tester.element(find.byType(ObservationFormPage))).pop(true);
    
    // Mettre à jour les données de test pour simuler le changement
    final updatedObservation = Observation(
      idObservation: 1,
      idBaseVisit: 1,
      cdNom: 123,
      comments: 'Updated comment',
      data: {'test_field': 'updated value'},
    );
    mockObservationsViewModel.addTestObservation(updatedObservation);
    
    await tester.pumpAndSettle();
    
    // Vérifier que les données mises à jour sont maintenant affichées
    expect(find.text('Updated comment'), findsOneWidget);
    expect(find.text('updated value'), findsOneWidget);
  });
}