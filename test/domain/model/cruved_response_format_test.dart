import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

void main() {
  group('CruvedResponse Format Compatibility Tests', () {
    test('should parse boolean format from site-specific API', () {
      // Format booléen comme retourné par /monitorings/object/{module}/site/{id}
      const jsonString = '''
      {
        "C": true,
        "D": true,
        "E": false,
        "R": true,
        "U": true,
        "V": false
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, true);
      expect(cruved.delete, true);
      expect(cruved.export, false);
      expect(cruved.read, true);
      expect(cruved.update, true);
      expect(cruved.validate, false);
    });

    test('should parse numeric scope format from module API', () {
      // Format numérique comme retourné par /monitorings/modules
      const jsonString = '''
      {
        "C": 0,
        "D": 0,
        "E": 3,
        "R": 3,
        "U": 3,
        "V": 0
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, false);     // 0 = pas d'accès
      expect(cruved.delete, false);     // 0 = pas d'accès
      expect(cruved.export, true);      // 3 = accès complet
      expect(cruved.read, true);        // 3 = accès complet
      expect(cruved.update, true);      // 3 = accès complet
      expect(cruved.validate, false);   // 0 = pas d'accès
    });

    test('should parse numeric scope format from sites/groups API', () {
      // Format numérique comme retourné par /monitorings/object/{module}/module
      const jsonString = '''
      {
        "C": 3,
        "D": 3,
        "E": 0,
        "R": 3,
        "U": 3,
        "V": 0
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, true);      // 3 = accès complet
      expect(cruved.delete, true);      // 3 = accès complet
      expect(cruved.export, false);     // 0 = pas d'accès
      expect(cruved.read, true);        // 3 = accès complet
      expect(cruved.update, true);      // 3 = accès complet
      expect(cruved.validate, false);   // 0 = pas d'accès
    });

    test('should handle partial permissions with different scope levels', () {
      // Test avec différents niveaux de scope
      const jsonString = '''
      {
        "C": 1,
        "D": 0,
        "E": 2,
        "R": 3,
        "U": 1,
        "V": 0
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, true);      // 1 = mes données (> 0, donc true)
      expect(cruved.delete, false);     // 0 = pas d'accès
      expect(cruved.export, true);      // 2 = mon organisme (> 0, donc true)
      expect(cruved.read, true);        // 3 = accès complet
      expect(cruved.update, true);      // 1 = mes données (> 0, donc true)
      expect(cruved.validate, false);   // 0 = pas d'accès
    });

    test('should handle mixed format gracefully', () {
      // Test avec format mixte (ne devrait pas arriver, mais soyons robustes)
      const jsonString = '''
      {
        "C": true,
        "D": 0,
        "E": false,
        "R": 3,
        "U": true,
        "V": 0
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, true);      // boolean true
      expect(cruved.delete, false);     // numeric 0
      expect(cruved.export, false);     // boolean false
      expect(cruved.read, true);        // numeric 3
      expect(cruved.update, true);      // boolean true
      expect(cruved.validate, false);   // numeric 0
    });

    test('should handle string values gracefully', () {
      // Test avec des strings (cas d'erreur potentiel)
      const jsonString = '''
      {
        "C": "true",
        "D": "false",
        "E": "true",
        "R": "false",
        "U": "true",
        "V": "false"
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, true);      
      expect(cruved.delete, false);     
      expect(cruved.export, true);     
      expect(cruved.read, false);        
      expect(cruved.update, true);      
      expect(cruved.validate, false);   
    });

    test('should handle missing values with defaults', () {
      // Test avec des valeurs manquantes
      const jsonString = '''
      {
        "R": 3,
        "U": true
      }
      ''';

      final Map<String, dynamic> json = jsonDecode(jsonString);
      final cruved = CruvedResponse.fromJson(json);

      expect(cruved.create, false);     // valeur par défaut
      expect(cruved.delete, false);     // valeur par défaut
      expect(cruved.export, false);     // valeur par défaut
      expect(cruved.read, true);        // 3 fourni
      expect(cruved.update, true);      // true fourni
      expect(cruved.validate, false);   // valeur par défaut
    });

    group('CruvedResponse.fromScope factory', () {
      test('should create from scope data correctly', () {
        final scopeData = {
          'C': 0,
          'R': 3,
          'U': 1,
          'V': 0,
          'E': 2,
          'D': 0,
        };

        final cruved = CruvedResponse.fromScope(scopeData);

        expect(cruved.create, false);    // 0
        expect(cruved.read, true);       // 3 > 0
        expect(cruved.update, true);     // 1 > 0
        expect(cruved.validate, false);  // 0
        expect(cruved.export, true);     // 2 > 0
        expect(cruved.delete, false);    // 0
      });
    });

    group('CruvedResponse.toScopeMap', () {
      test('should convert to scope map correctly', () {
        const cruved = CruvedResponse(
          create: true,
          read: false,
          update: true,
          validate: false,
          export: true,
          delete: false,
        );

        final scopeMap = cruved.toScopeMap();

        expect(scopeMap['C'], 3);  // true -> 3
        expect(scopeMap['R'], 0);  // false -> 0
        expect(scopeMap['U'], 3);  // true -> 3
        expect(scopeMap['V'], 0);  // false -> 0
        expect(scopeMap['E'], 3);  // true -> 3
        expect(scopeMap['D'], 0);  // false -> 0
      });
    });

    group('Real API Response Integration Tests', () {
      test('should parse modules API response correctly', () {
        // Exemple réel du endpoint /monitorings/modules
        const moduleResponse = '''
        {
          "id": 4,
          "name": "Reptile",
          "code": "POPReptile",
          "description": "Suivi Reptile",
          "cruved": {
            "C": 0,
            "D": 0,
            "E": 3,
            "R": 3,
            "U": 3,
            "V": 0
          }
        }
        ''';

        final Map<String, dynamic> json = jsonDecode(moduleResponse);
        final moduleData = ModuleResponse.fromJson(json);

        expect(moduleData.cruved.create, false);
        expect(moduleData.cruved.read, true);
        expect(moduleData.cruved.update, true);
        expect(moduleData.cruved.export, true);
        expect(moduleData.cruved.validate, false);
        expect(moduleData.cruved.delete, false);
      });

      test('should parse site API response correctly', () {
        // Exemple réel du endpoint /monitorings/object/{module}/site/{id}
        const siteResponse = '''
        {
          "id": 123,
          "name": "Site test",
          "code": "ST01",
          "cruved": {
            "C": true,
            "D": true,
            "E": false,
            "R": true,
            "U": true,
            "V": false
          }
        }
        ''';

        final Map<String, dynamic> json = jsonDecode(siteResponse);
        final siteData = SiteResponse.fromJson(json);

        expect(siteData.cruved.create, true);
        expect(siteData.cruved.read, true);
        expect(siteData.cruved.update, true);
        expect(siteData.cruved.export, false);
        expect(siteData.cruved.validate, false);
        expect(siteData.cruved.delete, true);
      });
    });
  });
}