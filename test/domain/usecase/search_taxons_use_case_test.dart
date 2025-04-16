import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/search_taxons_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockTaxonRepository extends Mock implements TaxonRepository {}

void main() {
  late SearchTaxonsUseCase useCase;
  late MockTaxonRepository mockTaxonRepository;

  setUp(() {
    mockTaxonRepository = MockTaxonRepository();
    useCase = SearchTaxonsUseCaseImpl(mockTaxonRepository);
  });

  test('execute should search taxons globally when no list ID is provided', () async {
    // Arrange
    const String searchTerm = "Pinus";
    final taxons = [
      Taxon(cdNom: 1, nomComplet: "Pinus sylvestris", lbNom: "Pin sylvestre", nomVern: "Pin sylvestre"),
      Taxon(cdNom: 2, nomComplet: "Pinus pinaster", lbNom: "Pin maritime", nomVern: "Pin maritime"),
    ];
    
    when(() => mockTaxonRepository.searchTaxons(searchTerm))
        .thenAnswer((_) async => taxons);

    // Act
    final result = await useCase.execute(searchTerm);

    // Assert
    expect(result, equals(taxons));
    verify(() => mockTaxonRepository.searchTaxons(searchTerm)).called(1);
    verifyNever(() => mockTaxonRepository.searchTaxonsByListId(any(), any()));
  });

  test('execute should search taxons by list ID when list ID is provided', () async {
    // Arrange
    const String searchTerm = "Pinus";
    const int listId = 42;
    final taxons = [
      Taxon(cdNom: 1, nomComplet: "Pinus sylvestris", lbNom: "Pin sylvestre", nomVern: "Pin sylvestre"),
    ];
    
    when(() => mockTaxonRepository.searchTaxonsByListId(searchTerm, listId))
        .thenAnswer((_) async => taxons);

    // Act
    final result = await useCase.execute(searchTerm, idListe: listId);

    // Assert
    expect(result, equals(taxons));
    verify(() => mockTaxonRepository.searchTaxonsByListId(searchTerm, listId)).called(1);
    verifyNever(() => mockTaxonRepository.searchTaxons(any()));
  });

  test('execute should return empty list when no taxons found', () async {
    // Arrange
    const String searchTerm = "UnknownTaxon";
    when(() => mockTaxonRepository.searchTaxons(searchTerm))
        .thenAnswer((_) async => []);

    // Act
    final result = await useCase.execute(searchTerm);

    // Assert
    expect(result, isEmpty);
    verify(() => mockTaxonRepository.searchTaxons(searchTerm)).called(1);
  });

  test('execute should handle repository exception for global search and rethrow', () async {
    // Arrange
    const String searchTerm = "Pinus";
    when(() => mockTaxonRepository.searchTaxons(searchTerm))
        .thenThrow(Exception('Database Error'));

    // Act & Assert
    expect(
      () => useCase.execute(searchTerm),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaxonRepository.searchTaxons(searchTerm)).called(1);
  });

  test('execute should handle repository exception for list-specific search and rethrow', () async {
    // Arrange
    const String searchTerm = "Pinus";
    const int listId = 42;
    when(() => mockTaxonRepository.searchTaxonsByListId(searchTerm, listId))
        .thenThrow(Exception('Database Error'));

    // Act & Assert
    expect(
      () => useCase.execute(searchTerm, idListe: listId),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaxonRepository.searchTaxonsByListId(searchTerm, listId)).called(1);
  });
}