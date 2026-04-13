import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNomenclatureService extends Mock implements NomenclatureService {}

class MockTaxonService extends Mock implements TaxonService {}

class MockRef extends Mock implements Ref {}

void main() {
  late FormDataProcessor formDataProcessor;
  late MockRef mockRef;

  setUp(() {
    final mockNomenclatureService = MockNomenclatureService();
    final mockTaxonService = MockTaxonService();
    mockRef = MockRef();

    when(() => mockRef.read(nomenclatureServiceProvider.notifier))
        .thenReturn(mockNomenclatureService);
    when(() => mockRef.read(taxonServiceProvider.notifier))
        .thenReturn(mockTaxonService);

    formDataProcessor = FormDataProcessor(mockRef);
  });

  group('isFieldHidden', () {
    group('sans configuration', () {
      test('retourne false quand fieldConfig est null', () {
        // Arrange
        final context = {
          'value': {'field1': true}
        };

        // Act
        final result = formDataProcessor.isFieldHidden('field1', context);

        // Assert
        expect(result, false);
      });
    });

    group('avec valeur booléenne directe', () {
      test('retourne true quand hidden est true', () {
        // Arrange
        final context = {
          'value': {'field1': 'test'}
        };
        final fieldConfig = {'hidden': true};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });

      test('retourne false quand hidden est false', () {
        // Arrange
        final context = {
          'value': {'field1': 'test'}
        };
        final fieldConfig = {'hidden': false};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });
    });

    group('avec expression simple JS ({value}) =>', () {
      test('retourne true quand la valeur référencée est true', () {
        // Arrange
        final context = {
          'value': {'test_detectabilite': true}
        };
        final fieldConfig = {
          'hidden': "({value}) => value.test_detectabilite"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'other_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });

      test('retourne false quand la valeur référencée est false', () {
        // Arrange
        final context = {
          'value': {'test_detectabilite': false}
        };
        final fieldConfig = {
          'hidden': "({value}) => value.test_detectabilite"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'other_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });
    });

    group('avec expression Dart (value) =>', () {
      test('retourne true avec expression bracket access quand valeur est true',
          () {
        // Arrange
        final context = {
          'value': {'my_flag': true}
        };
        final fieldConfig = {"hidden": "(value) => value['my_flag']"};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });

      test('retourne false avec expression bracket access quand valeur est false',
          () {
        // Arrange
        final context = {
          'value': {'my_flag': false}
        };
        final fieldConfig = {"hidden": "(value) => value['my_flag']"};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });
    });

    group('avec négation', () {
      test('retourne false quand !value et valeur est true', () {
        // Arrange
        final context = {
          'value': {'test_flag': true}
        };
        final fieldConfig = {
          'hidden': "({value}) => !value.test_flag"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });

      test('retourne true quand !value et valeur est false', () {
        // Arrange
        final context = {
          'value': {'test_flag': false}
        };
        final fieldConfig = {
          'hidden': "({value}) => !value.test_flag"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });
    });

    group('auto-référence', () {
      test('utilise le contexte original pour les expressions auto-référentes',
          () {
        // Arrange - l'expression fait référence au champ lui-même
        final context = {
          'value': {'my_field': true}
        };
        final fieldConfig = {"hidden": "(value) => value['my_field']"};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'my_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert - devrait utiliser le contexte original (auto-référence)
        expect(result, true);
      });
    });

    group('expressions avec comparaison', () {
      test('retourne true quand condition == est satisfaite', () {
        // Arrange
        final context = {
          'value': {'status': 'inactive'}
        };
        final fieldConfig = {
          "hidden": "({value}) => value.status == 'inactive'"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });

      test('retourne false quand condition == n\'est pas satisfaite', () {
        // Arrange
        final context = {
          'value': {'status': 'active'}
        };
        final fieldConfig = {
          "hidden": "({value}) => value.status == 'inactive'"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target_field',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });
    });

    group('cascade-aware context (allFieldsConfig)', () {
      test('évalue correctement avec allFieldsConfig fourni', () {
        // Arrange
        final context = {
          'value': {
            'parent_visible': true,
            'child_field': 'some value',
          }
        };
        final fieldConfig = {"hidden": "(value) => value['parent_visible']"};
        final allFieldsConfig = {
          'parent_visible': <String, dynamic>{},
          'child_field': {
            'hidden': "(value) => value['parent_visible']",
          },
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'child_field',
          context,
          fieldConfig: fieldConfig,
          allFieldsConfig: allFieldsConfig,
        );

        // Assert
        expect(result, true);
      });

      test('fonctionne sans allFieldsConfig (contexte original)', () {
        // Arrange
        final context = {
          'value': {'toggle': true}
        };
        final fieldConfig = {"hidden": "(value) => value['toggle']"};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'some_field',
          context,
          fieldConfig: fieldConfig,
          allFieldsConfig: null,
        );

        // Assert
        expect(result, true);
      });
    });

    group('expressions normalisées', () {
      test('SIMPLE: évalue correctement value[field] simple', () {
        // Arrange - expression qui sera normalisée en NORMALIZED:SIMPLE
        final context = {
          'value': {'toggle_field': true}
        };
        final fieldConfig = {"hidden": "(value) => value['toggle_field']"};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });

      test('NOT: évalue correctement !value[field]', () {
        // Arrange - expression qui sera normalisée en NORMALIZED:NOT
        final context = {
          'value': {'toggle_field': true}
        };
        final fieldConfig = {"hidden": "(value) => !value['toggle_field']"};

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });

      test('AND: évalue correctement field1 && field2', () {
        // Arrange
        final context = {
          'value': {'field_a': true, 'field_b': true}
        };
        final fieldConfig = {
          "hidden":
              "(value) => value['field_a'] && value['field_b']"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, true);
      });

      test('AND: retourne false quand un champ est false', () {
        // Arrange
        final context = {
          'value': {'field_a': true, 'field_b': false}
        };
        final fieldConfig = {
          "hidden":
              "(value) => value['field_a'] && value['field_b']"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });
    });

    group('gestion des erreurs', () {
      test('retourne false quand hidden n\'est pas bool ni string', () {
        // Arrange
        final context = {
          'value': {'field1': 'test'}
        };
        final fieldConfig = {'hidden': 42}; // ni bool ni string

        // Act
        final result = formDataProcessor.isFieldHidden(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });

      test('retourne false quand l\'expression est invalide', () {
        // Arrange
        final context = {
          'value': {'field1': 'test'}
        };
        final fieldConfig = {
          'hidden': '(value) => <<<invalid expression>>>'
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });

      test('retourne false quand le champ référencé n\'existe pas', () {
        // Arrange
        final context = {
          'value': <String, dynamic>{}
        };
        final fieldConfig = {
          "hidden": "(value) => value['nonexistent_field']"
        };

        // Act
        final result = formDataProcessor.isFieldHidden(
          'target',
          context,
          fieldConfig: fieldConfig,
        );

        // Assert
        expect(result, false);
      });
    });
  });

  group('isFieldRequired', () {
    group('sans configuration', () {
      test('retourne false quand fieldConfig est null', () {
        final context = {'value': <String, dynamic>{}};
        final result = formDataProcessor.isFieldRequired('field1', context);
        expect(result, false);
      });
    });

    group('avec valeur booléenne directe', () {
      test('retourne true quand required est true', () {
        final context = {'value': <String, dynamic>{}};
        final fieldConfig = {'required': true};
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, true);
      });

      test('retourne false quand required est false', () {
        final context = {'value': <String, dynamic>{}};
        final fieldConfig = {'required': false};
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, false);
      });
    });

    group('avec expression', () {
      test('retourne true quand l\'expression évalue à true', () {
        final context = {
          'value': {'is_active': true}
        };
        final fieldConfig = {
          'required': "({value}) => value.is_active"
        };
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, true);
      });

      test('retourne false quand l\'expression évalue à false', () {
        final context = {
          'value': {'is_active': false}
        };
        final fieldConfig = {
          'required': "({value}) => value.is_active"
        };
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, false);
      });
    });

    group('avec validations sub-key', () {
      test('retourne true quand validations.required est true', () {
        final context = {'value': <String, dynamic>{}};
        final fieldConfig = {
          'validations': {'required': true}
        };
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, true);
      });

      test('retourne false quand validations.required est false', () {
        final context = {'value': <String, dynamic>{}};
        final fieldConfig = {
          'validations': {'required': false}
        };
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, false);
      });

      test('évalue expression dans validations.required', () {
        final context = {
          'value': {'toggle': true}
        };
        final fieldConfig = {
          'validations': {
            'required': "({value}) => value.toggle"
          }
        };
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, true);
      });
    });

    group('gestion des erreurs', () {
      test('retourne false quand required n\'est ni bool ni expression', () {
        final context = {'value': <String, dynamic>{}};
        final fieldConfig = {'required': 42};
        final result = formDataProcessor.isFieldRequired(
          'field1',
          context,
          fieldConfig: fieldConfig,
        );
        expect(result, false);
      });
    });
  });

  group('prepareEvaluationContext', () {
    test('crée un contexte avec value et meta vide', () {
      // Arrange
      final values = {'field1': 'value1', 'field2': 42};

      // Act
      final result = formDataProcessor.prepareEvaluationContext(values: values);

      // Assert
      expect(result['value'], equals(values));
      expect(result['meta'], equals(<String, dynamic>{}));
    });

    test('inclut les metadata quand elles sont fournies', () {
      // Arrange
      final values = {'field1': 'value1'};
      final metadata = {'moduleCode': 'test_module', 'siteId': 123};

      // Act
      final result = formDataProcessor.prepareEvaluationContext(
        values: values,
        metadata: metadata,
      );

      // Assert
      expect(result['value'], equals(values));
      expect(result['meta'], equals(metadata));
    });

    test('ne modifie pas la map values originale', () {
      // Arrange
      final values = {'field1': 'value1'};
      final originalValues = Map<String, dynamic>.from(values);

      // Act
      final result = formDataProcessor.prepareEvaluationContext(values: values);
      (result['value'] as Map<String, dynamic>)['new_field'] = 'added';

      // Assert - la map originale ne doit pas être modifiée
      expect(values, equals(originalValues));
    });

    test('ne modifie pas la map metadata originale', () {
      // Arrange
      final metadata = {'key': 'val'};
      final originalMeta = Map<String, dynamic>.from(metadata);

      // Act
      final result = formDataProcessor.prepareEvaluationContext(
        values: {},
        metadata: metadata,
      );
      (result['meta'] as Map<String, dynamic>)['new_key'] = 'added';

      // Assert
      expect(metadata, equals(originalMeta));
    });
  });
}
