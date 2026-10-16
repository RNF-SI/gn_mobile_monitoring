import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

import 'real_test_helpers.dart';

/// Remplit les champs obligatoires du formulaire affiché, quel que soit le
/// protocole, pour que les scénarios réels tournent sur n'importe quel module
/// sans cas particulier.
///
/// Le schéma vient de la configuration portée par le [DynamicFormBuilder]
/// affiché, analysée comme le fait l'app ([FormConfigParser]). Un champ est
/// traité s'il est obligatoire à l'écran (clé `<champ>_true`, ou libellé
/// suivi de « * ») et encore vide : les conditions `hidden` / `required` du
/// protocole sont donc celles que voit l'utilisateur.
///
/// Texte, nombre, date, heure et bouton radio sont saisis par l'interface ;
/// liste, nomenclature, case à cocher, datalist et taxon passent par
/// [DynamicFormBuilderState.updateFormValue], avec la valeur que leurs
/// widgets transmettent.
class GenericFormFiller {
  GenericFormFiller._();

  /// Remplit les champs obligatoires vides et renvoie leurs noms. Plusieurs
  /// passes, car une valeur peut rendre d'autres champs obligatoires.
  /// [text] sert aux champs texte (marqueur unique pour retrouver l'objet).
  static Future<List<String>> fillRequiredFields(
    WidgetTester tester, {
    required String moduleCode,
    String text = 'E2E',
  }) async {
    final formFinder = find.byType(DynamicFormBuilder);
    await RealTestHelpers.waitForWidget(tester, formFinder,
        timeout: const Duration(seconds: 10), description: 'formulaire');
    final widget = tester.widget<DynamicFormBuilder>(formFinder);
    final schema = FormConfigParser.generateUnifiedSchema(
      widget.objectConfig,
      widget.customConfig,
      objectType: widget.objectType,
    );

    final filled = <String>[];
    for (var pass = 0; pass < 3; pass++) {
      var changed = false;
      for (final entry in schema.entries) {
        final name = entry.key;
        final config = Map<String, dynamic>.from(entry.value as Map);
        // Préremplis par l'app (utilisateur connecté, jeu de données du
        // module) : pas de saisie à simuler.
        if (_prefilledTypes.contains(config['widget_type'])) continue;
        final state = tester.state<DynamicFormBuilderState>(formFinder);
        if (_hasValue(state.getAllFormValues()[name])) continue;
        if (!_isRequiredOnScreen(name, config)) continue;

        final ok = await _fill(tester, state, name, config,
            moduleCode: moduleCode, text: text);
        if (ok) {
          filled.add('$name (${config['widget_type']})');
          changed = true;
        }
      }
      if (!changed) break;
    }
    debugPrint('Champs obligatoires remplis : $filled');
    return filled;
  }

  static const _prefilledTypes = {
    'ObserverField',
    'CurrentUserField',
    'DatasetSelector',
  };

  static bool _hasValue(Object? value) =>
      value != null &&
      !(value is String && value.isEmpty) &&
      !(value is Iterable && value.isEmpty) &&
      !(value is Map && value.isEmpty);

  static bool _isRequiredOnScreen(String name, Map<String, dynamic> config) {
    if (find.byKey(ValueKey('${name}_true')).evaluate().isNotEmpty) {
      return true;
    }
    final label = config['attribut_label'];
    return label is String && find.text('$label *').evaluate().isNotEmpty;
  }

  static Future<bool> _fill(
    WidgetTester tester,
    DynamicFormBuilderState state,
    String name,
    Map<String, dynamic> config, {
    required String moduleCode,
    required String text,
  }) async {
    switch (config['widget_type']) {
      case 'TextField':
      case 'TextField_multiline':
        await RealTestHelpers.enterFormField(tester, name, text,
            isRequired: true);
        return true;
      case 'NumberField':
        final min = (config['validations'] as Map?)?['min'];
        final value = min is num && min > 1 ? min : 1;
        await RealTestHelpers.enterFormField(tester, name, '$value',
            isRequired: true);
        return true;
      case 'DatePicker':
      case 'TimePicker':
        await RealTestHelpers.pickFormDate(tester, name, isRequired: true);
        return true;
      case 'DropdownButton':
        // Valeur fixée comme le fait la liste (le clic dans le menu est peu
        // fiable) : la valeur de l'option, en texte. La clé du champ dépend
        // de la valeur, il se reconstruit donc avec elle.
        final option = _firstOption(config['values']);
        if (option == null) return _skip(name, 'aucune valeur proposée');
        state.updateFormValue(name, option.value.toString());
        await RealTestHelpers.pumpFor(tester, const Duration(milliseconds: 500));
        return true;
      case 'NomenclatureSelector':
        // Valeur fixée comme le font les sélecteurs (le clic dans la liste
        // est peu fiable quand le clavier est ouvert) : liste d'ids en choix
        // multiple, objet {id, cd_nomenclature, …} sinon. La clé du
        // sélecteur dépend de la valeur, il se reconstruit donc avec elle.
        final typeCode = FormConfigParser.getNomenclatureTypeCode(config);
        if (typeCode == null) return _skip(name, 'type de nomenclature inconnu');
        final n = await _firstNomenclature(typeCode);
        if (n == null) return _skip(name, 'aucune nomenclature $typeCode');
        state.updateFormValue(
            name,
            config['multiple'] == true
                ? [n.id]
                : {
                    'id': n.id,
                    'code_nomenclature_type': typeCode,
                    'cd_nomenclature': n.cdNomenclature,
                    'label': n.labelFr ?? n.labelDefault ?? n.cdNomenclature,
                  });
        await RealTestHelpers.pumpFor(tester, const Duration(milliseconds: 500));
        return true;
      case 'RadioButton':
        final first = _firstOption(config['values']);
        if (first == null) return _skip(name, 'aucune valeur proposée');
        await RealTestHelpers.tapRadioOption(tester, first.label);
        return true;
      case 'Checkbox':
        state.updateFormValue(name, true);
        await RealTestHelpers.pumpFor(tester, const Duration(milliseconds: 500));
        return true;
      case 'DatalistField':
        final first = _firstOption(config['values']);
        if (first == null) return _skip(name, 'aucune valeur statique');
        final multiple = config['multiple'] == true ||
            config['type_widget'] == 'multiselect';
        state.updateFormValue(name, multiple ? [first.value] : first.value);
        await RealTestHelpers.pumpFor(tester, const Duration(milliseconds: 500));
        return true;
      case 'TaxonSelector':
        final cdNom = await _firstTaxon(moduleCode);
        if (cdNom == null) return _skip(name, 'aucun taxon pour le module');
        state.updateFormValue(name, cdNom);
        await RealTestHelpers.pumpFor(tester, const Duration(seconds: 1));
        return true;
      default:
        return _skip(name, 'type ${config['widget_type']} non géré');
    }
  }

  static bool _skip(String name, String reason) {
    debugPrint('Champ obligatoire "$name" non rempli : $reason');
    return false;
  }

  static ({String label, Object value})? _firstOption(Object? values) {
    if (values is! List || values.isEmpty) return null;
    final first = values.first;
    if (first is Map) {
      final value = first['value'] ?? first['id'];
      return (label: '${first['label'] ?? value}', value: value as Object);
    }
    return (label: '$first', value: first as Object);
  }

  static Future<Nomenclature?> _firstNomenclature(String typeCode) async {
    final db = await AppDatabase.getInstance();
    final type = await db.bibNomenclaturesTypesDao
        .getNomenclatureTypeByMnemonique(typeCode);
    if (type == null) return null;
    final nomenclatures = await db.tNomenclaturesDao.getAllNomenclatures();
    final ofType = nomenclatures.where((n) => n.idType == type.idType);
    return ofType.isEmpty ? null : ofType.first;
  }

  static Future<int?> _firstTaxon(String moduleCode) async {
    final db = await AppDatabase.getInstance();
    final module = await db.modulesDao.getModuleByCode(moduleCode);
    if (module == null) return null;
    final idList = await db.modulesDao.getModuleTaxonomyListId(module.id);
    if (idList == null) return null;
    final taxa = await db.taxonDao.getTaxonsByListId(idList);
    return taxa.isEmpty ? null : taxa.first.cdNom;
  }
}
