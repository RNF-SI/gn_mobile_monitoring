import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_by_type_code_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetNomenclaturesByTypeCodeUseCase useCase;
  late MockModulesRepository mockModulesRepository;

  setUp(() {
    mockModulesRepository = MockModulesRepository();
    useCase = GetNomenclaturesByTypeCodeUseCaseImpl(mockModulesRepository);
  });

  group('GetNomenclaturesByTypeCodeUseCase', () {
    final Map<String, int> typeMappings = {
      'TYPE_MEDIA': 117,
      'TYPE_SITE': 116,
    };
    
    final nomenclatures = [
      const Nomenclature(
        id: 1,
        idType: 117,
        cdNomenclature: "2",
        labelDefault: "Photo",
        definitionDefault: "Média de type image",
      ),
      const Nomenclature(
        id: 2,
        idType: 117,
        cdNomenclature: "3",
        labelDefault: "Page web",
        definitionDefault: "Média de type page web",
      ),
      const Nomenclature(
        id: 3,
        idType: 116,
        cdNomenclature: "APO_DALLES",
        labelDefault: "Dalles à orpins",
        definitionDefault: "Dalles à orpins",
      ),
    ];

    test('should return nomenclatures filtered by type code', () async {
      // Arrange
      const typeCode = 'TYPE_MEDIA';
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => typeMappings);

      // Act
      final result = await useCase.execute(typeCode);

      // Assert
      expect(result.length, equals(2));
      expect(result.every((e) => e.idType == 117), isTrue);
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
      verify(() => mockModulesRepository.getNomenclatureTypeMapping()).called(1);
    });

    test('should return empty list when type code is not found in mappings', () async {
      // Arrange
      const typeCode = 'UNKNOWN_TYPE';
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => typeMappings);

      // Act
      final result = await useCase.execute(typeCode);

      // Assert
      expect(result, isEmpty);
      verify(() => mockModulesRepository.getNomenclatureTypeMapping()).called(1);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      const typeCode = 'TYPE_MEDIA';
      final exception = Exception('Failed to get nomenclature type mappings');
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(typeCode),
        throwsA(equals(exception)),
      );
    });
  });
}