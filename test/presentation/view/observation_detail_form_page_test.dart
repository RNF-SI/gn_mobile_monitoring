import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_form_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockObservationDetailViewModel extends Mock {
  void saveObservationDetail(Map<String, dynamic> data) {}
}

void main() {
  group('ObservationDetailFormPage', () {
    testWidgets('should display form with fields from configuration',
        (WidgetTester tester) async {
      // Arrange
      final ObjectConfig observationDetail =
          ObjectConfig(label: 'Observation détail', specific: {
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
      }, displayProperties: [
        'hauteur_strate',
        'denombrement'
      ]);

      final mockViewModel = MockObservationDetailViewModel();

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Provide mock viewmodel
          ],
          child: MaterialApp(
            home: ObservationDetailFormPage(
              observationDetail: observationDetail,
              observation: Observation(idObservation: 1),
              customConfig: null,
            ),
          ),
        ),
      );

      // Wait for form to build
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Observation détail'), findsOneWidget);
      expect(find.text('Strate'), findsOneWidget);
      expect(find.text('Dénombrement'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField),
          findsOneWidget); // For Strate field
      expect(
          find.byType(TextFormField), findsOneWidget); // For Dénombrement field
    });

    testWidgets('should show validation errors for required fields',
        (WidgetTester tester) async {
      // Arrange
      final ObjectConfig observationDetail =
          ObjectConfig(label: 'Observation détail', specific: {
        'denombrement': {
          'attribut_label': 'Dénombrement',
          'min': 0,
          'type_widget': 'number',
          'required': true
        }
      }, displayProperties: [
        'denombrement'
      ]);

      // Act
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Provide mock viewmodel
          ],
          child: MaterialApp(
            home: ObservationDetailFormPage(
              observationDetail: observationDetail,
              observation: Observation(idObservation: 1),
              customConfig: null,
            ),
          ),
        ),
      );

      // Wait for form to build
      await tester.pumpAndSettle();

      // Try to submit the form without filling required fields
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Ce champ est obligatoire'), findsOneWidget);
    });
  });
}
