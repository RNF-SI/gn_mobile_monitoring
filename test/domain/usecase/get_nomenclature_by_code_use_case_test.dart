import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_code_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclature_by_code_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetNomenclatureByCodeUseCase useCase;
  late MockModulesRepository mockModulesRepository;

  setUp(() {
    mockModulesRepository = MockModulesRepository();
    useCase = GetNomenclatureByCodeUseCaseImpl(mockModulesRepository);
  });

  group('GetNomenclatureByCodeUseCase', () {
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

    test('should return nomenclature by its code', () async {
      // Arrange
      const typeCode = 'TYPE_MEDIA';
      const cdNomenclature = '2';
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => {'TYPE_MEDIA': 117});

      // Act
      final result = await useCase.execute(typeCode, cdNomenclature);

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals(1));
      expect(result.cdNomenclature, equals(cdNomenclature));
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
      verify(() => mockModulesRepository.getNomenclatureTypeMapping()).called(1);
    });

    test('should return null when nomenclature code not found', () async {
      // Arrange
      const typeCode = 'TYPE_MEDIA';
      const cdNomenclature = 'NOT_EXISTING';
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => {'TYPE_MEDIA': 117});

      // Act
      final result = await useCase.execute(typeCode, cdNomenclature);

      // Assert
      expect(result, isNull);
    });

    test('should return null when type code not found', () async {
      // Arrange
      const typeCode = 'UNKNOWN_TYPE';
      const cdNomenclature = '2';
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => {'TYPE_MEDIA': 117});

      // Act
      final result = await useCase.execute(typeCode, cdNomenclature);

      // Assert
      expect(result, isNull);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      const typeCode = 'TYPE_MEDIA';
      const cdNomenclature = '2';
      final exception = Exception('Failed to get nomenclature type mappings');
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(typeCode, cdNomenclature),
        throwsA(equals(exception)),
      );
    });
  });
}