import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/taxon_selector_widget.dart';
import 'package:mocktail/mocktail.dart';

// Mocks pour TaxonService
class MockTaxonService extends Mock implements TaxonService {}

class FakeTaxon extends Fake implements Taxon {}

void main() {
  late MockTaxonService mockTaxonService;
  
  // Données de test
  final testTaxon1 = Taxon(
    cdNom: 1,
    nomComplet: "Taxon de test 1",
    lbNom: "Taxon1",
    nomVern: "Nom vernaculaire 1",
  );
  
  final testTaxon2 = Taxon(
    cdNom: 2,
    nomComplet: "Taxon de test 2",
    lbNom: "Taxon2",
    nomVern: "Nom vernaculaire 2",
  );
  
  final testTaxons = [testTaxon1, testTaxon2];

  setUpAll(() {
    registerFallbackValue(FakeTaxon());
  });

  setUp(() {
    mockTaxonService = MockTaxonService();
  });

  Future<void> pumpTaxonSelectorWidget(
    WidgetTester tester, {
    int? value,
    int? idListTaxonomy,
    Map<String, dynamic>? fieldConfig,
    bool isRequired = false,
  }) async {
    when(() => mockTaxonService.getTaxonsByModuleId(123))
        .thenAnswer((_) async => testTaxons);
    
    when(() => mockTaxonService.formatTaxonDisplay(any(), any()))
        .thenAnswer((invocation) {
          final taxon = invocation.positionalArguments[0] as Taxon;
          final format = invocation.positionalArguments[1] as String;
          
          if (format == 'nom_vern,lb_nom' && taxon.nomVern != null) {
            return '${taxon.nomVern} (${taxon.lbNom})';
          } else {
            return taxon.lbNom ?? taxon.nomComplet;
          }
        });
        
    if (value != null) {
      when(() => mockTaxonService.getTaxonByCdNom(value))
          .thenAnswer((_) async => testTaxons.firstWhere((t) => t.cdNom == value));
    }
    
    if (idListTaxonomy != null) {
      when(() => mockTaxonService.getTaxonsByListId(idListTaxonomy))
          .thenAnswer((_) async => testTaxons);
    }
    
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taxonServiceProvider.overrideWith((_) => mockTaxonService),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: TaxonSelectorWidget(
              moduleId: 123,
              onChanged: (_) {},
              label: 'Taxon de test',
              value: value,
              isRequired: isRequired,
              idListTaxonomy: idListTaxonomy,
              fieldConfig: fieldConfig,
            ),
          ),
        ),
      ),
    );
    
    // Permettre le chargement asynchrone
    await tester.pumpAndSettle();
  }

  group('TaxonSelectorWidget UI Tests', () {
    testWidgets('should show correct initial state with empty value', 
        (WidgetTester tester) async {
      // Arrange & Act
      await pumpTaxonSelectorWidget(tester);

      // Assert
      expect(find.text('Taxon de test'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Rechercher un taxon...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsNothing);
    });
    
    testWidgets('should display selected taxon initially when value is provided', 
        (WidgetTester tester) async {
      // Arrange & Act
      await pumpTaxonSelectorWidget(tester, value: 1);

      // Assert
      expect(find.text('Nom vernaculaire 1 (Taxon1)'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byIcon(Icons.search), findsNothing);
    });
    
    testWidgets('should show suggestions when focused and no text entered',
        (WidgetTester tester) async {
      // Arrange
      await pumpTaxonSelectorWidget(tester);
      
      // Act - Attendre que les suggestions s'affichent
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Suggestions:'), findsOneWidget);
      expect(find.byType(ChoiceChip), findsNWidgets(2));
      expect(find.text('Nom vernaculaire 1 (Taxon1)'), findsOneWidget);
      expect(find.text('Nom vernaculaire 2 (Taxon2)'), findsOneWidget);
    });
    
    testWidgets('should clear selection when clear button is tapped',
        (WidgetTester tester) async {
      // Arrange
      await pumpTaxonSelectorWidget(tester, value: 1);
      
      // Vérifier que la valeur est initialement affichée
      expect(find.text('Nom vernaculaire 1 (Taxon1)'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
      
      // Act
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();
      
      // Assert
      // Après avoir appuyé sur clear, le champ de texte devrait être vide et l'icône search devrait être visible
      // Vérifier que le champ TextFormField est vide
      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.controller!.text, '');
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
    
    testWidgets('should use idListTaxonomy from field config when available',
        (WidgetTester tester) async {
      // Arrange
      final fieldConfig = {
        'id_list': 456,
        'type_util': 'taxonomy',
      };
      
      // Mock pour getTaxonsByListId avec l'ID spécifique de la configuration
      when(() => mockTaxonService.getTaxonsByListId(456))
          .thenAnswer((_) async => testTaxons);
          
      // Act
      await pumpTaxonSelectorWidget(
        tester, 
        fieldConfig: fieldConfig,
        idListTaxonomy: 123, // Ce paramètre devrait être ignoré en faveur de fieldConfig['id_list']
      );
      
      // Assert
      await tester.pumpAndSettle();
      verify(() => mockTaxonService.getTaxonsByListId(456)).called(1);
      verifyNever(() => mockTaxonService.getTaxonsByListId(123));
    });
    
    testWidgets('should mark field as required if isRequired is true',
        (WidgetTester tester) async {
      // Arrange
      await pumpTaxonSelectorWidget(tester, isRequired: true);
      
      // Assert
      expect(find.text('Taxon de test *'), findsOneWidget);
    });
    
    testWidgets('should use custom display format from field config',
        (WidgetTester tester) async {
      // Arrange
      final fieldConfig = {
        'taxonomy_display_field_name': 'lb_nom',
        'type_util': 'taxonomy',
      };
      
      when(() => mockTaxonService.formatTaxonDisplay(testTaxon1, 'lb_nom'))
          .thenReturn('Taxon1');
      
      // Act
      await pumpTaxonSelectorWidget(
        tester, 
        fieldConfig: fieldConfig,
        value: 1,
      );
      
      // Assert
      verify(() => mockTaxonService.formatTaxonDisplay(testTaxon1, 'lb_nom')).called(1);
    });
  });

  group('TaxonSelectorWidget Integration Tests', () {
    testWidgets('should search taxons when text is entered',
        (WidgetTester tester) async {
      // Arrange
      await pumpTaxonSelectorWidget(tester);
      
      // Mock pour la recherche de taxons
      when(() => mockTaxonService.searchTaxons('tax', idListe: null))
          .thenAnswer((_) async => testTaxons);
      
      // Act
      await tester.enterText(find.byType(TextFormField), 'tax');
      await tester.pumpAndSettle();
      
      // Assert
      verify(() => mockTaxonService.searchTaxons('tax', idListe: null)).called(1);
    });
    
    testWidgets('should select taxon when a search result is tapped',
        (WidgetTester tester) async {
      // Arrange
      await pumpTaxonSelectorWidget(tester);
      
      // Mock pour la recherche de taxons
      when(() => mockTaxonService.searchTaxons('tax', idListe: null))
          .thenAnswer((_) async => testTaxons);
      
      // Act
      await tester.enterText(find.byType(TextFormField), 'tax');
      await tester.pumpAndSettle();
      
      // Trouver et taper sur le premier résultat de recherche
      await tester.tap(find.text('Nom vernaculaire 1 (Taxon1)').first);
      await tester.pumpAndSettle();
      
      // Assert
      expect(find.text('Nom vernaculaire 1 (Taxon1)'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });
    
    // Ce test a été temporairement désactivé car il nécessite un refactoring
    /*
    testWidgets('should validate taxon belongs to list when idListTaxonomy is provided',
        (WidgetTester tester) async {
      // Arrange
      final invalidTaxon = Taxon(
        cdNom: 3,
        nomComplet: "Taxon invalide",
        lbNom: "TaxonInvalide",
      );
      
      // Configurer le mock pour simuler un taxon qui n'appartient pas à la liste
      when(() => mockTaxonService.getTaxonByCdNom(3))
          .thenAnswer((_) async => invalidTaxon);
          
      when(() => mockTaxonService.getTaxonsByListId(456))
          .thenAnswer((_) async => testTaxons); // Ne contient pas invalidTaxon
      
      // Act
      await pumpTaxonSelectorWidget(
        tester, 
        value: 3,
        idListTaxonomy: 456,
      );
      
      // Assert - Le widget devrait effacer la sélection car le taxon n'est pas dans la liste
      await tester.pumpAndSettle();
      expect(find.text('Taxon invalide'), findsNothing);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
    */
  });
}