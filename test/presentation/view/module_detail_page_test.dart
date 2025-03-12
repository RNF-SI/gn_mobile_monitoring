import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/module_detail_page.dart';

void main() {
  late ModuleInfo mockModuleInfo;

  setUp(() {
    mockModuleInfo = ModuleInfo(
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
      module: Module(
        id: 1,
        moduleLabel: 'Test Module',
        moduleDesc: 'Test Description',
        sites: List.generate(
          100,
          (index) => BaseSite(
            idBaseSite: index,
            baseSiteName: 'Site $index',
            baseSiteCode: 'CODE$index',
            altitudeMin: 100,
            altitudeMax: 200,
          ),
        ),
        complement: ModuleComplement(
          idModule: 1,
          configuration: ModuleConfiguration(
            module: ModuleConfig(
              childrenTypes: ['site'],
            ),
            site: ObjectConfig(
              labelList: 'Sites',
              generic: {
                'base_site_name': GenericFieldConfig(
                  attributLabel: 'Nom du site',
                ),
              },
            ),
          ),
        ),
      ),
    );
  });

  testWidgets('ModuleDetailPage shows initial sites list',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ModuleDetailPage(moduleInfo: mockModuleInfo),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify that the table header is shown
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Nom du site'), findsOneWidget);
    expect(find.text('Code'), findsOneWidget);
    expect(find.text('Altitude'), findsOneWidget);

    // Verify that the first site is shown
    expect(find.text('Site 0'), findsOneWidget);
    expect(find.text('CODE0'), findsOneWidget);

    // Verify that we have the correct number of visibility icons
    expect(find.byIcon(Icons.visibility), findsNWidgets(20));
  });

  testWidgets('ModuleDetailPage shows sites list content correctly',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModuleDetailPage(moduleInfo: mockModuleInfo),
        ),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify initial content
    for (var i = 0; i < 20; i++) {
      expect(find.text('Site $i'), findsOneWidget);
      expect(find.text('CODE$i'), findsOneWidget);
    }

    // Verify that site 20 is not visible yet
    expect(find.text('Site 20'), findsNothing);

    // Find the scrollable
    final scrollable = find.byType(SingleChildScrollView);
    final scrollableWidget = tester.widget<SingleChildScrollView>(scrollable);
    final controller = scrollableWidget.controller;

    // Simulate scroll to near the bottom
    if (controller != null) {
      controller.jumpTo(controller.position.maxScrollExtent - 100);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify that we can now see site 20
      expect(find.text('Site 20'), findsOneWidget);
      expect(find.text('CODE20'), findsOneWidget);
    } else {
      fail('ScrollController not found');
    }
  });

  testWidgets('ModuleDetailPage shows properties card with correct information',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ModuleDetailPage(moduleInfo: mockModuleInfo),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify that the properties card shows the correct information
    expect(find.text('Propriétés'), findsOneWidget);
    expect(find.text('Test Module'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });
}
