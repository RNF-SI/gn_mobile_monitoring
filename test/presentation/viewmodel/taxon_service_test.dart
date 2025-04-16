import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxon_by_cd_nom_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxons_by_list_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/search_taxons_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart' as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockGetModuleTaxonsUseCase extends Mock implements GetModuleTaxonsUseCase {}
class MockGetTaxonsByListIdUseCase extends Mock implements GetTaxonsByListIdUseCase {}
class MockGetTaxonByCdNomUseCase extends Mock implements GetTaxonByCdNomUseCase {}
class MockSearchTaxonsUseCase extends Mock implements SearchTaxonsUseCase {}

void main() {
  late ProviderContainer container;
  late TaxonService taxonService;
  late MockGetModuleTaxonsUseCase mockGetModuleTaxonsUseCase;
  late MockGetTaxonsByListIdUseCase mockGetTaxonsByListIdUseCase;
  late MockGetTaxonByCdNomUseCase mockGetTaxonByCdNomUseCase;
  late MockSearchTaxonsUseCase mockSearchTaxonsUseCase;

  // Données de test
  final testTaxons = [
    Taxon(cdNom: 1, nomComplet: "Pinus sylvestris", lbNom: "Pin sylvestre", nomVern: "Pin sylvestre"),
    Taxon(cdNom: 2, nomComplet: "Betula pendula", lbNom: "Bouleau verruqueux", nomVern: "Bouleau verruqueux"),
  ];

  final testTaxon = Taxon(cdNom: 1, nomComplet: "Pinus sylvestris", lbNom: "Pin sylvestre", nomVern: "Pin sylvestre");

  setUp(() {
    mockGetModuleTaxonsUseCase = MockGetModuleTaxonsUseCase();
    mockGetTaxonsByListIdUseCase = MockGetTaxonsByListIdUseCase();
    mockGetTaxonByCdNomUseCase = MockGetTaxonByCdNomUseCase();
    mockSearchTaxonsUseCase = MockSearchTaxonsUseCase();

    // Configuration par défaut des mocks
    when(() => mockGetModuleTaxonsUseCase.execute(any()))
        .thenAnswer((_) async => []);
    when(() => mockGetTaxonsByListIdUseCase.execute(any()))
        .thenAnswer((_) async => []);
    when(() => mockGetTaxonByCdNomUseCase.execute(any()))
        .thenAnswer((_) async => null);
    when(() => mockSearchTaxonsUseCase.execute(any(), idListe: any(named: 'idListe')))
        .thenAnswer((_) async => []);

    container = ProviderContainer(
      overrides: [
        // Override les providers pour utiliser nos mocks
        getModuleTaxonsUseCaseProvider.overrideWithValue(mockGetModuleTaxonsUseCase),
        getTaxonsByListIdUseCaseProvider.overrideWithValue(mockGetTaxonsByListIdUseCase),
        getTaxonByCdNomUseCaseProvider.overrideWithValue(mockGetTaxonByCdNomUseCase),
        searchTaxonsUseCaseProvider.overrideWithValue(mockSearchTaxonsUseCase),
      ],
    );

    taxonService = container.read(taxonServiceProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('TaxonService - Initial State', () {
    test('Initial state should be init', () {
      final state = container.read(taxonServiceProvider);
      expect(state.isInit, isTrue);
    });
  });

  group('TaxonService - getTaxonsByModuleId', () {
    test('should return taxons for a module', () async {
      // Arrange
      const int moduleId = 123;
      when(() => mockGetModuleTaxonsUseCase.execute(moduleId))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await taxonService.getTaxonsByModuleId(moduleId);

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockGetModuleTaxonsUseCase.execute(moduleId)).called(1);
    });

    test('should return empty list on exception', () async {
      // Arrange
      const int moduleId = 123;
      when(() => mockGetModuleTaxonsUseCase.execute(moduleId))
          .thenThrow(Exception('API Error'));

      // Act
      final result = await taxonService.getTaxonsByModuleId(moduleId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockGetModuleTaxonsUseCase.execute(moduleId)).called(1);
    });
  });

  group('TaxonService - getTaxonsByListId', () {
    test('should return taxons for a list ID', () async {
      // Arrange
      const int listId = 42;
      when(() => mockGetTaxonsByListIdUseCase.execute(listId))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await taxonService.getTaxonsByListId(listId);

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockGetTaxonsByListIdUseCase.execute(listId)).called(1);
    });

    test('should return empty list on exception', () async {
      // Arrange
      const int listId = 42;
      when(() => mockGetTaxonsByListIdUseCase.execute(listId))
          .thenThrow(Exception('Database Error'));

      // Act
      final result = await taxonService.getTaxonsByListId(listId);

      // Assert
      expect(result, isEmpty);
      verify(() => mockGetTaxonsByListIdUseCase.execute(listId)).called(1);
    });
  });

  group('TaxonService - getTaxonByCdNom', () {
    test('should return a taxon by cdNom', () async {
      // Arrange
      const int cdNom = 1;
      when(() => mockGetTaxonByCdNomUseCase.execute(cdNom))
          .thenAnswer((_) async => testTaxon);

      // Act
      final result = await taxonService.getTaxonByCdNom(cdNom);

      // Assert
      expect(result, equals(testTaxon));
      verify(() => mockGetTaxonByCdNomUseCase.execute(cdNom)).called(1);
    });

    test('should return null on exception', () async {
      // Arrange
      const int cdNom = 1;
      when(() => mockGetTaxonByCdNomUseCase.execute(cdNom))
          .thenThrow(Exception('Database Error'));

      // Act
      final result = await taxonService.getTaxonByCdNom(cdNom);

      // Assert
      expect(result, isNull);
      verify(() => mockGetTaxonByCdNomUseCase.execute(cdNom)).called(1);
    });
  });

  group('TaxonService - searchTaxons', () {
    test('should search taxons globally when no list ID is provided', () async {
      // Arrange
      const String searchTerm = "Pinus";
      when(() => mockSearchTaxonsUseCase.execute(searchTerm, idListe: null))
          .thenAnswer((_) async => testTaxons);

      // Act
      final result = await taxonService.searchTaxons(searchTerm);

      // Assert
      expect(result, equals(testTaxons));
      verify(() => mockSearchTaxonsUseCase.execute(searchTerm, idListe: null)).called(1);
    });

    test('should search taxons by list ID when list ID is provided', () async {
      // Arrange
      const String searchTerm = "Pinus";
      const int listId = 42;
      when(() => mockSearchTaxonsUseCase.execute(searchTerm, idListe: listId))
          .thenAnswer((_) async => [testTaxon]);

      // Act
      final result = await taxonService.searchTaxons(searchTerm, idListe: listId);

      // Assert
      expect(result, equals([testTaxon]));
      verify(() => mockSearchTaxonsUseCase.execute(searchTerm, idListe: listId)).called(1);
    });

    test('should return empty list on exception', () async {
      // Arrange
      const String searchTerm = "Pinus";
      when(() => mockSearchTaxonsUseCase.execute(searchTerm, idListe: null))
          .thenThrow(Exception('Database Error'));

      // Act
      final result = await taxonService.searchTaxons(searchTerm);

      // Assert
      expect(result, isEmpty);
      verify(() => mockSearchTaxonsUseCase.execute(searchTerm, idListe: null)).called(1);
    });
  });

  group('TaxonService - formatTaxonDisplay', () {
    test('should format taxon with nom_vern,lb_nom format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: "Pin sylvestre"
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'nom_vern,lb_nom');

      // Assert
      expect(result, 'Pin sylvestre (Pinus sylvestris)');
    });

    test('should use lbNom if nomVern is missing with nom_vern,lb_nom format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: null
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'nom_vern,lb_nom');

      // Assert
      expect(result, 'Pinus sylvestris');
    });

    test('should format taxon with lb_nom format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: "Pin sylvestre"
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'lb_nom');

      // Assert
      expect(result, 'Pinus sylvestris');
    });

    test('should format taxon with nom_complet format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: "Pin sylvestre"
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'nom_complet');

      // Assert
      expect(result, 'Pinus sylvestris L., 1753');
    });

    test('should format taxon with nom_vern format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: "Pin sylvestre"
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'nom_vern');

      // Assert
      expect(result, 'Pin sylvestre');
    });

    test('should use lbNom if nomVern is missing with nom_vern format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: null
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'nom_vern');

      // Assert
      expect(result, 'Pinus sylvestris');
    });

    test('should use nomComplet as default for unknown format', () {
      // Arrange
      final taxon = Taxon(
        cdNom: 1,
        nomComplet: "Pinus sylvestris L., 1753",
        lbNom: "Pinus sylvestris",
        nomVern: "Pin sylvestre"
      );

      // Act
      final result = taxonService.formatTaxonDisplay(taxon, 'unknown_format');

      // Assert
      expect(result, 'Pinus sylvestris L., 1753');
    });
  });
}