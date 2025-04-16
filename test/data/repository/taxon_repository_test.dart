import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/repository/taxon_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:mocktail/mocktail.dart';

// Mock des dépendances
class MockTaxonDatabase extends Mock implements TaxonDatabase {}
class MockTaxonApi extends Mock implements TaxonApi {}
class MockModulesDatabase extends Mock implements ModulesDatabase {}

void main() {
  late TaxonRepository repository;
  late MockTaxonDatabase mockTaxonDatabase;
  late MockTaxonApi mockTaxonApi;
  late MockModulesDatabase mockModulesDatabase;

  // Données de test
  final testTaxon1 = Taxon(cdNom: 1, nomComplet: "Taxon 1", lbNom: "Taxon1", nomVern: "Taxon commun 1");
  final testTaxon2 = Taxon(cdNom: 2, nomComplet: "Taxon 2", lbNom: "Taxon2", nomVern: "Taxon commun 2");
  final testTaxons = [testTaxon1, testTaxon2];
  
  final testTaxonList = TaxonList(
    idListe: 1,
    nomListe: "Liste de test",
    codeListe: "TEST",
  );
  final testTaxonLists = [testTaxonList];

  final testModuleComplement = ModuleComplement(
    idModule: 1,
    idListTaxonomy: 1,
  );

  final testModuleComplementWithoutTaxonomy = ModuleComplement(
    idModule: 2,
  );

  // Configuration de test pour downloadTaxonsFromConfig
  final testConfig = {
    "form": {
      "fields": [
        {
          "name": "taxon_field",
          "type_util": "taxonomy",
          "id_list": 1
        },
        {
          "name": "other_field",
          "type_util": "text"
        },
        {
          "name": "nested_fields",
          "items": [
            {
              "name": "nested_taxon",
              "type_util": "taxonomy",
              "id_list": "2" // Test avec une chaîne pour vérifier la conversion
            }
          ]
        }
      ]
    }
  };

  setUp(() {
    mockTaxonDatabase = MockTaxonDatabase();
    mockTaxonApi = MockTaxonApi();
    mockModulesDatabase = MockModulesDatabase();
    repository = TaxonRepositoryImpl(mockTaxonDatabase, mockTaxonApi, mockModulesDatabase);

    // Register fallback values if needed
    registerFallbackValue(testTaxon1);
    registerFallbackValue(testTaxonList);
  });

  group('TaxonRepository - Taxon Operations', () {
    test('getAllTaxons should return all taxons from database', () async {
      // Arrange
      when(() => mockTaxonDatabase.getAllTaxons())
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await repository.getAllTaxons();

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockTaxonDatabase.getAllTaxons()).called(1);
    });

    test('getTaxonsByListId should return taxons filtered by list ID', () async {
      // Arrange
      when(() => mockTaxonDatabase.getTaxonsByListId(1))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await repository.getTaxonsByListId(1);

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockTaxonDatabase.getTaxonsByListId(1)).called(1);
    });

    test('getTaxonByCdNom should return a specific taxon by cdNom', () async {
      // Arrange
      when(() => mockTaxonDatabase.getTaxonByCdNom(1))
          .thenAnswer((_) async => testTaxon1);

      // Act
      final result = await repository.getTaxonByCdNom(1);

      // Assert
      expect(result, equals(testTaxon1));
      verify(() => mockTaxonDatabase.getTaxonByCdNom(1)).called(1);
    });

    test('searchTaxons should return taxons matching the search term', () async {
      // Arrange
      when(() => mockTaxonDatabase.searchTaxons("Taxon"))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await repository.searchTaxons("Taxon");

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockTaxonDatabase.searchTaxons("Taxon")).called(1);
    });

    test('searchTaxonsByListId should return taxons matching the search term and list ID', () async {
      // Arrange
      when(() => mockTaxonDatabase.searchTaxonsByListId("Taxon", 1))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await repository.searchTaxonsByListId("Taxon", 1);

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockTaxonDatabase.searchTaxonsByListId("Taxon", 1)).called(1);
    });

    test('saveTaxons should save the provided taxons', () async {
      // Arrange
      when(() => mockTaxonDatabase.saveTaxons(testTaxons))
          .thenAnswer((_) async => {});

      // Act
      await repository.saveTaxons(testTaxons);

      // Assert
      verify(() => mockTaxonDatabase.saveTaxons(testTaxons)).called(1);
    });

    test('clearTaxons should clear all taxons', () async {
      // Arrange
      when(() => mockTaxonDatabase.clearTaxons())
          .thenAnswer((_) async => {});

      // Act
      await repository.clearTaxons();

      // Assert
      verify(() => mockTaxonDatabase.clearTaxons()).called(1);
    });
  });

  group('TaxonRepository - TaxonList Operations', () {
    test('getAllTaxonLists should return all taxon lists', () async {
      // Arrange
      when(() => mockTaxonDatabase.getAllTaxonLists())
          .thenAnswer((_) async => testTaxonLists);

      // Act
      final result = await repository.getAllTaxonLists();

      // Assert
      expect(result, equals(testTaxonLists));
      verify(() => mockTaxonDatabase.getAllTaxonLists()).called(1);
    });

    test('getTaxonListById should return a specific taxon list', () async {
      // Arrange
      when(() => mockTaxonDatabase.getTaxonListById(1))
          .thenAnswer((_) async => testTaxonList);

      // Act
      final result = await repository.getTaxonListById(1);

      // Assert
      expect(result, equals(testTaxonList));
      verify(() => mockTaxonDatabase.getTaxonListById(1)).called(1);
    });

    test('saveTaxonLists should save the provided taxon lists', () async {
      // Arrange
      when(() => mockTaxonDatabase.saveTaxonLists(testTaxonLists))
          .thenAnswer((_) async => {});

      // Act
      await repository.saveTaxonLists(testTaxonLists);

      // Assert
      verify(() => mockTaxonDatabase.saveTaxonLists(testTaxonLists)).called(1);
    });

    test('clearTaxonLists should clear all taxon lists', () async {
      // Arrange
      when(() => mockTaxonDatabase.clearTaxonLists())
          .thenAnswer((_) async => {});

      // Act
      await repository.clearTaxonLists();

      // Assert
      verify(() => mockTaxonDatabase.clearTaxonLists()).called(1);
    });
  });

  group('TaxonRepository - Relations Operations', () {
    test('saveTaxonsToList should associate taxons with a list', () async {
      // Arrange
      final cdNoms = [1, 2];
      when(() => mockTaxonDatabase.saveTaxonsToList(1, cdNoms))
          .thenAnswer((_) async => {});

      // Act
      await repository.saveTaxonsToList(1, cdNoms);

      // Assert
      verify(() => mockTaxonDatabase.saveTaxonsToList(1, cdNoms)).called(1);
    });

    test('clearCorTaxonListe should clear all taxon-list associations', () async {
      // Arrange
      when(() => mockTaxonDatabase.clearCorTaxonListe())
          .thenAnswer((_) async => {});

      // Act
      await repository.clearCorTaxonListe();

      // Assert
      verify(() => mockTaxonDatabase.clearCorTaxonListe()).called(1);
    });
  });

  group('TaxonRepository - Module-specific Operations', () {
    test('getTaxonsByModuleId should return taxons for module with taxonomy list', () async {
      // Arrange
      when(() => mockModulesDatabase.getModuleComplementById(1))
          .thenAnswer((_) async => testModuleComplement);
      when(() => mockTaxonDatabase.getTaxonsByListId(1))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await repository.getTaxonsByModuleId(1);

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockModulesDatabase.getModuleComplementById(1)).called(1);
      verify(() => mockTaxonDatabase.getTaxonsByListId(1)).called(1);
    });

    test('getTaxonsByModuleId should return empty list when module has no taxonomy list', () async {
      // Arrange
      when(() => mockModulesDatabase.getModuleComplementById(2))
          .thenAnswer((_) async => testModuleComplementWithoutTaxonomy);

      // Act
      final result = await repository.getTaxonsByModuleId(2);

      // Assert
      expect(result, isEmpty);
      verify(() => mockModulesDatabase.getModuleComplementById(2)).called(1);
      verifyNever(() => mockTaxonDatabase.getTaxonsByListId(any()));
    });

    test('downloadModuleTaxons should download and save taxons for a module', () async {
      // Arrange
      when(() => mockModulesDatabase.getModuleComplementById(1))
          .thenAnswer((_) async => testModuleComplement);
      when(() => mockTaxonApi.getTaxonList(1))
          .thenAnswer((_) async => testTaxonList);
      when(() => mockTaxonApi.getTaxonsByList(1))
          .thenAnswer((_) async => testTaxons);
      when(() => mockTaxonDatabase.saveTaxonLists([testTaxonList]))
          .thenAnswer((_) async => {});
      when(() => mockTaxonDatabase.saveTaxon(any()))
          .thenAnswer((_) async => {});
      when(() => mockTaxonDatabase.saveTaxonsToList(1, [1, 2]))
          .thenAnswer((_) async => {});

      // Act
      await repository.downloadModuleTaxons(1);

      // Assert
      verify(() => mockModulesDatabase.getModuleComplementById(1)).called(1);
      verify(() => mockTaxonApi.getTaxonList(1)).called(1);
      verify(() => mockTaxonApi.getTaxonsByList(1)).called(1);
      verify(() => mockTaxonDatabase.saveTaxonLists([testTaxonList])).called(1);
      verify(() => mockTaxonDatabase.saveTaxon(testTaxon1)).called(1);
      verify(() => mockTaxonDatabase.saveTaxon(testTaxon2)).called(1);
      verify(() => mockTaxonDatabase.saveTaxonsToList(1, [1, 2])).called(1);
    });

    test('downloadModuleTaxons should handle modules without taxonomy list', () async {
      // Arrange
      when(() => mockModulesDatabase.getModuleComplementById(2))
          .thenAnswer((_) async => testModuleComplementWithoutTaxonomy);

      // Act
      await repository.downloadModuleTaxons(2);

      // Assert
      verify(() => mockModulesDatabase.getModuleComplementById(2)).called(1);
      verifyNever(() => mockTaxonApi.getTaxonList(any()));
      verifyNever(() => mockTaxonApi.getTaxonsByList(any()));
      verifyNever(() => mockTaxonDatabase.saveTaxonLists(any()));
      verifyNever(() => mockTaxonDatabase.saveTaxon(any()));
      verifyNever(() => mockTaxonDatabase.saveTaxonsToList(any(), any()));
    });
  });

  group('TaxonRepository - Configuration Operations', () {
    test('downloadTaxonsFromConfig should extract and download taxonomy lists', () async {
      // Arrange
      when(() => mockTaxonApi.getTaxonList(1))
          .thenAnswer((_) async => testTaxonList);
      when(() => mockTaxonApi.getTaxonsByList(1))
          .thenAnswer((_) async => testTaxons);
      when(() => mockTaxonDatabase.saveTaxonLists([testTaxonList]))
          .thenAnswer((_) async => {});
      when(() => mockTaxonDatabase.saveTaxon(any()))
          .thenAnswer((_) async => {});
      when(() => mockTaxonDatabase.saveTaxonsToList(1, [1, 2]))
          .thenAnswer((_) async => {});
          
      // For the second taxonomy list with ID 2 (from string)
      final testTaxonList2 = TaxonList(idListe: 2, nomListe: "Liste de test 2");
      when(() => mockTaxonApi.getTaxonList(2))
          .thenAnswer((_) async => testTaxonList2);
      when(() => mockTaxonApi.getTaxonsByList(2))
          .thenAnswer((_) async => testTaxons);
      when(() => mockTaxonDatabase.saveTaxonLists([testTaxonList2]))
          .thenAnswer((_) async => {});
      when(() => mockTaxonDatabase.saveTaxonsToList(2, [1, 2]))
          .thenAnswer((_) async => {});

      // Act
      await repository.downloadTaxonsFromConfig(testConfig);

      // Assert
      verify(() => mockTaxonApi.getTaxonList(1)).called(1);
      verify(() => mockTaxonApi.getTaxonsByList(1)).called(1);
      verify(() => mockTaxonDatabase.saveTaxonLists([testTaxonList])).called(1);
      verify(() => mockTaxonDatabase.saveTaxon(testTaxon1)).called(2); // Called for both lists
      verify(() => mockTaxonDatabase.saveTaxon(testTaxon2)).called(2); // Called for both lists
      verify(() => mockTaxonDatabase.saveTaxonsToList(1, [1, 2])).called(1);
      
      // Verify second list (from string ID)
      verify(() => mockTaxonApi.getTaxonList(2)).called(1);
      verify(() => mockTaxonApi.getTaxonsByList(2)).called(1);
      verify(() => mockTaxonDatabase.saveTaxonLists([testTaxonList2])).called(1);
      verify(() => mockTaxonDatabase.saveTaxonsToList(2, [1, 2])).called(1);
    });

    test('downloadTaxonsFromConfig should handle empty or invalid configuration', () async {
      // Arrange
      final emptyConfig = <String, dynamic>{};

      // Act
      await repository.downloadTaxonsFromConfig(emptyConfig);

      // Assert
      verifyNever(() => mockTaxonApi.getTaxonList(any()));
      verifyNever(() => mockTaxonApi.getTaxonsByList(any()));
      verifyNever(() => mockTaxonDatabase.saveTaxonLists(any()));
      verifyNever(() => mockTaxonDatabase.saveTaxon(any()));
      verifyNever(() => mockTaxonDatabase.saveTaxonsToList(any(), any()));
    });

    test('downloadTaxonsFromConfig should handle API errors gracefully', () async {
      // Arrange
      when(() => mockTaxonApi.getTaxonList(1))
          .thenThrow(Exception('API Error'));

      // Act
      await repository.downloadTaxonsFromConfig(testConfig);

      // Assert
      verify(() => mockTaxonApi.getTaxonList(1)).called(1);
      verifyNever(() => mockTaxonDatabase.saveTaxonLists(any()));
      
      // Should still try the second list even if the first fails
      verify(() => mockTaxonApi.getTaxonList(2)).called(1);
    });
  });

  group('TaxonRepository - Error handling', () {
    test('should handle database errors gracefully', () async {
      // Arrange
      when(() => mockTaxonDatabase.getAllTaxons())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => repository.getAllTaxons(),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle API errors gracefully', () async {
      // Arrange
      when(() => mockModulesDatabase.getModuleComplementById(1))
          .thenAnswer((_) async => testModuleComplement);
      when(() => mockTaxonApi.getTaxonList(1))
          .thenThrow(Exception('API error'));

      // Act & Assert - should not throw but handle internally
      await expectLater(repository.downloadModuleTaxons(1), completes);
      
      verify(() => mockModulesDatabase.getModuleComplementById(1)).called(1);
      verify(() => mockTaxonApi.getTaxonList(1)).called(1);
    });
  });
}