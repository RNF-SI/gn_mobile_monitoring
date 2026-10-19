import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/module_config_normalizer.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

/// Configs réelles de 6 protocoles servies par le même serveur (monitoring
/// develop, 16/10/2026) : `module_configs/` par la route legacy
/// `/config/<module>`, `module_configs_fields/` par la nouvelle API.
const _protocols = [
  'POPAmphibien',
  'POPReptile',
  'ecrevisses_pattes_blanches',
  'nidif_gypa',
  'stom',
  'suivi_terriers_blaireau_gmb',
];

const _objectTypes = [
  'module',
  'sites_group',
  'site',
  'visit',
  'observation',
  'observation_detail',
];

Map<String, dynamic> _load(String dir, String protocol) =>
    jsonDecode(File('test/fixtures/$dir/$protocol.json').readAsStringSync())
        as Map<String, dynamic>;

void main() {
  group('normalizeModuleConfig sur les configs réelles', () {
    for (final protocol in _protocols) {
      test('$protocol : mêmes generic/specific que la route legacy', () {
        final legacy = _load('module_configs', protocol);
        final normalized =
            normalizeModuleConfig(_load('module_configs_fields', protocol));

        for (final type in _objectTypes) {
          if (legacy[type] is! Map) continue;
          expect(normalized[type]['generic'], legacy[type]['generic'],
              reason: '$type.generic');
          expect(normalized[type]['specific'] ?? {},
              legacy[type]['specific'] ?? {},
              reason: '$type.specific');
        }
        expect(normalized['custom']['__MODULE.TYPES_SITE'],
            legacy['custom']['__MODULE.TYPES_SITE']);
      });

      test('$protocol : même schéma de formulaire que la route legacy', () {
        final legacy = ModuleConfiguration.fromJson(
            _load('module_configs', protocol));
        final normalized = ModuleConfiguration.fromJson(normalizeModuleConfig(
            _load('module_configs_fields', protocol)));

        ObjectConfig? object(ModuleConfiguration c, String type) =>
            switch (type) {
              'sites_group' => c.sitesGroup,
              'site' => c.site,
              'visit' => c.visit,
              'observation' => c.observation,
              'observation_detail' => c.observationDetail,
              _ => null,
            };

        for (final type in _objectTypes.skip(1)) {
          final expected = object(legacy, type);
          if (expected == null) continue;
          expect(
            FormConfigParser.generateUnifiedSchema(
                    object(normalized, type)!, normalized.custom,
                    objectType: type)
                .keys,
            FormConfigParser.generateUnifiedSchema(expected, legacy.custom,
                    objectType: type)
                .keys,
            reason: type,
          );
        }
      });
    }
  });

  group('normalizeModuleConfig', () {
    test('laisse une config legacy intacte', () {
      final legacy = _load('module_configs', 'POPAmphibien');
      expect(normalizeModuleConfig(legacy), same(legacy));
    });

    test('champ hors catalogue → specific, champ du catalogue → generic', () {
      final result = normalizeModuleConfig({
        'visit': {
          'label': 'Visite',
          'fields': {
            'visit_date_min': {'type_widget': 'date'},
            'meteo': {'type_widget': 'text'},
          },
        },
      });

      expect(result['visit']['generic'].keys, ['visit_date_min']);
      expect(result['visit']['specific'].keys, ['meteo']);
      expect(result['visit']['label'], 'Visite');
    });

    test('reconstruit __MODULE.TYPES_SITE depuis module.types_site', () {
      final result = normalizeModuleConfig({
        'custom': {'__MODULE.MODULE_CODE': 'X'},
        'module': {
          'fields': {},
          'types_site': {
            '941': {'name': 'Site'},
          },
        },
      });

      expect(result['custom']['__MODULE.TYPES_SITE'], [
        {'config': null, 'id_nomenclature_type_site': 941},
      ]);
      expect(result['custom']['__MODULE.MODULE_CODE'], 'X');
    });
  });
}
