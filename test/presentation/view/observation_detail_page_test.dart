import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockObservationDetailViewModel
    extends StateNotifier<AsyncValue<List<ObservationDetail>>>
    with Mock
    implements ObservationDetailViewModel {
  MockObservationDetailViewModel() : super(const AsyncValue.data([]));

  @override
  Future<List<ObservationDetail>> getObservationDetailsByObservationId(
      int observationId) async {
    return [];
  }

  @override
  Future<ObservationDetail?> getObservationDetailById(
      int observationDetailId) async {
    return null;
  }

  @override
  Future<int> saveObservationDetail(ObservationDetail detail) async {
    return 1;
  }

  @override
  Future<bool> deleteObservationDetail(int observationDetailId) async {
    return true;
  }

  @override
  Future<void> loadObservationDetails() async {}
}

void main() {
  late MockObservationDetailViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockObservationDetailViewModel();
  });

  testWidgets('ObservationDetailPage displays observation details correctly',
      (WidgetTester tester) async {
    // Créer les données de test
    final observation = Observation(
      idObservation: 1,
      idBaseVisit: 1,
      metaCreateDate: DateTime.now().toString(),
      data: {},
    );

    final visit = BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idModule: 1,
      idDataset: 1,
      visitDateMin: DateTime.now().toString(),
    );

    final site = BaseSite(
      idBaseSite: 1,
      baseSiteCode: 'SITE1',
      baseSiteName: 'Test Site',
    );

    final testModule = Module(
      id: 1,
      moduleCode: 'TEST',
      moduleLabel: 'Test Module',
      moduleDesc: 'Test Description',
      complement: ModuleComplement(
        idModule: 1,
        configuration: ModuleConfiguration(
          observation: ObjectConfig(
            label: 'Observation',
            displayList: [],
            generic: {},
          ),
        ),
      ),
    );

    final testModuleInfo = ModuleInfo(
      module: testModule,
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
      downloadProgress: 0,
    );

    // Construire le widget avec le ProviderScope
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationDetailsProvider(observation.idObservation)
              .overrideWith((_) => mockViewModel),
        ],
        child: MaterialApp(
          home: ObservationDetailPage(
            observation: observation,
            visit: visit,
            site: site,
            moduleInfo: testModuleInfo,
          ),
        ),
      ),
    );

    // Attendre que le widget soit construit
    await tester.pump();

    // Attendre que l'interface se mette à jour après le chargement des données
    await tester.pump(const Duration(milliseconds: 50));

    // Vérifier que les éléments sont affichés
    expect(find.text('Informations générales'), findsOneWidget);
    expect(find.text('ID'), findsOneWidget);
    expect(find.text(observation.idObservation.toString()), findsOneWidget);
  });
}
