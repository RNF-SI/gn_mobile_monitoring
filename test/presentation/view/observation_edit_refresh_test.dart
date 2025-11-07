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
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';

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

  // Vider les observations pour les tests
  void clearTestObservations() {
    _observations.clear();
  }

  // Mettre à jour l'état pour notifier les listeners
  void notifyListeners() {
    state = AsyncValue.data(List.from(_observations));
  }
}

void main() {
  testWidgets('ObservationDetailPage displays observation data and edit button', (WidgetTester tester) async {
    // Données de test
    final testObservation = Observation(
      idObservation: 1,
      idBaseVisit: 1,
      cdNom: 123,
      comments: 'Test comment',
      data: {'test_field': 'test value'},
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
    
    // Utiliser pump() avec une durée spécifique au lieu de pumpAndSettle()
    // pour éviter les timeouts causés par des timers ou animations infinies
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Vérifier que les données sont affichées
    expect(find.text('Test comment'), findsOneWidget);
    expect(find.text('test value'), findsOneWidget);

    // Vérifier que le bouton d'édition est présent
    final editButton = find.byIcon(Icons.edit);
    expect(editButton, findsOneWidget);
  });
}