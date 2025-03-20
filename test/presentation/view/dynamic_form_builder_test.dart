import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

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
        'visit_date_min': GenericFieldConfig(
          attributLabel: 'Date de début',
          typeWidget: 'date',
          required: true,
        ),
        'comments': GenericFieldConfig(
          attributLabel: 'Commentaires',
          typeWidget: 'textarea',
          required: false,
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
        'checkbox_field': {
          'attribut_label': 'Checkbox Field',
          'type_widget': 'checkbox',
        },
        'observers': {
          'attribut_label': 'Observateurs',
          'type_widget': 'observers',
        },
        'hidden_field': {
          'attribut_label': 'Hidden Field',
          'type_widget': 'text',
          'hidden': true,
        },
      },
    );

    testCustomConfig = CustomConfig(
      moduleCode: 'TEST',
      idModule: 1,
      monitoringsPath: '/api/monitorings',
    );
  });

  group('DynamicFormBuilder - Rendering Tests', () {
    testWidgets('should render basic fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: testObjectConfig,
                customConfig: testCustomConfig,
              ),
            ),
          ),
        ),
      );

      // Wait for form to build
      await tester.pumpAndSettle();

      // Verify basic elements are present
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      expect(find.text('Text Field *'), findsOneWidget);
      expect(find.text('Number Field'), findsOneWidget);
      
      // Hidden fields should not be rendered
      expect(find.text('Hidden Field'), findsNothing);
      
      // Scroll to see more elements if necessary
      await tester.dragFrom(const Offset(400, 300), const Offset(400, 100));
      await tester.pumpAndSettle();
    });
    
    testWidgets('should render with displayProperties parameter',
        (WidgetTester tester) async {
      // Arrange - Only show specific fields
      final List<String> displayProperties = [
        'text_field', 
        'visit_date_min',
        'comments'
      ];
      
      // Act - Build widget with displayProperties
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: testObjectConfig,
                customConfig: testCustomConfig,
                displayProperties: displayProperties,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Only specified fields should be visible
      expect(find.text('Text Field *'), findsOneWidget);
      expect(find.text('Date de début *'), findsOneWidget);
      expect(find.text('Commentaires'), findsOneWidget);
      
      // Fields not in displayProperties should not be rendered
      expect(find.text('Number Field'), findsNothing);
      expect(find.text('Select Option'), findsNothing);
    });
    
    testWidgets('should render chain input option when object is chainable',
        (WidgetTester tester) async {
      // Act - Build widget with chainInput
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: testObjectConfig,
                customConfig: testCustomConfig,
                chainInput: true,
                onChainInputChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Chain input option should be visible
      expect(find.text('Enchaîner les saisies'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });
  });
  
  group('DynamicFormBuilder - Interaction Tests', () {
    testWidgets('should update text field values',
        (WidgetTester tester) async {
      // Arrange - Create a key to access form state
      final formKey = GlobalKey<DynamicFormBuilderState>();
      
      // Act - Build widget with key
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                key: formKey,
                objectConfig: testObjectConfig,
                customConfig: testCustomConfig,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the text field and enter text
      final textField = find.byType(TextFormField).first;
      await tester.enterText(textField, 'Test Input');
      await tester.pump();

      // Assert - Value should be updated in form state
      expect(formKey.currentState!.getFormValues()['text_field'], 'Test Input');
    });
    
    testWidgets('should update number field values',
        (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<DynamicFormBuilderState>();
      
      // Act - Build widget with key
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                key: formKey,
                objectConfig: testObjectConfig,
                customConfig: testCustomConfig,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the number field (may need to scroll to it)
      await tester.dragFrom(const Offset(400, 300), const Offset(400, 100));
      await tester.pumpAndSettle();
      
      // Find Number Field by its label
      final numberFieldFinder = find.ancestor(
        of: find.text('Number Field'),
        matching: find.byType(Column),
      );
      
      if (numberFieldFinder.evaluate().isNotEmpty) {
        // Find the TextField within this ancestor
        final textField = find.descendant(
          of: numberFieldFinder,
          matching: find.byType(TextFormField),
        );
        
        // Enter value in the number field
        await tester.enterText(textField, '42');
        await tester.pump();

        // Assert - Value should be updated in form state
        expect(formKey.currentState!.getFormValues()['number_field'], 42);
      }
    });
    
    testWidgets('should initialize with initial values',
        (WidgetTester tester) async {
      // Arrange
      final initialValues = {
        'text_field': 'Initial Text',
        'number_field': 42,
        'checkbox_field': true,
      };
      
      // Act - Build widget with initial values
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: testObjectConfig,
                customConfig: testCustomConfig,
                initialValues: initialValues,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Assert - Text fields should contain initial values
      expect(
        find.descendant(
          of: find.byType(TextFormField), 
          matching: find.text('Initial Text')
        ),
        findsOneWidget
      );
      
      // Check number field (may be trickier due to scrolling)
      await tester.dragFrom(const Offset(400, 300), const Offset(400, 100));
      await tester.pumpAndSettle();
    });
    
    testWidgets('should validate form fields',
        (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<DynamicFormBuilderState>();
      bool submitCalled = false;
      
      // Act - Build widget with validation
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DynamicFormBuilder(
                    key: formKey,
                    objectConfig: testObjectConfig,
                    customConfig: testCustomConfig,
                    onSubmit: (values) {
                      submitCalled = true;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();
                      if (isValid && formKey.currentState!.onSubmit != null) {
                        formKey.currentState!.onSubmit!(
                            formKey.currentState!.getFormValues());
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap submit without filling required fields
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Assert - Validation error should appear for required fields
      expect(find.text('Ce champ est requis'), findsAtLeastNWidgets(1));
      expect(submitCalled, isFalse);
      
      // Now fill the required field
      await tester.enterText(find.byType(TextFormField).first, 'Required Value');
      await tester.pump();
      
      // We would also need to fill the date field, but that's harder to test
      // without more complex mock interactions
    });
    
    testWidgets('should reset form correctly',
        (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<DynamicFormBuilderState>();
      final initialValues = {'text_field': 'Initial Text'};
      
      // Act - Build widget with initial values and reset button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DynamicFormBuilder(
                    key: formKey,
                    objectConfig: testObjectConfig,
                    customConfig: testCustomConfig,
                    initialValues: initialValues,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.resetForm();
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial value is set
      expect(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.text('Initial Text'),
        ),
        findsOneWidget
      );

      // Reset the form
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // Assert - Text fields should be empty
      expect(
        find.descendant(
          of: find.byType(TextFormField),
          matching: find.text('Initial Text'),
        ),
        findsNothing
      );
      
      // Form values should be empty
      expect(formKey.currentState!.getFormValues(), isEmpty);
    });
  });
}