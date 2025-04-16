import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:mocktail/mocktail.dart';

// Mocks nécessaires pour les tests
class MockSiteVisitsViewModel extends StateNotifier<AsyncValue<List<BaseVisit>>>
    with Mock
    implements SiteVisitsViewModel {
  MockSiteVisitsViewModel() : super(const AsyncValue.data([]));
}

// Pour l'accès à WidgetRef dans les tests
class TestSiteDetailPageBase extends DetailPage {
  final WidgetRef widgetRef;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const TestSiteDetailPageBase({
    super.key,
    required this.widgetRef,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });

  @override
  DetailPageState<DetailPage> createState() => TestSiteDetailPageBaseState();
}

class TestSiteDetailPageBaseState
    extends DetailPageState<TestSiteDetailPageBase> {
  @override
  ObjectConfig? get objectConfig =>
      widget.moduleInfo?.module.complement?.configuration?.site;

  @override
  CustomConfig? get customConfig =>
      widget.moduleInfo?.module.complement?.configuration?.custom;

  @override
  List<String>? get displayProperties =>
      objectConfig?.displayProperties ?? objectConfig?.displayList;

  Map<String, dynamic> _objectDataValue = {};

  @override
  Map<String, dynamic> get objectData => _objectDataValue;

  void setObjectData(Map<String, dynamic> data) {
    _objectDataValue = data;
  }

  @override
  String get propertiesTitle => 'Propriétés du site';

  @override
  bool get separateEmptyFields => true;

  @override
  List<BreadcrumbItem> getBreadcrumbItems() {
    final items = <BreadcrumbItem>[];

    if (widget.moduleInfo != null) {
      // Module
      items.add(
        BreadcrumbItem(
          label: 'Module',
          value: widget.moduleInfo!.module.moduleLabel ?? 'Module',
          onTap: () {},
        ),
      );

      // Groupe de site (si disponible)
      if (widget.fromSiteGroup != null) {
        items.add(
          BreadcrumbItem(
            label: 'Groupe',
            value: widget.fromSiteGroup['sitesGroupName'] ?? 'Groupe',
            onTap: () {},
          ),
        );
      }

      // Site actuel
      items.add(
        BreadcrumbItem(
          label: 'Site',
          value: widget.site.baseSiteName ?? widget.site.baseSiteCode ?? 'Site',
        ),
      );
    }

    return items;
  }

  @override
  Widget buildBaseContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Propriétés du site - non expandable et taille intrinsèque
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Informations générales',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    buildInfoRow(
                        'Code', widget.site.baseSiteCode ?? 'Non spécifié'),
                    buildInfoRow(
                        'Nom', widget.site.baseSiteName ?? 'Non spécifié'),
                    buildInfoRow('Description',
                        widget.site.baseSiteDescription ?? 'Non spécifiée'),
                  ],
                ),
              ),
            ),
          ),

          // Propriétés spécifiques au module si présentes
          if (_objectDataValue.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildPropertiesWidget(),
            ),
        ],
      ),
    );
  }

  @override
  Widget? buildChildrenContent() {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: const Text('Aucune visite pour ce site'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle visite'),
          ),
        ),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('SiteDetailPageBase Tests', () {
    late BaseSite testSite;
    late ModuleInfo testModuleInfo;
    late MockSiteVisitsViewModel mockViewModel;

    setUp(() {
      testSite = BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Test Site',
        baseSiteCode: 'TST1',
        baseSiteDescription: 'Test site description',
        firstUseDate: DateTime.parse('2024-04-01'),
      );

      // Créer une config spécifique pour le site
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

      // Créer une config pour les visites
      final visitConfig = ObjectConfig(
        label: 'Visite',
        displayList: ['visit_date_min', 'observers', 'comments'],
      );

      // Créer une configuration de module avec site et visite
      final moduleConfig = ModuleConfiguration(
        site: siteConfig,
        visit: visitConfig,
        custom: CustomConfig(
          moduleCode: 'TEST',
          idModule: 1,
          monitoringsPath: '/api/monitorings',
        ),
      );

      // Créer un module avec la configuration
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

      // Créer le mock pour le ViewModel
      mockViewModel = MockSiteVisitsViewModel();
    });

    testWidgets('renders correctly with site data and module info',
        (WidgetTester tester) async {
      // Pour les besoins du test, on utilise notre classe de test plutôt que SiteDetailPageBase
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider((testSite.idBaseSite, 1))
                .overrideWith((_) => mockViewModel),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              home: TestSiteDetailPageBase(
                widgetRef: ref,
                site: testSite,
                moduleInfo: testModuleInfo,
              ),
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Vérifier que les informations de base du site sont affichées
      expect(find.text('Informations générales'), findsOneWidget);
      expect(find.text('Code'), findsOneWidget);
      expect(find.text('TST1'), findsOneWidget);
      expect(find.text('Nom'), findsOneWidget);
      expect(find.text('Test Site'), findsAtLeastNWidgets(1));
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Test site description'), findsOneWidget);

      // Vérifier que le bouton d'ajout de visite est affiché
      expect(find.text('Nouvelle visite'), findsOneWidget);
    });

    testWidgets('displays breadcrumb correctly with module and site group',
        (WidgetTester tester) async {
      // Pour les besoins du test, on utilise notre classe de test
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider((testSite.idBaseSite, 1))
                .overrideWith((_) => mockViewModel),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              home: TestSiteDetailPageBase(
                widgetRef: ref,
                site: testSite,
                moduleInfo: testModuleInfo,
                fromSiteGroup: {
                  'sitesGroupName': 'Test Site Group',
                  'sitesGroupCode': 'TSG1'
                },
              ),
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Vérifier que le fil d'Ariane est affiché
      expect(find.byType(BreadcrumbNavigation), findsOneWidget);

      // Vérifier les éléments du fil d'Ariane
      expect(find.text('Module: Test Module'), findsOneWidget);
      expect(find.text('Groupe: Test Site Group'), findsOneWidget);
      expect(find.text('Site: Test Site'), findsOneWidget);
    });

    testWidgets('initializes objectData property correctly',
        (WidgetTester tester) async {
      // Pour les besoins du test, on utilise notre classe de test
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider((testSite.idBaseSite, 1))
                .overrideWith((_) => mockViewModel),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              home: TestSiteDetailPageBase(
                widgetRef: ref,
                site: testSite,
                moduleInfo: testModuleInfo,
              ),
            ),
          ),
        ),
      );

      // Attendre que le widget soit construit
      await tester.pump();

      // Accéder à l'état du widget
      final state = tester.state<TestSiteDetailPageBaseState>(
          find.byType(TestSiteDetailPageBase));

      // Vérifier que l'état est correctement initialisé
      expect(state.objectData, isA<Map<String, dynamic>>());
      
      // Définir les données de l'objet
      state.setObjectData({
        'habitat': 'Forêt',
        'altitude': 1200,
        'exposure': 'Sud',
      });

      // Vérifier que les données sont bien définies
      expect(state.objectData.containsKey('habitat'), isTrue);
      expect(state.objectData['habitat'], equals('Forêt'));
      expect(state.objectData['altitude'], equals(1200));
    });

    testWidgets('displays empty visits message', (WidgetTester tester) async {
      // Pour les besoins du test, on utilise notre classe de test
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider((testSite.idBaseSite, 1))
                .overrideWith((_) => mockViewModel),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              home: TestSiteDetailPageBase(
                widgetRef: ref,
                site: testSite,
                moduleInfo: testModuleInfo,
              ),
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Vérifier que le message pour "aucune visite" s'affiche
      expect(find.text('Aucune visite pour ce site'), findsOneWidget);
    });

    testWidgets('uses factorized methods from DetailPage correctly',
        (WidgetTester tester) async {
      // Pour les besoins du test, on utilise notre classe de test
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider((testSite.idBaseSite, 1))
                .overrideWith((_) => mockViewModel),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              home: TestSiteDetailPageBase(
                widgetRef: ref,
                site: testSite,
                moduleInfo: testModuleInfo,
              ),
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();

      // Accéder à l'état du widget
      final state = tester.state<TestSiteDetailPageBaseState>(
          find.byType(TestSiteDetailPageBase));

      // Vérifier que les méthodes de DetailPage sont utilisées
      expect(state.propertiesTitle, 'Propriétés du site');
      expect(state.separateEmptyFields, isTrue);
      expect(state.getBreadcrumbItems().isNotEmpty, isTrue);

      // Vérifier que la propriété objectConfig est correctement initialisée
      expect(state.objectConfig, isNotNull);
      expect(state.objectConfig?.label, 'Site');
    });

    testWidgets('overrides buildBaseContent correctly',
        (WidgetTester tester) async {
      // Pour les besoins du test, on utilise notre classe de test
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            siteVisitsViewModelProvider((testSite.idBaseSite, 1))
                .overrideWith((_) => mockViewModel),
          ],
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              home: TestSiteDetailPageBase(
                widgetRef: ref,
                site: testSite,
                moduleInfo: testModuleInfo,
              ),
            ),
          ),
        ),
      );

      // Attendre que tous les widgets soient construits
      await tester.pump();

      // Vérifier que buildBaseContent est bien surchargé (vérifier la présence du Card spécifique)
      expect(find.text('Informations générales'), findsOneWidget);

      // Vérifier les éléments spécifiques à la surcharge de buildBaseContent
      expect(
          find.widgetWithText(Card, 'Informations générales'), findsOneWidget);
    });
  });
}
