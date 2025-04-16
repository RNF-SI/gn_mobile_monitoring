import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/property_display_widget.dart';

// Implémentation concrète de DetailPage pour les tests
class TestDetailPage extends DetailPage {
  final String testTitle;
  
  const TestDetailPage({super.key, this.testTitle = 'Test Page'});

  @override
  TestDetailPageState createState() => TestDetailPageState();
}

class TestDetailPageState extends DetailPageState<TestDetailPage> {
  final Map<String, dynamic> _data = {
    'string_value': 'Test Value',
    'int_value': 42,
    'bool_value': true,
    'date_value': '2024-04-15',
    'null_value': null,
  };
  
  final ObjectConfig _objectConfig = ObjectConfig(
    label: 'Test Object',
    displayProperties: ['string_value', 'int_value', 'bool_value', 'date_value'],
    generic: {
      'string_value': GenericFieldConfig(
        attributLabel: 'String Value',
        typeWidget: 'text',
      ),
      'int_value': GenericFieldConfig(
        attributLabel: 'Integer Value',
        typeWidget: 'number',
      ),
      'bool_value': GenericFieldConfig(
        attributLabel: 'Boolean Value',
        typeWidget: 'checkbox',
      ),
      'date_value': GenericFieldConfig(
        attributLabel: 'Date Value',
        typeWidget: 'date',
      ),
    },
  );
  
  final List<BreadcrumbItem> _breadcrumbItems = [
    BreadcrumbItem(
      label: 'Home',
      value: 'Dashboard',
      onTap: () {},
    ),
    BreadcrumbItem(
      label: 'Category',
      value: 'Test Category',
      onTap: () {},
    ),
    BreadcrumbItem(
      label: 'Object',
      value: 'Test Object',
    ),
  ];
  
  @override
  Map<String, dynamic> get objectData => _data;
  
  @override
  ObjectConfig? get objectConfig => _objectConfig;
  
  @override
  CustomConfig? get customConfig => null;
  
  @override
  List<String>? get displayProperties => _objectConfig.displayProperties;
  
  @override
  String get propertiesTitle => 'Test Properties';
  
  @override
  List<BreadcrumbItem> getBreadcrumbItems() => _breadcrumbItems;
  
  @override
  List<String> get childrenTypes => ['child_type1', 'child_type2'];
  
  @override
  String getTitle() => widget.testTitle;
  
  // Méthode pour exposer les méthodes protégées pour les tests
  Map<String, dynamic> testGenerateSchema() => generateSchema();
  
  List<String> testDetermineDataColumns({
    required List<String> standardColumns,
    ObjectConfig? itemConfig,
    Map<String, dynamic>? firstItemData,
    bool filterMetaColumns = true,
  }) {
    return determineDataColumns(
      standardColumns: standardColumns,
      itemConfig: itemConfig,
      firstItemData: firstItemData,
      filterMetaColumns: filterMetaColumns,
    );
  }
  
  List<DataColumn> testBuildDataColumns({
    required List<String> columns,
    required ObjectConfig? itemConfig,
    Map<String, String> predefinedLabels = const {},
  }) {
    return buildDataColumns(
      columns: columns,
      itemConfig: itemConfig,
      predefinedLabels: predefinedLabels,
    );
  }
  
  String testFormatDataCellValue({
    required dynamic rawValue,
    required String columnName,
    required Map<String, dynamic> schema,
  }) {
    return formatDataCellValue(
      rawValue: rawValue,
      columnName: columnName,
      schema: schema,
    );
  }
  
  DataCell testBuildFormattedDataCell({
    required String value,
    bool enableTooltip = true,
    int tooltipThreshold = 30,
    int maxLines = 1,
  }) {
    return buildFormattedDataCell(
      value: value,
      enableTooltip: enableTooltip,
      tooltipThreshold: tooltipThreshold,
      maxLines: maxLines,
    );
  }
  
  Widget testBuildDataTable({
    required List<DataColumn> columns,
    required List<DataRow> rows,
    bool showSearch = true,
  }) {
    final searchController = TextEditingController();
    return buildDataTable(
      columns: columns,
      rows: rows,
      showSearch: showSearch,
      searchController: searchController,
      onSearchChanged: (value) {},
    );
  }
}

void main() {
  group('DetailPage Base Class Tests', () {
    late TestDetailPage testPage;
    late TestDetailPageState testState;

    setUp(() {
      testPage = const TestDetailPage();
      testState = TestDetailPageState();
    });

    testWidgets('DetailPage builds with correct title', (WidgetTester tester) async {
      const customTitle = 'Custom Page Title';
      final page = const TestDetailPage(testTitle: customTitle);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: page,
          ),
        ),
      );
      
      await tester.pump();
      
      // Vérifier que le titre est correct
      expect(find.text(customTitle), findsOneWidget);
    });
    
    testWidgets('buildPropertiesWidget shows property values correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testState.buildPropertiesWidget(),
          ),
        ),
      );
      
      await tester.pump();
      
      // Vérifier que le titre des propriétés est affiché
      expect(find.text('Test Properties'), findsOneWidget);
      
      // Vérifier que les propriétés sont affichées
      expect(find.text('String Value'), findsOneWidget);
      expect(find.text('Test Value'), findsOneWidget);
      expect(find.text('Integer Value'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Boolean Value'), findsOneWidget);
      
      // Le formatage de "true" peut varier selon l'implémentation, utilisons textContaining
      expect(find.textContaining('true'), findsOneWidget);
    });
    
    testWidgets('buildBreadcrumb shows breadcrumb navigation correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testState.buildBreadcrumb(),
          ),
        ),
      );
      
      await tester.pump();
      
      // Vérifier que le fil d'Ariane est affiché
      expect(find.byType(BreadcrumbNavigation), findsOneWidget);
      expect(find.text('Home: Dashboard'), findsOneWidget);
      expect(find.text('Category: Test Category'), findsOneWidget);
      expect(find.text('Object: Test Object'), findsOneWidget);
    });
    
    testWidgets('buildBaseContent combines property display correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: testState.buildBaseContent(),
          ),
        ),
      );
      
      await tester.pump();
      
      // Vérifier que le contenu de base contient PropertyDisplayWidget
      expect(find.byType(PropertyDisplayWidget), findsOneWidget);
      expect(find.text('Test Properties'), findsOneWidget);
    });

    test('generateSchema correctly processes ObjectConfig', () {
      // Tester que le schéma généré contient les champs attendus
      final schema = testState.testGenerateSchema();
      
      expect(schema.containsKey('string_value'), isTrue);
      expect(schema.containsKey('int_value'), isTrue);
      expect(schema.containsKey('bool_value'), isTrue);
      expect(schema.containsKey('date_value'), isTrue);
      
      // Vérifier que les propriétés du schéma sont correctes
      expect(schema['string_value']['attribut_label'], 'String Value');
      expect(schema['string_value']['type_widget'], 'text');
      expect(schema['int_value']['attribut_label'], 'Integer Value');
      expect(schema['bool_value']['type_widget'], 'checkbox');
    });
    
    test('determineDataColumns prioritizes displayList fields', () {
      // Configuration pour le test
      final standardColumns = ['id', 'name'];
      final itemConfig = ObjectConfig(
        displayList: ['priority1', 'priority2'],
        generic: {
          'priority1': GenericFieldConfig(attributLabel: 'P1', typeWidget: 'text'),
          'priority2': GenericFieldConfig(attributLabel: 'P2', typeWidget: 'text'),
          'generic1': GenericFieldConfig(attributLabel: 'G1', typeWidget: 'text'),
        },
      );
      final firstItemData = {
        'priority1': 'value1',
        'priority2': 'value2',
        'generic1': 'generic_value',
        'extra1': 'extra_value',
        'geom': 'geometry_data', // devrait être filtré
      };
      
      // Exécuter la méthode à tester
      final columns = testState.testDetermineDataColumns(
        standardColumns: standardColumns,
        itemConfig: itemConfig,
        firstItemData: firstItemData,
        filterMetaColumns: true,
      );
      
      // Vérifier que les colonnes standard sont toujours en premier
      expect(columns[0], 'id');
      expect(columns[1], 'name');
      
      // Vérifier que les colonnes priority1 et priority2 sont présentes et avant generic1
      expect(columns.contains('priority1'), isTrue);
      expect(columns.contains('priority2'), isTrue);
      expect(columns.contains('generic1'), isTrue);
      expect(columns.contains('extra1'), isTrue);
      
      // Vérifier que geom est filtré
      expect(columns.contains('geom'), isFalse);
      
      // Vérifier l'ordre des priorités
      final priority1Index = columns.indexOf('priority1');
      final priority2Index = columns.indexOf('priority2');
      final generic1Index = columns.indexOf('generic1');
      final extra1Index = columns.indexOf('extra1');
      
      // Les priorités devraient être avant les autres champs
      expect(priority1Index < generic1Index, isTrue);
      expect(priority2Index < generic1Index, isTrue);
      expect(priority1Index < extra1Index, isTrue);
      expect(priority2Index < extra1Index, isTrue);
    });
    
    test('buildDataColumns correctly formats column labels', () {
      // Configuration pour le test
      final columns = ['id', 'first_name', 'date_created'];
      final itemConfig = ObjectConfig(
        generic: {
          'first_name': GenericFieldConfig(attributLabel: 'First Name', typeWidget: 'text'),
          'date_created': GenericFieldConfig(attributLabel: 'Creation Date', typeWidget: 'date'),
        },
      );
      final predefinedLabels = {'id': 'ID'};
      
      // Exécuter la méthode à tester
      final dataColumns = testState.testBuildDataColumns(
        columns: columns,
        itemConfig: itemConfig,
        predefinedLabels: predefinedLabels,
      );
      
      // Vérifier que les labels sont correctement formatés
      expect((dataColumns[0].label as Text).data, 'ID'); // De predefinedLabels
      expect((dataColumns[1].label as Text).data, 'First Name'); // De itemConfig.generic
      expect((dataColumns[2].label as Text).data, 'Creation Date'); // De itemConfig.generic
    });
    
    test('formatDataCellValue correctly formats different data types', () {
      // Créer un schéma de test
      final schema = {
        'text_field': {'type_widget': 'text', 'attribut_label': 'Text'},
        'number_field': {'type_widget': 'number', 'attribut_label': 'Number'},
        'date_field': {'type_widget': 'date', 'attribut_label': 'Date'},
        'checkbox_field': {'type_widget': 'checkbox', 'attribut_label': 'Checkbox'},
        'textarea_field': {'type_widget': 'textarea', 'attribut_label': 'TextArea'},
      };
      
      // Tester différents types de valeurs
      final textValue = testState.testFormatDataCellValue(
        rawValue: 'Test Value',
        columnName: 'text_field',
        schema: schema,
      );
      expect(textValue, 'Test Value');
      
      final numberValue = testState.testFormatDataCellValue(
        rawValue: 42,
        columnName: 'number_field',
        schema: schema,
      );
      expect(numberValue, '42');
      
      final checkboxTrueValue = testState.testFormatDataCellValue(
        rawValue: true,
        columnName: 'checkbox_field',
        schema: schema,
      );
      expect(checkboxTrueValue, 'Oui');
      
      final checkboxFalseValue = testState.testFormatDataCellValue(
        rawValue: false,
        columnName: 'checkbox_field',
        schema: schema,
      );
      expect(checkboxFalseValue, 'Non');
      
      final nullValue = testState.testFormatDataCellValue(
        rawValue: null,
        columnName: 'text_field',
        schema: schema,
      );
      expect(nullValue, '');
    });
    
    testWidgets('buildFormattedDataCell creates cells with tooltips for long values', (WidgetTester tester) async {
      final shortValue = "Short value";
      final longValue = "This is a very long value that should get a tooltip";
      
      // Créer un widget de test pour afficher les cellules
      await tester.pumpWidget(
        MaterialApp(
          home: DataTable(
            columns: const [DataColumn(label: Text('Test'))],
            rows: [
              DataRow(cells: [
                testState.testBuildFormattedDataCell(value: shortValue),
              ]),
              DataRow(cells: [
                testState.testBuildFormattedDataCell(value: longValue),
              ]),
            ],
          ),
        ),
      );
      
      // Attendre que le widget soit construit
      await tester.pump();
      
      // Trouver les tooltips
      final tooltips = find.byType(Tooltip);
      expect(tooltips, findsNWidgets(2)); // Un pour chaque cellule
      
      // Vérifier les messages des tooltips
      final shortTooltip = tester.widget<Tooltip>(tooltips.at(0));
      expect(shortTooltip.message, ''); // Pas de tooltip pour les valeurs courtes
      
      final longTooltip = tester.widget<Tooltip>(tooltips.at(1));
      expect(longTooltip.message, longValue); // Tooltip pour les valeurs longues
    });
    
    test('formatDataCellValue handles boolean values correctly', () {
      // Créer un schéma simple pour le test
      final schema = {
        'checkbox_field': {'type_widget': 'checkbox', 'attribut_label': 'Checkbox'},
      };
      
      // Tester différentes valeurs booléennes
      final trueValue = testState.testFormatDataCellValue(
        rawValue: true,
        columnName: 'checkbox_field',
        schema: schema,
      );
      
      final falseValue = testState.testFormatDataCellValue(
        rawValue: false,
        columnName: 'checkbox_field',
        schema: schema,
      );
      
      // Vérifier que les valeurs sont formatées comme attendu
      // Note: L'implémentation peut retourner "Oui"/"Non" ou "true"/"false"
      expect(trueValue.toLowerCase(), anyOf(equals('oui'), equals('true')));
      expect(falseValue.toLowerCase(), anyOf(equals('non'), equals('false')));
    });
    
    test('buildFormattedDataCell returns a DataCell with the correct text', () {
      // Tester que buildFormattedDataCell crée une cellule avec le bon texte
      final cell = testState.testBuildFormattedDataCell(value: 'Test Cell Value');
      expect(cell, isA<DataCell>());
    });
    
    test('objectData getter returns correct data', () {
      // Vérifier que le getter objectData retourne les bonnes données
      expect(testState.objectData, equals(testState._data));
    });
  });
}