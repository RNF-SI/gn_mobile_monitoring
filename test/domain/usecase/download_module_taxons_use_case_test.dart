import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_module_taxons_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

class MockTaxonRepository extends Mock implements TaxonRepository {}

void main() {
  late DownloadModuleTaxonsUseCase useCase;
  late MockTaxonRepository mockTaxonRepository;

  setUp(() {
    mockTaxonRepository = MockTaxonRepository();
    useCase = DownloadModuleTaxonsUseCaseImpl(mockTaxonRepository);
  });

  test('execute should call repository downloadModuleTaxons with moduleId', () async {
    // Arrange
    const int moduleId = 123;
    when(() => mockTaxonRepository.downloadModuleTaxons(moduleId))
        .thenAnswer((_) async => {});

    // Act
    await useCase.execute(moduleId);

    // Assert
    verify(() => mockTaxonRepository.downloadModuleTaxons(moduleId)).called(1);
  });

  test('execute should handle repository exception and rethrow', () async {
    // Arrange
    const int moduleId = 123;
    when(() => mockTaxonRepository.downloadModuleTaxons(moduleId))
        .thenThrow(Exception('API Error'));

    // Act & Assert
    expect(
      () => useCase.execute(moduleId),
      throwsA(isA<Exception>()),
    );
    verify(() => mockTaxonRepository.downloadModuleTaxons(moduleId)).called(1);
  });
}