import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_taxon_by_cd_nom_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockTaxonRepository extends Mock implements TaxonRepository {}

void main() {
  late GetTaxonByCdNomUseCase useCase;
  late MockTaxonRepository mockTaxonRepository;

  setUp(() {
    mockTaxonRepository = MockTaxonRepository();
    useCase = GetTaxonByCdNomUseCaseImpl(mockTaxonRepository);
  });

  test('execute should return taxon from repository for a given cdNom', () async {
    // Arrange
    const int cdNom = 12345;
    final taxon = Taxon(
      cdNom: cdNom,
      nomComplet: "Taxon Test",
      lbNom: "TaxonTest",
      nomVern: "Taxon commun test"
    );
    
    when(() => mockTaxonRepository.getTaxonByCdNom(cdNom))
        .thenAnswer((_) async => taxon);

    // Act
    final result = await useCase.execute(cdNom);

    // Assert
    expect(result, equals(taxon));
    verify(() => mockTaxonRepository.getTaxonByCdNom(cdNom)).called(1);
  });

  test('execute should return null when taxon not found', () async {
    // Arrange
    const int cdNom = 12345;
    when(() => mockTaxonRepository.getTaxonByCdNom(cdNom))
        .thenAnswer((_) async => null);

    // Act
    final result = await useCase.execute(cdNom);

    // Assert
    expect(result, isNull);
    verify(() => mockTaxonRepository.getTaxonByCdNom(cdNom)).called(1);
  });

  test('execute should handle repository exception and rethrow', () async {
    // Arrange
    const int cdNom = 12345;
    when(() => mockTaxonRepository.getTaxonByCdNom(cdNom))
        .thenThrow(Exception('Database Error'));

    // Act & Assert
    expect(
      () => useCase.execute(cdNom),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaxonRepository.getTaxonByCdNom(cdNom)).called(1);
  });
}