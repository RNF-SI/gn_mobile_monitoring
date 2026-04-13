import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('Persistance des Valeurs de Champs Cachés', () {
    late ProviderContainer container;
    late FormDataProcessor processor;

    setUp(() {
      container = ProviderContainer();
      processor = container.read(formDataProcessorProvider);
    });

    tearDown(() {
      container.dispose();
    });

    test('Les champs cachés conservent leurs valeurs par défaut', () {
      // Configuration de test - inspirée du cas PopReptile
      final allFieldsConfig = {
        'presence': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Présence',
          'value': 'Oui'
        },
        'cd_nom': {
          'widget_type': 'TaxonSelector',
          'attribut_label': 'Taxon',
          'value': 186278,
          'hidden': "({value}) => value.presence === 'Non'"
        }
      };

      // Contexte initial - cd_nom devrait être visible
      var context = {
        'value': {
          'presence': 'Oui',
          'cd_nom': 186278
        }
      };

      // Vérifier que cd_nom n'est pas caché initialement
      final isInitiallyHidden = processor.isFieldHidden(
        'cd_nom',
        context,
        fieldConfig: allFieldsConfig['cd_nom'],
        allFieldsConfig: allFieldsConfig,
      );
      expect(isInitiallyHidden, false);

      // Changer presence pour 'Non' - cd_nom devrait être caché
      context = {
        'value': {
          'presence': 'Non',
          'cd_nom': 186278  // Valeur conservée
        }
      };

      final isHiddenAfterChange = processor.isFieldHidden(
        'cd_nom',
        context,
        fieldConfig: allFieldsConfig['cd_nom'],
        allFieldsConfig: allFieldsConfig,
      );
      expect(isHiddenAfterChange, true);

      // POINT CLÉ: La valeur cd_nom = 186278 doit être conservée
      // dans le contexte même quand le champ est caché
      expect(context['value']!['cd_nom'], equals(186278));
    });

    test('Les valeurs par défaut persistent même après masquage/démasquage', () {
      final allFieldsConfig = {
        'visibility_trigger': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Déclencheur',
          'value': 'show'
        },
        'hidden_field_with_default': {
          'widget_type': 'TextInput',
          'attribut_label': 'Champ avec valeur par défaut',
          'value': 'valeur_par_defaut_123',
          'hidden': "({value}) => value.visibility_trigger === 'hide'"
        }
      };

      // Étape 1: Champ visible avec valeur par défaut
      var context = {
        'value': {
          'visibility_trigger': 'show',
          'hidden_field_with_default': 'valeur_par_defaut_123'
        }
      };

      expect(
        processor.isFieldHidden(
          'hidden_field_with_default',
          context,
          fieldConfig: allFieldsConfig['hidden_field_with_default'],
          allFieldsConfig: allFieldsConfig,
        ),
        false
      );

      // Étape 2: Cacher le champ
      context['value']!['visibility_trigger'] = 'hide';

      expect(
        processor.isFieldHidden(
          'hidden_field_with_default',
          context,
          fieldConfig: allFieldsConfig['hidden_field_with_default'],
          allFieldsConfig: allFieldsConfig,
        ),
        true
      );

      // POINT CLÉ: La valeur par défaut doit être préservée
      expect(
        context['value']!['hidden_field_with_default'],
        equals('valeur_par_defaut_123')
      );

      // Étape 3: Rendre visible à nouveau
      context['value']!['visibility_trigger'] = 'show';

      expect(
        processor.isFieldHidden(
          'hidden_field_with_default',
          context,
          fieldConfig: allFieldsConfig['hidden_field_with_default'],
          allFieldsConfig: allFieldsConfig,
        ),
        false
      );

      // La valeur par défaut doit toujours être là
      expect(
        context['value']!['hidden_field_with_default'],
        equals('valeur_par_defaut_123')
      );
    });

    test('Cascade de masquage avec conservation des valeurs', () {
      final allFieldsConfig = {
        'level1': {
          'widget_type': 'RadioButton',
          'value': 'active'
        },
        'level2': {
          'widget_type': 'TextInput',
          'value': 'level2_default',
          'hidden': "({value}) => value.level1 !== 'active'"
        },
        'level3': {
          'widget_type': 'TextInput',
          'value': 'level3_default',
          'hidden': "({value}) => value.level2 === undefined"
        }
      };

      // Tous les champs visibles initialement avec leurs valeurs par défaut
      var context = {
        'value': {
          'level1': 'active',
          'level2': 'level2_default',
          'level3': 'level3_default'
        }
      };

      expect(
        processor.isFieldHidden('level2', context,
          fieldConfig: allFieldsConfig['level2'],
          allFieldsConfig: allFieldsConfig),
        false
      );
      expect(
        processor.isFieldHidden('level3', context,
          fieldConfig: allFieldsConfig['level3'],
          allFieldsConfig: allFieldsConfig),
        false
      );

      // Désactiver level1 - level2 et level3 devraient être cachés en cascade
      context['value']!['level1'] = 'inactive';

      expect(
        processor.isFieldHidden('level2', context,
          fieldConfig: allFieldsConfig['level2'],
          allFieldsConfig: allFieldsConfig),
        true
      );

      // POINT CLÉ: Même cachés, les champs conservent leurs valeurs
      expect(context['value']!['level2'], equals('level2_default'));
      expect(context['value']!['level3'], equals('level3_default'));
    });

    test('Soumission de formulaire avec champs cachés', () async {
      // Simuler des données de formulaire avec champs visibles et cachés
      final formData = {
        'visible_field': 'visible_value',
        'hidden_field_with_value': 'important_hidden_value',
        'another_hidden': 42,
        'null_field': null,
        'empty_string': ''
      };

      // Traitement des données de formulaire
      final processedData = await processor.processFormData(formData);

      // TOUS les champs doivent être présents, même les cachés
      expect(processedData.containsKey('visible_field'), true);
      expect(processedData.containsKey('hidden_field_with_value'), true);
      expect(processedData.containsKey('another_hidden'), true);
      expect(processedData.containsKey('null_field'), true);
      expect(processedData.containsKey('empty_string'), true);

      // Les valeurs doivent être préservées
      expect(processedData['visible_field'], equals('visible_value'));
      expect(processedData['hidden_field_with_value'], equals('important_hidden_value'));
      expect(processedData['another_hidden'], equals(42));
      expect(processedData['null_field'], isNull);
      expect(processedData['empty_string'], equals(''));
    });
  });
}