import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxons_by_list_id_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockTaxonRepository extends Mock implements TaxonRepository {}

void main() {
  late GetTaxonsByListIdUseCase useCase;
  late MockTaxonRepository mockTaxonRepository;

  setUp(() {
    mockTaxonRepository = MockTaxonRepository();
    useCase = GetTaxonsByListIdUseCaseImpl(mockTaxonRepository);
  });

  test('execute should return taxons from repository for a given list ID', () async {
    // Arrange
    const int listId = 42;
    final taxons = [
      Taxon(cdNom: 1, nomComplet: "Taxon 1", lbNom: "Taxon1", nomVern: "Taxon commun 1"),
      Taxon(cdNom: 2, nomComplet: "Taxon 2", lbNom: "Taxon2", nomVern: "Taxon commun 2"),
    ];
    
    when(() => mockTaxonRepository.getTaxonsByListId(listId))
        .thenAnswer((_) async => taxons);

    // Act
    final result = await useCase.execute(listId);

    // Assert
    expect(result, equals(taxons));
    verify(() => mockTaxonRepository.getTaxonsByListId(listId)).called(1);
  });

  test('execute should return empty list when no taxons found for the list', () async {
    // Arrange
    const int listId = 42;
    when(() => mockTaxonRepository.getTaxonsByListId(listId))
        .thenAnswer((_) async => []);

    // Act
    final result = await useCase.execute(listId);

    // Assert
    expect(result, isEmpty);
    verify(() => mockTaxonRepository.getTaxonsByListId(listId)).called(1);
  });

  test('execute should handle repository exception and rethrow', () async {
    // Arrange
    const int listId = 42;
    when(() => mockTaxonRepository.getTaxonsByListId(listId))
        .thenThrow(Exception('Database Error'));

    // Act & Assert
    expect(
      () => useCase.execute(listId),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaxonRepository.getTaxonsByListId(listId)).called(1);
  });
}