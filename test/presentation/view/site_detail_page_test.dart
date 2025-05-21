import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/datasets_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks pour les tests
class MockGetVisitsBySiteAndModuleUseCase extends Mock
    implements GetVisitsBySiteAndModuleUseCase {}

class MockGetVisitWithDetailsUseCase extends Mock
    implements GetVisitWithDetailsUseCase {}

class MockGetVisitComplementUseCase extends Mock
    implements GetVisitComplementUseCase {}

class MockSaveVisitComplementUseCase extends Mock
    implements SaveVisitComplementUseCase {}

class MockCreateVisitUseCase extends Mock implements CreateVisitUseCase {}

class MockUpdateVisitUseCase extends Mock implements UpdateVisitUseCase {}

class MockDeleteVisitUseCase extends Mock implements DeleteVisitUseCase {}

class MockGetUserIdFromLocalStorageUseCase extends Mock
    implements GetUserIdFromLocalStorageUseCase {}

class MockGetUserNameFromLocalStorageUseCase extends Mock
    implements GetUserNameFromLocalStorageUseCase {}

class MockGetObservationsByVisitIdUseCase extends Mock
    implements GetObservationsByVisitIdUseCase {}

class MockDatasetService extends Mock implements DatasetService {}

void main() {
  group('SiteDetailPage Tests', () {
    // Variables partagées
    late BaseSite testSite;
    late ModuleInfo testModuleInfo;

    // Créer un objet SiteGroup au lieu d'une Map
    final testSiteGroup = SiteGroup(
      idSitesGroup: 1,
      sitesGroupName: 'Test Site Group',
      sitesGroupCode: 'TSG1',
      sitesGroupDescription: 'Test site group description',
    );

    // Mocks pour les tests
    late MockGetVisitsBySiteAndModuleUseCase
        mockGetVisitsBySiteAndModuleUseCase;
    late MockGetVisitWithDetailsUseCase mockGetVisitWithDetailsUseCase;
    late MockGetVisitComplementUseCase mockGetVisitComplementUseCase;
    late MockSaveVisitComplementUseCase mockSaveVisitComplementUseCase;
    late MockCreateVisitUseCase mockCreateVisitUseCase;
    late MockUpdateVisitUseCase mockUpdateVisitUseCase;
    late MockDeleteVisitUseCase mockDeleteVisitUseCase;
    late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
    late MockGetUserNameFromLocalStorageUseCase mockGetUserNameUseCase;
    late MockGetObservationsByVisitIdUseCase mockGetObservationsByVisitIdUseCase;
    late MockDatasetService mockDatasetService;

    setUp(() {
      testSite = BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test Site',
        baseSiteCode: 'TST1',
        baseSiteDescription: 'Test site description',
        firstUseDate: DateTime.parse('2024-04-01'),
      );

      // Créer une configuration pour le site
      final siteConfig = ObjectConfig(
        label: 'Site',
        displayList: ['habitat', 'altitude', 'exposure'],
        generic: {
          'habitat': GenericFieldConfig(
            attributLabel: 'Habitat',
            typeWidget: 'text',
          ),
          'altitude': GenericFieldConfig(
            attributLabel: 'Altitude',
            typeWidget: 'number',
          ),
          'exposure': GenericFieldConfig(
            attributLabel: 'Exposition',
            typeWidget: 'select',
          ),
        },
      );

      // Créer une configuration pour les visites
      final visitConfig = ObjectConfig(
        label: 'Visite',
        displayList: ['visit_date_min', 'observers', 'comments'],
      );

      // Créer une configuration complète de module
      final moduleConfig = ModuleConfiguration(
        site: siteConfig,
        visit: visitConfig,
        custom: CustomConfig(
          moduleCode: 'TEST',
          idModule: 1,
          monitoringsPath: '/api/monitorings',
        ),
      );

      // Créer un objet ModuleInfo pour les tests
      testModuleInfo = ModuleInfo(
        module: Module(
          id: 1,
          moduleLabel: 'Test Module',
          moduleCode: 'TEST',
          moduleDesc: 'Test module description',
          complement: ModuleComplement(
            idModule: 1,
            configuration: moduleConfig,
          ),
        ),
        downloadStatus: ModuleDownloadStatus.moduleDownloaded,
      );

      // Initialiser les mocks
      mockGetVisitsBySiteAndModuleUseCase =
          MockGetVisitsBySiteAndModuleUseCase();
      mockGetVisitWithDetailsUseCase = MockGetVisitWithDetailsUseCase();
      mockGetVisitComplementUseCase = MockGetVisitComplementUseCase();
      mockSaveVisitComplementUseCase = MockSaveVisitComplementUseCase();
      mockCreateVisitUseCase = MockCreateVisitUseCase();
      mockUpdateVisitUseCase = MockUpdateVisitUseCase();
      mockDeleteVisitUseCase = MockDeleteVisitUseCase();
      mockGetUserIdUseCase = MockGetUserIdFromLocalStorageUseCase();
      mockGetUserNameUseCase = MockGetUserNameFromLocalStorageUseCase();
      mockGetObservationsByVisitIdUseCase = MockGetObservationsByVisitIdUseCase();
      mockDatasetService = MockDatasetService();

      // Configurer les comportements des mocks
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(any(), any()))
          .thenAnswer((_) async => <BaseVisit>[]);

      // Configure DatasetService mock behavior
      when(() => mockDatasetService.getDatasetsForModule(any()))
          .thenAnswer((_) async => []);
    });

    testWidgets(
        'renders correctly with site data and displays site information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider.overrideWith((ref, params) {
              return SiteVisitsViewModel(
                mockGetVisitsBySiteAndModuleUseCase,
                mockGetVisitWithDetailsUseCase,
                mockGetObservationsByVisitIdUseCase,
                mockGetVisitComplementUseCase,
                mockSaveVisitComplementUseCase,
                mockCreateVisitUseCase,
                mockUpdateVisitUseCase,
                mockDeleteVisitUseCase,
                mockGetUserIdUseCase,
                mockGetUserNameUseCase,
                mockDatasetService,
                testSite.idBaseSite,
                testModuleInfo.module.id,
              );
            }),
          ],
          child: MaterialApp(
            home: SiteDetailPage(
              site: testSite,
              moduleInfo: testModuleInfo,
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Vérifier que les informations de base du site sont affichées
      expect(find.text('Informations générales'), findsOneWidget);
      expect(find.text('Code'), findsOneWidget);
      expect(find.text('TST1'), findsAtLeastNWidgets(1));
      expect(find.text('Nom'), findsOneWidget);
      expect(find.text('Test Site'), findsAtLeastNWidgets(1));
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Test site description'), findsOneWidget);

      // Vérifier que le message d'absence de visites est affiché
      expect(find.textContaining('Aucune'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays site group in breadcrumb when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider.overrideWith((ref, params) {
              return SiteVisitsViewModel(
                mockGetVisitsBySiteAndModuleUseCase,
                mockGetVisitWithDetailsUseCase,
                mockGetObservationsByVisitIdUseCase,
                mockGetVisitComplementUseCase,
                mockSaveVisitComplementUseCase,
                mockCreateVisitUseCase,
                mockUpdateVisitUseCase,
                mockDeleteVisitUseCase,
                mockGetUserIdUseCase,
                mockGetUserNameUseCase,
                mockDatasetService,
                testSite.idBaseSite,
                testModuleInfo.module.id,
              );
            }),
          ],
          child: MaterialApp(
            home: SiteDetailPage(
              site: testSite,
              moduleInfo: testModuleInfo,
              fromSiteGroup: testSiteGroup,
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Vérifier que les éléments du fil d'Ariane sont présents
      expect(find.textContaining('Module'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Test Module'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Groupe'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Test Site Group'), findsAtLeastNWidgets(1));
    });

    testWidgets('displays visits when available', (WidgetTester tester) async {
      // Exemple de visite
      final testVisits = [
        BaseVisit(
          idBaseVisit: 1,
          idBaseSite: testSite.idBaseSite,
          idModule: testModuleInfo.module.id,
          idDataset: 1,
          visitDateMin: '2024-04-01',
          visitDateMax: '2024-04-01',
          comments: 'Visite de test',
          observers: [1, 2],
        ),
      ];

      // Configurer le mock pour retourner la visite
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(any(), any()))
          .thenAnswer((_) async => testVisits);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider.overrideWith((ref, params) {
              return SiteVisitsViewModel(
                mockGetVisitsBySiteAndModuleUseCase,
                mockGetVisitWithDetailsUseCase,
                mockGetObservationsByVisitIdUseCase,
                mockGetVisitComplementUseCase,
                mockSaveVisitComplementUseCase,
                mockCreateVisitUseCase,
                mockUpdateVisitUseCase,
                mockDeleteVisitUseCase,
                mockGetUserIdUseCase,
                mockGetUserNameUseCase,
                mockDatasetService,
                testSite.idBaseSite,
                testModuleInfo.module.id,
              );
            }),
          ],
          child: MaterialApp(
            home: SiteDetailPage(
              site: testSite,
              moduleInfo: testModuleInfo,
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Attendre que les données asynchrones soient chargées
      await tester.pump(const Duration(milliseconds: 500));

      // Le message "Aucune visite" ne devrait plus être affiché
      expect(find.text('Aucune visite pour ce site'), findsNothing);

      // Vérifier que la visite est affichée (commentaire)
      expect(find.text('Visite de test'), findsAtLeastNWidgets(1));

      // Vérifier la présence d'icônes d'action
      expect(find.byIcon(Icons.visibility), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.edit), findsAtLeastNWidgets(1));
    });

    testWidgets('handles error when loading visits',
        (WidgetTester tester) async {
      // Simuler une erreur lors du chargement des visites
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(any(), any()))
          .thenThrow(Exception('Erreur de chargement'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider.overrideWith((ref, params) {
              return SiteVisitsViewModel(
                mockGetVisitsBySiteAndModuleUseCase,
                mockGetVisitWithDetailsUseCase,
                mockGetObservationsByVisitIdUseCase,
                mockGetVisitComplementUseCase,
                mockSaveVisitComplementUseCase,
                mockCreateVisitUseCase,
                mockUpdateVisitUseCase,
                mockDeleteVisitUseCase,
                mockGetUserIdUseCase,
                mockGetUserNameUseCase,
                mockDatasetService,
                testSite.idBaseSite,
                testModuleInfo.module.id,
              );
            }),
          ],
          child: MaterialApp(
            home: SiteDetailPage(
              site: testSite,
              moduleInfo: testModuleInfo,
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Attendre que les données asynchrones soient chargées (ou échouent)
      await tester.pump(const Duration(milliseconds: 500));

      // Vérifier qu'un message d'erreur est affiché
      expect(find.textContaining('Erreur'), findsAtLeastNWidgets(1));
    });

    testWidgets('has the expected UI structure with proper elements',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider.overrideWith((ref, params) {
              return SiteVisitsViewModel(
                mockGetVisitsBySiteAndModuleUseCase,
                mockGetVisitWithDetailsUseCase,
                mockGetObservationsByVisitIdUseCase,
                mockGetVisitComplementUseCase,
                mockSaveVisitComplementUseCase,
                mockCreateVisitUseCase,
                mockUpdateVisitUseCase,
                mockDeleteVisitUseCase,
                mockGetUserIdUseCase,
                mockGetUserNameUseCase,
                mockDatasetService,
                testSite.idBaseSite,
                testModuleInfo.module.id,
              );
            }),
          ],
          child: MaterialApp(
            home: SiteDetailPage(
              site: testSite,
              moduleInfo: testModuleInfo,
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Vérifier la structure de l'interface
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(Card), findsAtLeastNWidgets(1));
      expect(find.byType(TabBar), findsAtLeastNWidgets(1));

      // Vérifier l'onglet "Visites"
      expect(find.text('Visites'), findsOneWidget);
    });
  });
}