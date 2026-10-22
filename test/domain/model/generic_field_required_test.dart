import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';

/// Une condition `required` sur un champ générique doit être conservée et
/// évaluée par le formulaire (issue #206). Cas réel : POPAmphibien, où le
/// taxon est obligatoire si la présence vaut « Oui ».
void main() {
  const presenceOui = "({value}) => value.presence === 'Oui'";

  group('GenericFieldConfig.fromJson — required (#206)', () {
    test('conserve une expression conditionnelle', () {
      final config = GenericFieldConfig.fromJson({'required': presenceOui});
      expect(config.required, presenceOui);
    });

    test('garde les booléens, y compris écrits en texte', () {
      expect(GenericFieldConfig.fromJson({'required': true}).required, true);
      expect(GenericFieldConfig.fromJson({'required': 'true'}).required, true);
      expect(
          GenericFieldConfig.fromJson({'required': 'False'}).required, false);
      expect(GenericFieldConfig.fromJson({}).required, isNull);
    });
  });

  test('le taxon générique est obligatoire seulement si présence = Oui', () {
    final objectConfig = ObjectConfig.fromJson({
      'generic': {
        'cd_nom': {
          'attribut_label': 'Espèce observée',
          'type_widget': 'taxonomy',
          'required': presenceOui,
          'hidden': "({value}) => value.presence === 'Non'",
        },
      },
      'specific': {
        'presence': {
          'attribut_label': 'Présence',
          'type_widget': 'radio',
          'values': ['Oui', 'Non'],
          'value': 'Oui',
          'required': true,
        },
      },
    });
    final schema = FormConfigParser.generateUnifiedSchema(
        objectConfig, null,
        objectType: 'observation');
    final cdNom = Map<String, dynamic>.from(schema['cd_nom'] as Map);
    expect(cdNom['required'], presenceOui);

    final container = ProviderContainer();
    addTearDown(container.dispose);
    final processor = container.read(formDataProcessorProvider);
    bool requiredWith(String presence) => processor.isFieldRequired(
          'cd_nom',
          processor.prepareEvaluationContext(
              values: {'presence': presence}, metadata: {}),
          fieldConfig: cdNom,
        );

    expect(requiredWith('Oui'), isTrue);
    expect(requiredWith('Non'), isFalse);
  });
}
