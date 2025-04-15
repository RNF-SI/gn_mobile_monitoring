import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/nomenclatures_database_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/db/dao/bib_nomenclatures_types_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/t_nomenclatures_dao.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:mocktail/mocktail.dart';

// Mocks pour les dépendances
class MockAppDatabase extends Mock implements AppDatabase {}
class MockTNomenclaturesDao extends Mock implements TNomenclaturesDao {}
class MockBibNomenclaturesTypesDao extends Mock implements BibNomenclaturesTypesDao {}
class MockDB extends Mock implements DB {}

// Classe pour simuler l'entité BibNomenclatureType générée par Drift
// Mock BibNomenclatureType pour l'entité générée par Drift
class MockBibNomenclatureType extends Mock implements BibNomenclatureType {
  @override
  final int idType;
  @override
  final String? mnemonique;
  @override
  final String? labelDefault;
  @override
  final String? definitionDefault;
  @override
  final String? labelFr;
  @override
  final String? definitionFr;
  @override
  final String? labelEn;
  @override
  final String? definitionEn;
  @override
  final String? labelEs;
  @override
  final String? definitionEs;
  @override
  final String? labelDe;
  @override
  final String? definitionDe;
  @override
  final String? labelIt;
  @override
  final String? definitionIt;
  @override
  final String? source;
  @override
  final String? statut;
  @override
  final DateTime? metaCreateDate;
  @override
  final DateTime? metaUpdateDate;

  MockBibNomenclatureType({
    required this.idType,
    this.mnemonique,
    this.labelDefault,
    this.definitionDefault,
    this.labelFr,
    this.definitionFr,
    this.labelEn,
    this.definitionEn,
    this.labelEs,
    this.definitionEs,
    this.labelDe,
    this.definitionDe,
    this.labelIt,
    this.definitionIt,
    this.source,
    this.statut,
    this.metaCreateDate,
    this.metaUpdateDate,
  });
}

void main() {
  setUpAll(() {
    // Enregistrement des valeurs de fallback pour Mocktail
    registerFallbackValue(Nomenclature(
      id: 0,
      idType: 0,
      cdNomenclature: '',
    ));
    registerFallbackValue(NomenclatureType(
      idType: 0,
      mnemonique: '',
    ));
  });
  
  late NomenclaturesDatabase nomenclaturesDatabase;
  late MockAppDatabase mockAppDatabase;
  late MockTNomenclaturesDao mockTNomenclaturesDao;
  late MockBibNomenclaturesTypesDao mockBibNomenclaturesTypesDao;
  late MockDB mockDB;

  // Données de test pour nomenclatures
  final testNomenclature1 = Nomenclature(
    id: 1,
    idType: 100,
    cdNomenclature: 'TEST1',
    labelDefault: 'Test Nomenclature 1',
  );

  final testNomenclature2 = Nomenclature(
    id: 2,
    idType: 100,
    cdNomenclature: 'TEST2',
    labelDefault: 'Test Nomenclature 2',
  );

  final testNomenclatures = [testNomenclature1, testNomenclature2];

  // Données de test pour types de nomenclature
  final testNomenclatureType = NomenclatureType(
    idType: 100,
    mnemonique: 'TEST_TYPE',
    labelDefault: 'Type de test',
  );

  // final testNomenclatureTypes = [testNomenclatureType]; // Variable non utilisée

  // Entités de test pour le mapping avec la base de données
  final testBibNomenclatureType = MockBibNomenclatureType(
    idType: 100,
    mnemonique: 'TEST_TYPE',
    labelDefault: 'Type de test',
    definitionDefault: null,
    labelFr: null,
    definitionFr: null,
    labelEn: null,
    definitionEn: null,
    labelEs: null,
    definitionEs: null,
    labelDe: null,
    definitionDe: null,
    labelIt: null,
    definitionIt: null,
    source: null,
    statut: null,
    metaCreateDate: null,
    metaUpdateDate: null,
  );

  setUp(() {
    mockAppDatabase = MockAppDatabase();
    mockTNomenclaturesDao = MockTNomenclaturesDao();
    mockBibNomenclaturesTypesDao = MockBibNomenclaturesTypesDao();
    mockDB = MockDB();

    // Configuration du mock DB
    when(() => mockDB.database).thenAnswer((_) async => mockAppDatabase);
    
    // Configuration des mocks des DAOs
    when(() => mockAppDatabase.tNomenclaturesDao).thenReturn(mockTNomenclaturesDao);
    when(() => mockAppDatabase.bibNomenclaturesTypesDao).thenReturn(mockBibNomenclaturesTypesDao);

    // Remplacer l'instance singleton de DB par notre mock
    DB.setInstance(mockDB);

    // Initialisation du repository
    nomenclaturesDatabase = NomenclaturesDatabaseImpl();
  });

  group('NomenclaturesDatabase - Nomenclatures Operations', () {
    test('getAllNomenclatures should return all nomenclatures', () async {
      // Arrange
      when(() => mockTNomenclaturesDao.getAllNomenclatures())
          .thenAnswer((_) async => testNomenclatures);

      // Act
      final result = await nomenclaturesDatabase.getAllNomenclatures();

      // Assert
      expect(result, equals(testNomenclatures));
      verify(() => mockTNomenclaturesDao.getAllNomenclatures()).called(1);
    });

    test('insertNomenclatures should insert new nomenclatures and update existing ones', () async {
      // Arrange
      when(() => mockTNomenclaturesDao.getAllNomenclatures())
          .thenAnswer((_) async => [testNomenclature1]); // testNomenclature1 already exists
      
      when(() => mockTNomenclaturesDao.insertNomenclatures(any()))
          .thenAnswer((_) async => {});
          
      when(() => mockTNomenclaturesDao.updateNomenclature(any()))
          .thenAnswer((_) async => {});

      // Act
      await nomenclaturesDatabase.insertNomenclatures([testNomenclature1, testNomenclature2]);

      // Assert
      verify(() => mockTNomenclaturesDao.getAllNomenclatures()).called(1);
      
      // Verify testNomenclature2 was inserted (it's new)
      verify(() => mockTNomenclaturesDao.insertNomenclatures([testNomenclature2])).called(1);
      
      // Verify testNomenclature1 was updated (it already exists)
      verify(() => mockTNomenclaturesDao.updateNomenclature(testNomenclature1)).called(1);
    });

    test('clearNomenclatures should clear all nomenclatures', () async {
      // Arrange
      when(() => mockTNomenclaturesDao.clearNomenclatures())
          .thenAnswer((_) async => {});

      // Act
      await nomenclaturesDatabase.clearNomenclatures();

      // Assert
      verify(() => mockTNomenclaturesDao.clearNomenclatures()).called(1);
    });
  });

  group('NomenclaturesDatabase - NomenclatureTypes Operations', () {
    test('getAllNomenclatureTypes should return all nomenclature types', () async {
      // Arrange
      when(() => mockBibNomenclaturesTypesDao.getAllNomenclatureTypes())
          .thenAnswer((_) async => [testBibNomenclatureType]);

      // Act
      final result = await nomenclaturesDatabase.getAllNomenclatureTypes();

      // Assert
      expect(result.length, equals(1));
      expect(result.first.idType, equals(testNomenclatureType.idType));
      expect(result.first.mnemonique, equals(testNomenclatureType.mnemonique));
      verify(() => mockBibNomenclaturesTypesDao.getAllNomenclatureTypes()).called(1);
    });

    test('getNomenclatureTypeByMnemonique should return a specific nomenclature type', () async {
      // Arrange
      when(() => mockBibNomenclaturesTypesDao.getNomenclatureTypeByMnemonique('TEST_TYPE'))
          .thenAnswer((_) async => testBibNomenclatureType);

      // Act
      final result = await nomenclaturesDatabase.getNomenclatureTypeByMnemonique('TEST_TYPE');

      // Assert
      expect(result, isNotNull);
      expect(result?.idType, equals(testNomenclatureType.idType));
      expect(result?.mnemonique, equals(testNomenclatureType.mnemonique));
      verify(() => mockBibNomenclaturesTypesDao.getNomenclatureTypeByMnemonique('TEST_TYPE')).called(1);
    });

    test('insertNomenclatureTypes should insert only new nomenclature types', () async {
      // Arrange
      when(() => mockBibNomenclaturesTypesDao.getAllNomenclatureTypes())
          .thenAnswer((_) async => [testBibNomenclatureType]); // Type already exists
          
      when(() => mockBibNomenclaturesTypesDao.insertNomenclatureTypes(any()))
          .thenAnswer((_) async => {});

      final newType = NomenclatureType(
        idType: 101,
        mnemonique: 'NEW_TYPE',
        labelDefault: 'New Type',
      );

      // Act
      await nomenclaturesDatabase.insertNomenclatureTypes([testNomenclatureType, newType]);

      // Assert
      verify(() => mockBibNomenclaturesTypesDao.getAllNomenclatureTypes()).called(1);
      
      // Verify that new types were attempted to be inserted
      verify(() => mockBibNomenclaturesTypesDao.insertNomenclatureTypes(any())).called(1);
    });

    test('clearNomenclatureTypes should clear all nomenclature types', () async {
      // Arrange
      when(() => mockBibNomenclaturesTypesDao.clearNomenclatureTypes())
          .thenAnswer((_) async => {});

      // Act
      await nomenclaturesDatabase.clearNomenclatureTypes();

      // Assert
      verify(() => mockBibNomenclaturesTypesDao.clearNomenclatureTypes()).called(1);
    });
  });

  group('NomenclaturesDatabase - Error Handling', () {
    test('getAllNomenclatures should handle DAO errors', () async {
      // Arrange
      when(() => mockTNomenclaturesDao.getAllNomenclatures())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => nomenclaturesDatabase.getAllNomenclatures(),
        throwsA(isA<Exception>()),
      );
    });

    test('insertNomenclatures should handle DAO errors', () async {
      // Arrange
      when(() => mockTNomenclaturesDao.getAllNomenclatures())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => nomenclaturesDatabase.insertNomenclatures(testNomenclatures),
        throwsA(isA<Exception>()),
      );
    });

    test('getAllNomenclatureTypes should handle DAO errors', () async {
      // Arrange
      when(() => mockBibNomenclaturesTypesDao.getAllNomenclatureTypes())
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => nomenclaturesDatabase.getAllNomenclatureTypes(),
        throwsA(isA<Exception>()),
      );
    });
  });
}