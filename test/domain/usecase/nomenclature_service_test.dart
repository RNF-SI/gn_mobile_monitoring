import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/nomenclature_service.dart';

void main() {
  group('NomenclatureService', () {
    final nomenclatures = [
      const Nomenclature(
        id: 467,
        idType: 117,
        cdNomenclature: "2",
        labelDefault: "Photo",
        definitionDefault: "Média de type image",
      ),
      const Nomenclature(
        id: 468,
        idType: 117,
        cdNomenclature: "3",
        labelDefault: "Page web",
        definitionDefault: "Média de type page web",
      ),
      const Nomenclature(
        id: 686,
        idType: 116,
        cdNomenclature: "APO_DALLES",
        labelDefault: "Dalles à orpins",
        definitionDefault: "Dalles à orpins",
      ),
    ];

    final typeMapping = {
      'TYPE_MEDIA': 117,
      'TYPE_SITE': 116,
    };

    final inverseTypeMapping = {
      117: 'TYPE_MEDIA',
      116: 'TYPE_SITE',
    };

    test('buildInverseTypeMapping should correctly invert the mapping', () {
      // Act
      final result = NomenclatureService.buildInverseTypeMapping(typeMapping);

      // Assert
      expect(result, equals(inverseTypeMapping));
    });
    
    group('idToFormValue', () {
      test('should convert id_nomenclature to form object', () {
        // Arrange
        final idNomenclature = 467;
        
        // Act
        final result = NomenclatureService.idToFormValue(
          idNomenclature, 
          nomenclatures,
          inverseTypeMapping,
        );
        
        // Assert
        expect(result, isNotNull);
        expect(result!['code_nomenclature_type'], equals('TYPE_MEDIA'));
        expect(result['cd_nomenclature'], equals('2'));
        expect(result['label'], equals('Photo'));
      });
      
      test('should return null for non-existent nomenclature', () {
        // Arrange
        final idNomenclature = 999; // Non-existent ID
        
        // Act
        final result = NomenclatureService.idToFormValue(
          idNomenclature, 
          nomenclatures,
          inverseTypeMapping,
        );
        
        // Assert
        expect(result, isNull);
      });
      
      test('should return null for null id_nomenclature', () {
        // Act
        final result = NomenclatureService.idToFormValue(
          null, 
          nomenclatures,
          inverseTypeMapping,
        );
        
        // Assert
        expect(result, isNull);
      });
    });
    
    group('formValueToId', () {
      test('should convert form object to id_nomenclature', () {
        // Arrange
        final formValue = {
          'code_nomenclature_type': 'TYPE_MEDIA',
          'cd_nomenclature': '2',
        };
        
        // Act
        final result = NomenclatureService.formValueToId(
          formValue, 
          nomenclatures,
          typeMapping,
        );
        
        // Assert
        expect(result, equals(467));
      });
      
      test('should return null for non-existent nomenclature', () {
        // Arrange
        final formValue = {
          'code_nomenclature_type': 'TYPE_MEDIA',
          'cd_nomenclature': '999', // Non-existent code
        };
        
        // Act
        final result = NomenclatureService.formValueToId(
          formValue, 
          nomenclatures,
          typeMapping,
        );
        
        // Assert
        expect(result, isNull);
      });
      
      test('should return null for missing code_nomenclature_type', () {
        // Arrange
        final formValue = {
          'cd_nomenclature': '2',
        };
        
        // Act
        final result = NomenclatureService.formValueToId(
          formValue, 
          nomenclatures,
          typeMapping,
        );
        
        // Assert
        expect(result, isNull);
      });
      
      test('should return null for missing cd_nomenclature', () {
        // Arrange
        final formValue = {
          'code_nomenclature_type': 'TYPE_MEDIA',
        };
        
        // Act
        final result = NomenclatureService.formValueToId(
          formValue, 
          nomenclatures,
          typeMapping,
        );
        
        // Assert
        expect(result, isNull);
      });
      
      test('should return null for unknown type code', () {
        // Arrange
        final formValue = {
          'code_nomenclature_type': 'UNKNOWN_TYPE',
          'cd_nomenclature': '2',
        };
        
        // Act
        final result = NomenclatureService.formValueToId(
          formValue, 
          nomenclatures,
          typeMapping,
        );
        
        // Assert
        expect(result, isNull);
      });
    });
  });
}