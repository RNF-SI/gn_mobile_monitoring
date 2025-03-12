import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';

void main() {
  final testSite = BaseSite(
    idBaseSite: 1,
    baseSiteName: 'Test Site',
    baseSiteCode: 'TST1',
    baseSiteDescription: 'Test site description',
    altitudeMin: 100,
    altitudeMax: 200,
    metaCreateDate: DateTime.parse('2024-03-21'),
    metaUpdateDate: DateTime.parse('2024-03-21'),
  );

  testWidgets('SiteDetailPage displays site properties correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SiteDetailPage(site: testSite),
    ));

    // Verify site properties are displayed
    expect(find.text('Test Site'), findsAtLeastNWidgets(1));
    expect(find.text('TST1'), findsOneWidget);
    expect(find.text('Test site description'), findsOneWidget);
    expect(find.text('100-200m'), findsOneWidget);
    
    // Verify property labels are displayed
    expect(find.text('Nom'), findsOneWidget);
    expect(find.text('Code'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Altitude'), findsOneWidget);
    expect(find.text('Propriétés'), findsOneWidget);
  });
}
