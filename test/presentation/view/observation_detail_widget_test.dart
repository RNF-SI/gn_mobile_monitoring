import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_widget.dart';

void main() {
  group('ObservationDetailWidget', () {
    testWidgets('should display observation detail information', (WidgetTester tester) async {
      // Arrange
      final ObjectConfig observationDetail = ObjectConfig(
        label: 'Observation détail',
        specific: {
          'hauteur_strate': {
            'attribut_label': 'Strate',
            'type_widget': 'select',
            'values': ['entre 0 et 5 cm', 'entre 5 et 12,5 cm']
          },
          'denombrement': {
            'attribut_label': 'Dénombrement',
            'min': 0,
            'type_widget': 'number'
          }
        },
        displayProperties: ['hauteur_strate', 'denombrement']
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ObservationDetailWidget(
              observationDetail: observationDetail,
              customConfig: null,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Observation détail'), findsOneWidget);
      expect(find.text('Strate'), findsOneWidget);
      expect(find.text('Dénombrement'), findsOneWidget);
    });

    testWidgets('should show empty state when no observation detail', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ObservationDetailWidget(
              observationDetail: null,
              customConfig: null,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Aucune observation détaillée disponible'), findsOneWidget);
    });
  });
}