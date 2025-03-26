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
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockObservationsViewModel extends Mock implements ObservationsViewModel {}

void main() {
  late BaseSite site;
  late BaseVisit visit;
  late Observation observation;
  late ModuleInfo moduleInfo;

  setUp(() {
    site = BaseSite(
      idBaseSite: 1,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TS001',
    );

    visit = BaseVisit(
      idBaseVisit: 1,
      visitDateMin: '2024-03-20',
      idModule: 1,
      idDataset: 1,
    );

    observation = Observation(
      idObservation: 1,
      comments: 'Test comment',
      data: {'test_field': 'test_value'},
      metaCreateDate: '2024-03-20',
      metaUpdateDate: '2024-03-20',
    );

    moduleInfo = ModuleInfo(
      module: Module(
        id: 1,
        moduleLabel: 'Test Module',
        complement: ModuleComplement(
          idModule: 1,
          configuration: ModuleConfiguration(
            observation: ObjectConfig(
              label: 'Observation',
              displayList: ['test_field', 'comments'],
              generic: {
                'test_field': GenericFieldConfig(
                  attributLabel: 'Test Field',
                  typeWidget: 'text',
                ),
                'comments': GenericFieldConfig(
                  attributLabel: 'Commentaires',
                  typeWidget: 'textarea',
                ),
              },
            ),
            site: ObjectConfig(
              label: 'Site',
              displayList: [],
              generic: {},
            ),
            visit: ObjectConfig(
              label: 'Visite',
              displayList: [],
              generic: {},
            ),
          ),
        ),
      ),
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
    );
  });

  testWidgets('ObservationDetailPage displays observation details correctly',
      (WidgetTester tester) async {
    final mockObservationsViewModel = MockObservationsViewModel();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(visit.idBaseVisit)
              .overrideWith((ref) => mockObservationsViewModel),
        ],
        child: MaterialApp(
          home: ObservationDetailPage(
            observation: observation,
            visit: visit,
            site: site,
            moduleInfo: moduleInfo,
          ),
        ),
      ),
    );

    // Vérifier que les informations générales sont affichées
    expect(find.text('Informations générales'), findsOneWidget);
    expect(find.text('ID'), findsOneWidget);
    expect(find.text('Commentaires'), findsOneWidget);
    expect(find.text('Données spécifiques'), findsOneWidget);

    // Vérifier que le bouton d'édition est présent
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('ObservationDetailPage handles missing configuration',
      (WidgetTester tester) async {
    final mockObservationsViewModel = MockObservationsViewModel();
    final moduleInfoWithoutConfig = ModuleInfo(
      module: Module(
        id: 1,
        moduleLabel: 'Test Module',
        complement: ModuleComplement(
          idModule: 1,
          configuration: ModuleConfiguration(),
        ),
      ),
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(visit.idBaseVisit)
              .overrideWith((ref) => mockObservationsViewModel),
        ],
        child: MaterialApp(
          home: ObservationDetailPage(
            observation: observation,
            visit: visit,
            site: site,
            moduleInfo: moduleInfoWithoutConfig,
          ),
        ),
      ),
    );

    // Vérifier que la page s'affiche sans erreur même sans configuration
    expect(find.text('Informations générales'), findsOneWidget);
    expect(find.text('Commentaires'), findsOneWidget);
    expect(find.text('Données spécifiques'), findsOneWidget);
  });
}
