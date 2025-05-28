import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_nomenclatures_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_nomenclatures_use_case_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

void main() {
  late GetModuleNomenclaturesUseCase useCase;
  late MockModulesRepository mockModulesRepository;

  setUp(() {
    mockModulesRepository = MockModulesRepository();
    useCase = GetModuleNomenclaturesUseCaseImpl(mockModulesRepository);
  });

  group('GetModuleNomenclaturesUseCase', () {
    final module = Module(
      id: 1,
      moduleCode: 'TEST_MODULE',
    );

    final moduleConfiguration = ModuleConfiguration(
      data: DataConfig(
        nomenclature: ['TYPE_MEDIA', 'TYPE_SITE'],
      ),
      module: ModuleConfig(
        generic: {
          'field1': GenericFieldConfig(
            typeUtil: 'nomenclature',
            api: 'nomenclatures/nomenclature/TYPE_MEDIA'
          ),
          'field2': GenericFieldConfig(
            typeUtil: 'nomenclature',
            api: 'nomenclatures/nomenclature/TYPE_SITE'
          ),
          'field3': GenericFieldConfig(
            typeUtil: 'text'
          ),
        }
      )
    );
    
    // Créer un ModuleComplement pour être utilisé dans le test
    final moduleComplement = ModuleComplement(
      idModule: 1,
      configuration: moduleConfiguration,
    );

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

    test('should extract nomenclature types from module configuration', () async {
      // Arrange
      when(() => mockModulesRepository.getModuleById(any()))
          .thenAnswer((_) async => module.copyWith(complement: moduleComplement));
          
      when(() => mockModulesRepository.getModuleConfiguration(any()))
          .thenAnswer((_) async => moduleConfiguration);
      
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => {'TYPE_MEDIA': 117, 'TYPE_SITE': 116});
          
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);

      // Act
      final result = await useCase.execute(module.id);

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, equals(3));
      
      // Vérification que les appels sont faits correctement
      verify(() => mockModulesRepository.getModuleById(module.id)).called(1);
      verify(() => mockModulesRepository.getModuleConfiguration(any())).called(1);
      verify(() => mockModulesRepository.getNomenclatureTypeMapping()).called(1);
      verify(() => mockModulesRepository.getNomenclatures()).called(1);
    });

    test('should return empty list when module configuration has no nomenclature types', () async {
      // Arrange
      final emptyConfig = ModuleConfiguration(
        data: DataConfig(nomenclature: []),
        module: ModuleConfig(generic: {})
      );
      
      when(() => mockModulesRepository.getModuleById(any()))
          .thenAnswer((_) async => module);
          
      when(() => mockModulesRepository.getModuleConfiguration(any()))
          .thenAnswer((_) async => emptyConfig);
      
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => {});
          
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);

      // Act
      final result = await useCase.execute(module.id);

      // Assert
      expect(result, isEmpty);
    });

    test('should filter nomenclatures by types defined in module configuration', () async {
      // Arrange
      final specificConfig = ModuleConfiguration(
        data: DataConfig(
          // Seulement TYPE_MEDIA spécifié
          nomenclature: ['TYPE_MEDIA'],
        ),
        module: null
      );
      
      when(() => mockModulesRepository.getModuleById(any()))
          .thenAnswer((_) async => module);
          
      when(() => mockModulesRepository.getModuleConfiguration(any()))
          .thenAnswer((_) async => specificConfig);
      
      when(() => mockModulesRepository.getNomenclatureTypeMapping())
          .thenAnswer((_) async => {'TYPE_MEDIA': 117, 'TYPE_SITE': 116});
          
      when(() => mockModulesRepository.getNomenclatures())
          .thenAnswer((_) async => nomenclatures);

      // Act
      final result = await useCase.execute(module.id);

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, equals(2)); // Seulement les nomenclatures de type TYPE_MEDIA (2)
      expect(result.every((n) => n.idType == 117), isTrue);
    });

    test('should rethrow exception when repository throws an error', () async {
      // Arrange
      final exception = Exception('Failed to get module configuration');
      when(() => mockModulesRepository.getModuleById(any()))
          .thenThrow(exception);

      // Act & Assert
      expect(
        () => useCase.execute(module.id),
        throwsA(equals(exception)),
      );
    });
  });
}