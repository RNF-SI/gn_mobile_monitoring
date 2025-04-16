import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail/observation_detail_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/property_display_widget.dart';

void main() {
  final observationDetail = ObservationDetail(
    idObservationDetail: 1,
    idObservation: 2,
    uuidObservationDetail: 'test-uuid',
    data: {
      'field1': 'value1',
      'field2': 42,
      'field3': true,
    },
  );

  final config = ObjectConfig(
    label: 'Détail d\'observation',
    displayProperties: ['field1', 'field2', 'field3'],
    generic: {
      'field1': GenericFieldConfig(
        attributLabel: 'Champ 1',
        typeUtil: 'text',
        required: true,
      ),
      'field2': GenericFieldConfig(
        attributLabel: 'Champ 2',
        typeUtil: 'number',
        required: false,
      ),
      'field3': GenericFieldConfig(
        attributLabel: 'Champ 3',
        typeUtil: 'boolean',
        required: false,
      ),
    },
  );

  final customConfig = CustomConfig();

  testWidgets('ObservationDetailDetailPage displays correct title with index',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ObservationDetailDetailPage(
            observationDetail: observationDetail,
            config: config,
            customConfig: customConfig,
            index: 3,
          ),
        ),
      ),
    );

    // Verify that the title contains the correct index
    expect(find.text('Détails de l\'observation détail 3'), findsOneWidget);
  });

  testWidgets(
      'ObservationDetailDetailPage displays PropertyDisplayWidget with correct data',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ObservationDetailDetailPage(
            observationDetail: observationDetail,
            config: config,
            customConfig: customConfig,
            index: 1,
          ),
        ),
      ),
    );

    // Verify that PropertyDisplayWidget is included
    expect(find.byType(PropertyDisplayWidget), findsOneWidget);

    // Verify that the page is scrollable
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets(
      'ObservationDetailDetailPage passes correct data to PropertyDisplayWidget',
      (WidgetTester tester) async {
    // Build our widget and trigger a frame
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ObservationDetailDetailPage(
            observationDetail: observationDetail,
            config: config,
            customConfig: customConfig,
            index: 1,
          ),
        ),
      ),
    );

    // Find the PropertyDisplayWidget
    final propertyDisplayWidget = tester.widget<PropertyDisplayWidget>(
      find.byType(PropertyDisplayWidget),
    );

    // Verify that correct data is passed to PropertyDisplayWidget
    expect(propertyDisplayWidget.data, equals(observationDetail.data));
    expect(propertyDisplayWidget.config, equals(config));
    expect(propertyDisplayWidget.customConfig, equals(customConfig));
    expect(propertyDisplayWidget.title, equals('Propriétés'));
  });
}
