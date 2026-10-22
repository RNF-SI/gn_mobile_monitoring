import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/change_rule_processor.dart';

/// Règles `change` réelles de https://github.com/PnX-SI/protocoles_suivi,
/// exécutées au format JavaScript d'origine (celui conservé au
/// téléchargement du module depuis l'audit 09/2026).
void main() {
  const popAmphibien = [
    "({objForm, meta}) => {",
    "if (objForm.value.presence === 'Non') {",
    "objForm.patchValue({id_nomenclature_typ_denbr : null, count_min : 0, count_max : 0, id_nomenclature_sex : null, id_nomenclature_stade: null, cd_nom : {'cd_nom': 914450, 'lb_nom': 'Amphibia', 'nom_valide': 'Amphibia', 'nom_vern' : 'Amphibiens, batraciens'}}, {emitEvent : false})",
    "}",
    "if (objForm.value.presence === 'Oui' && objForm.value.count_min === 0) {",
    "objForm.patchValue({count_min : null, count_max : null}, {emitEvent : false})",
    "}",
    "if (!!objForm.value.count_min && objForm.value.count_max < objForm.value.count_min) {",
    "objForm.patchValue({count_max : objForm.value.count_min}, {emitEvent : false})",
    "}",
    "}",
    "",
  ];

  const rhomeoFlore = [
    "({objForm, meta}) => {",
    "const base_site_name = 'T' + (objForm.value.num_transect) + 'Q' + (objForm.value.num_placette);",
    "if (!objForm.controls.base_site_name.dirty) {",
    "objForm.patchValue({base_site_name})",
    "}",
    "}",
    "",
  ];

  ChangeRuleResult run(List<String> rules, Map<String, dynamic> values,
          String trigger, {Set<String> dirty = const {}}) =>
      ChangeRuleProcessor().processChangeRules(
        formValues: values,
        changeConfig: rules,
        triggerFieldName: trigger,
        dirtyFields: dirty,
      );

  group('POPAmphibien (observation)', () {
    test('presence = Non remet les comptages à 0 et fixe le taxon', () {
      final result = run(popAmphibien, {'presence': 'Non'}, 'presence');

      expect(result.fieldsToUpdate['count_min'], 0);
      expect(result.fieldsToUpdate['count_max'], 0);
      expect(result.fieldsToUpdate.containsKey('cd_nom'), isTrue);
    });

    test('!!count_min vaut false quand count_min = 0 (sémantique JS)', () {
      // `!!0` est faux en JavaScript : la règle 3 ne doit pas s'appliquer.
      final result =
          run(popAmphibien, {'count_min': 0, 'count_max': -1}, 'count_max');

      expect(result.fieldsToUpdate.containsKey('count_max'), isFalse);
    });

    test('count_max est relevé au niveau de count_min', () {
      final result = run(popAmphibien,
          {'presence': 'Oui', 'count_min': 5, 'count_max': 2}, 'count_min');

      expect(result.fieldsToUpdate['count_max'], 5);
    });
  });

  group('Expressions de const (sémantique JavaScript)', () {
    test('multiplication, soustraction et repli ||', () {
      const rules = [
        '({objForm, meta}) => {',
        'const surface = objForm.value.longueur * objForm.value.largeur;',
        'const reste = (objForm.value.total || 0) - objForm.value.vus;',
        'objForm.patchValue({surface, reste})',
        '}',
      ];
      final result = run(rules,
          {'longueur': 4, 'largeur': 2.5, 'vus': 3}, 'largeur');

      expect(result.fieldsToUpdate['surface'], 10);
      expect(result.fieldsToUpdate['reste'], -3);
    });
  });

  group('RHOMEOFlore (site)', () {
    test('base_site_name = T<transect>Q<placette>', () {
      final result = run(
          rhomeoFlore, {'num_transect': 3, 'num_placette': 5}, 'num_placette');

      expect(result.fieldsToUpdate['base_site_name'], 'T3Q5');
    });

    test('base_site_name modifié à la main : pas écrasé', () {
      final result = run(
          rhomeoFlore, {'num_transect': 3, 'num_placette': 5}, 'num_placette',
          dirty: {'base_site_name'});

      expect(result.fieldsToUpdate.containsKey('base_site_name'), isFalse);
    });
  });
}
