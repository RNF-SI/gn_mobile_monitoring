import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_taxons_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockTaxonRepository extends Mock implements TaxonRepository {}

void main() {
  late GetModuleTaxonsUseCase useCase;
  late MockTaxonRepository mockTaxonRepository;

  setUp(() {
    mockTaxonRepository = MockTaxonRepository();
    useCase = GetModuleTaxonsUseCaseImpl(mockTaxonRepository);
  });

  test('execute should return taxons from repository for a given module', () async {
    // Arrange
    const int moduleId = 123;
    final taxons = [
      Taxon(cdNom: 1, nomComplet: "Taxon 1", lbNom: "Taxon1", nomVern: "Taxon commun 1"),
      Taxon(cdNom: 2, nomComplet: "Taxon 2", lbNom: "Taxon2", nomVern: "Taxon commun 2"),
    ];
    
    when(() => mockTaxonRepository.getTaxonsByModuleId(moduleId))
        .thenAnswer((_) async => taxons);

    // Act
    final result = await useCase.execute(moduleId);

    // Assert
    expect(result, equals(taxons));
    verify(() => mockTaxonRepository.getTaxonsByModuleId(moduleId)).called(1);
  });

  test('execute should return empty list when no taxons found', () async {
    // Arrange
    const int moduleId = 123;
    when(() => mockTaxonRepository.getTaxonsByModuleId(moduleId))
        .thenAnswer((_) async => []);

    // Act
    final result = await useCase.execute(moduleId);

    // Assert
    expect(result, isEmpty);
    verify(() => mockTaxonRepository.getTaxonsByModuleId(moduleId)).called(1);
  });

  test('execute should handle repository exception and rethrow', () async {
    // Arrange
    const int moduleId = 123;
    when(() => mockTaxonRepository.getTaxonsByModuleId(moduleId))
        .thenThrow(Exception('Database Error'));

    // Act & Assert
    expect(
      () => useCase.execute(moduleId),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaxonRepository.getTaxonsByModuleId(moduleId)).called(1);
  });
}