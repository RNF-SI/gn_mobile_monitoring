import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:mocktail/mocktail.dart';

// Mock pour le GlobalKey
class MockDynamicFormBuilderState extends Mock
    implements DynamicFormBuilderState {}

void main() {
  late ObjectConfig testObjectConfig;
  late CustomConfig testCustomConfig;

  setUp(() {
    // Configuration pour les tests avec différents types de champs
    testObjectConfig = ObjectConfig(
      label: 'Test Form',
      chained: true,
      generic: {
        'text_field': GenericFieldConfig(
          attributLabel: 'Text Field',
          typeWidget: 'text',
          required: true,
        ),
        'number_field': GenericFieldConfig(
          attributLabel: 'Number Field',
          typeWidget: 'number',
          required: false,
        ),
        'date_field': GenericFieldConfig(
          attributLabel: 'Date Field',
          typeWidget: 'date',
        ),
      },
      specific: {
        'textarea_field': {
          'attribut_label': 'Text Area',
          'type_widget': 'textarea',
          'description': 'Enter a long text',
        },
        'select_field': {
          'attribut_label': 'Select Option',
          'type_widget': 'select',
          'values': [
            {'label': 'Option 1', 'value': '1'},
            {'label': 'Option 2', 'value': '2'},
          ],
        },
      },
    );

    testCustomConfig = CustomConfig(
      moduleCode: 'TEST',
      idModule: 1,
    );
  });

  testWidgets('DynamicFormBuilder should render all field types',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicFormBuilder(
            objectConfig: testObjectConfig,
            customConfig: testCustomConfig,
          ),
        ),
      ),
    );

    // Wait for form to build
    await tester.pumpAndSettle();

    // Verify field labels are displayed
    expect(find.text('Text Field *'), findsOneWidget); // Required field
    expect(find.text('Number Field'), findsOneWidget);
    expect(find.text('Date Field'), findsOneWidget);
    expect(find.text('Text Area'), findsOneWidget);
    expect(find.text('Select Option'), findsOneWidget);

    // Verify description is displayed
    expect(find.text('Enter a long text'), findsOneWidget);

    // Verify different field types are rendered
    expect(find.byType(TextFormField), findsAtLeastNWidgets(3)); // Text, TextArea, Number
    expect(find.byType(DropdownButtonFormField), findsOneWidget); // Select
  });

  testWidgets('DynamicFormBuilder should handle input and validation',
      (WidgetTester tester) async {
    // Create a GlobalKey to access the form state
    final formBuilderKey = GlobalKey<DynamicFormBuilderState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicFormBuilder(
            key: formBuilderKey,
            objectConfig: testObjectConfig,
            customConfig: testCustomConfig,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find the text field and enter text
    final textField = find.byType(TextFormField).first;
    await tester.enterText(textField, 'Test Input');
    await tester.pump();

    // Validate the form - should pass as text is entered
    expect(formBuilderKey.currentState?.validate(), isTrue);

    // Clear the text field to trigger validation error
    await tester.enterText(textField, '');
    await tester.pump();

    // Try to validate - should fail as required field is empty
    expect(formBuilderKey.currentState?.validate(), isFalse);

    // Error message should appear
    await tester.pump();
    expect(find.text('Ce champ est requis'), findsOneWidget);
  });

  testWidgets('DynamicFormBuilder should handle initial values',
      (WidgetTester tester) async {
    // Setup initial values
    final initialValues = {
      'text_field': 'Initial Text',
      'number_field': 42,
      'select_field': '2',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicFormBuilder(
            objectConfig: testObjectConfig,
            customConfig: testCustomConfig,
            initialValues: initialValues,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify text field has initial value
    expect(find.text('Initial Text'), findsOneWidget);

    // Verify number field has initial value
    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('DynamicFormBuilder should toggle chain input correctly',
      (WidgetTester tester) async {
    bool? chainInputValue;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicFormBuilder(
            objectConfig: testObjectConfig,
            customConfig: testCustomConfig,
            chainInput: true,
            onChainInputChanged: (value) {
              chainInputValue = value;
            },
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Find switch for chain input
    final switchWidget = find.byType(Switch);
    expect(switchWidget, findsOneWidget);

    // Verify it's initially on (as we passed chainInput: true)
    expect((tester.widget(switchWidget) as Switch).value, isTrue);

    // Tap to toggle it off
    await tester.tap(switchWidget);
    await tester.pumpAndSettle();

    // Verify callback was called with false
    expect(chainInputValue, isFalse);
  });

  testWidgets('DynamicFormBuilder should reset form', (WidgetTester tester) async {
    // Create a GlobalKey to access the form state
    final formBuilderKey = GlobalKey<DynamicFormBuilderState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicFormBuilder(
            key: formBuilderKey,
            objectConfig: testObjectConfig,
            customConfig: testCustomConfig,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter text in field
    final textField = find.byType(TextFormField).first;
    await tester.enterText(textField, 'Test Input');
    await tester.pump();

    // Reset the form
    formBuilderKey.currentState?.resetForm();
    await tester.pump();

    // Field should be empty
    expect(find.text('Test Input'), findsNothing);
  });

  testWidgets('DynamicFormBuilder should return form values',
      (WidgetTester tester) async {
    // Create a GlobalKey to access the form state
    final formBuilderKey = GlobalKey<DynamicFormBuilderState>();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DynamicFormBuilder(
            key: formBuilderKey,
            objectConfig: testObjectConfig,
            customConfig: testCustomConfig,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Enter values in fields
    await tester.enterText(find.byType(TextFormField).first, 'Test Input');
    await tester.pump();

    // Get form values
    final formValues = formBuilderKey.currentState?.getFormValues();
    
    // Values should contain the entered text
    expect(formValues, isNotNull);
    expect(formValues!['text_field'], 'Test Input');
  });
}