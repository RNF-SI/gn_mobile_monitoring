import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info_list.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockUserModulesViewModel extends Mock implements UserModulesViewModel {}

void main() {
  late MockUserModulesViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockUserModulesViewModel();
  });

  testWidgets('ModuleListWidget should display loading state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState =
        const custom_async_state.State<ModuleInfoList>.loading();

    final container = ProviderContainer(
      overrides: [
        userModuleListeProvider.overrideWithValue(customState),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: ModuleListWidget(),
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // Il n'y a pas de texte "Loading modules..." dans l'implémentation actuelle
  });

  testWidgets(
      'ModuleListWidget should display error state with retry + copy (#168)',
      (WidgetTester tester) async {
    // Arrange
    final customState = custom_async_state.State<ModuleInfoList>.error(
      Exception('Failed to load modules'),
    );

    final container = ProviderContainer(
      overrides: [
        userModuleListeProvider.overrideWithValue(customState),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: ModuleListWidget(),
          ),
        ),
      ),
    );

    // Assert : le message d'erreur est copiable (#168) + bouton Réessayer +
    // bouton Copier + le pull-to-refresh reste actif via RefreshIndicator.
    expect(find.textContaining('Impossible de charger'), findsOneWidget);
    expect(find.textContaining('Failed to load modules'), findsOneWidget);
    expect(find.byKey(const Key('module-list-retry-button')), findsOneWidget);
    expect(find.byKey(const Key('module-list-copy-error-button')),
        findsOneWidget);
    expect(find.byType(RefreshIndicator), findsOneWidget);
    expect(find.byType(SelectableText), findsOneWidget);
  });

  testWidgets('ModuleListWidget should display modules correctly when loaded',
      (WidgetTester tester) async {
    // Arrange
    final modules = [
      const Module(
        id: 1,
        moduleCode: 'code1',
        moduleLabel: 'Module 1',
        moduleDesc: 'Description 1',
        modulePath: 'path/to/module1',
        activeFrontend: true,
        moduleTarget: 'target1',
        modulePicto: 'picto1',
        moduleDocUrl: 'doc/url1',
        moduleGroup: 'group1',
        downloaded: true,
      ),
      const Module(
        id: 2,
        moduleCode: 'code2',
        moduleLabel: 'Module 2',
        moduleDesc: 'Description 2',
        modulePath: 'path/to/module2',
        activeFrontend: true,
        moduleTarget: 'target2',
        modulePicto: 'picto2',
        moduleDocUrl: 'doc/url2',
        moduleGroup: 'group2',
        downloaded: false,
      ),
    ];

    final moduleInfos = modules.map((module) {
      final downloaded = module.downloaded ?? false;
      return ModuleInfo(
        module: module,
        downloadStatus: downloaded
            ? ModuleDownloadStatus.moduleDownloaded
            : ModuleDownloadStatus.moduleNotDownloaded,
      );
    }).toList();

    final moduleInfoList = ModuleInfoList(values: moduleInfos);

    final customState =
        custom_async_state.State<ModuleInfoList>.success(moduleInfoList);

    final container = ProviderContainer(
      overrides: [
        userModuleListeProvider.overrideWithValue(customState),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: ModuleListWidget(),
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Module 1'), findsOneWidget);
    expect(find.text('Module 2'), findsOneWidget);
    expect(find.text('Description 1'), findsOneWidget);
    expect(find.text('Description 2'), findsOneWidget);
  });

  testWidgets(
      'ModuleListWidget filtre la liste selon searchQuery (#163)',
      (WidgetTester tester) async {
    final modules = [
      const Module(
        id: 1,
        moduleCode: 'oiseaux',
        moduleLabel: 'Oiseaux rares',
        moduleDesc: 'desc1',
        modulePath: 'p1',
        activeFrontend: true,
        moduleTarget: 't1',
        modulePicto: 'pic1',
        moduleDocUrl: 'd1',
        moduleGroup: 'g1',
        downloaded: true,
      ),
      const Module(
        id: 2,
        moduleCode: 'reptiles',
        moduleLabel: 'Reptiles',
        moduleDesc: 'desc2',
        modulePath: 'p2',
        activeFrontend: true,
        moduleTarget: 't2',
        modulePicto: 'pic2',
        moduleDocUrl: 'd2',
        moduleGroup: 'g2',
        downloaded: false,
      ),
    ];
    final moduleInfos = modules
        .map((m) => ModuleInfo(
              module: m,
              downloadStatus: m.downloaded == true
                  ? ModuleDownloadStatus.moduleDownloaded
                  : ModuleDownloadStatus.moduleNotDownloaded,
            ))
        .toList();
    final state = custom_async_state.State<ModuleInfoList>.success(
        ModuleInfoList(values: moduleInfos));
    final container = ProviderContainer(
      overrides: [userModuleListeProvider.overrideWithValue(state)],
    );

    // Filtre sur "rept" → ne garde que "Reptiles"
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: ModuleListWidget(searchQuery: 'rept'),
          ),
        ),
      ),
    );

    expect(find.text('Reptiles'), findsOneWidget);
    expect(find.text('Oiseaux rares'), findsNothing);

    // Filtre sans résultat → message dédié
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: ModuleListWidget(searchQuery: 'zzzzz'),
          ),
        ),
      ),
    );
    expect(find.textContaining('Aucun module ne correspond'), findsOneWidget);
  });
}
