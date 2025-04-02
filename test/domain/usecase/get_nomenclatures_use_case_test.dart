import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_nomenclatures_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetNomenclaturesUseCase useCase;
  late MockModulesRepository mockModulesRepository;

  setUp(() {
    mockModulesRepository = MockModulesRepository();
    useCase = GetNomenclaturesUseCaseImpl(mockModulesRepository);
  });

  group('GetNomenclaturesUseCase', () {
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
    ];

    test('should return nomenclatures from repository', () async {
      // Arrange
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(nomenclatures));
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
    });

    test('should return empty list when no nomenclatures are available', () async {
      // Arrange
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      final exception = Exception('Failed to get nomenclatures');
      when(() => mockModulesRepository.getNomenclatures())
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(equals(exception)),
      );
    });
  });

  group('GetNomenclaturesByTypeUseCase', () {
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
        idType: 118,
        cdNomenclature: "1",
        labelDefault: "Other type",
        definitionDefault: "Other definition",
      ),
    ];

    test('should return nomenclatures filtered by type', () async {
      // Arrange
      const idType = 117;
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);

      // Act
      final result = await useCase.executeByType(idType);

      // Assert
      expect(result.length, equals(2));
      expect(result.every((e) => e.idType == idType), isTrue);
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
    });

    test('should return empty list when no nomenclatures match the type', () async {
      // Arrange
      const idType = 999; // Non-existent type
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);

      // Act
      final result = await useCase.executeByType(idType);

      // Assert
      expect(result, isEmpty);
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
    });
  });
}