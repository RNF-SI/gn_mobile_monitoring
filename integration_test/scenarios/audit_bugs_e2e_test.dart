import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/site_form_wrapper.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';

/// Non-régression sur appareil des bugs relevés par l'audit de septembre 2026
/// et corrigés ensuite (voir docs/FEATURES_OVERVIEW.md, « Historique »).
///
/// Chaque test vérifie le comportement du module web GeoNature Monitoring :
/// un échec signifie que le bug est revenu. Les tests « témoin » vérifient
/// que le banc de test fonctionne.
///
/// Chaîne réellement exercée :
/// config JSON au format web GeoNature
///   → ModulesRepository.refreshModuleConfiguration (stockage au téléchargement)
///   → ModuleConfiguration.fromJson
///   → DynamicFormBuilder (saisie via l'UI)
///   → getFormValues / FormDataProcessor.processFormData (chemin d'enregistrement)
///
/// Lancement : scripts/run_device_test.sh integration_test/scenarios/audit_bugs_e2e_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late E2ETestApp testApp;
  late ProviderContainer container;

  setUp(() async {
    testApp = E2ETestApp();
    container = ProviderContainer(overrides: testApp.overrides);

    await testApp.nomenclaturesDatabase.insertNomenclatureTypes(const [
      NomenclatureType(
        idType: 900,
        mnemonique: 'METH_AUDIT',
        labelDefault: "Méthode d'observation",
        labelFr: "Méthode d'observation",
        definitionDefault: '',
        definitionFr: '',
      ),
    ]);
    await testApp.nomenclaturesDatabase.insertNomenclatures(const [
      Nomenclature(
        id: 901,
        idType: 900,
        cdNomenclature: 'VU',
        mnemonique: 'Vu',
        labelDefault: 'Vu',
        labelFr: 'Vu',
        definitionDefault: '',
        definitionFr: '',
        hierarchy: '',
        active: true,
      ),
      Nomenclature(
        id: 902,
        idType: 900,
        cdNomenclature: 'ENT',
        mnemonique: 'Entendu',
        labelDefault: 'Entendu',
        labelFr: 'Entendu',
        definitionDefault: '',
        definitionFr: '',
        hierarchy: '',
        active: true,
      ),
    ]);
  });

  tearDown(() => container.dispose());

  /// Fait passer une config « observation » au format web par le prétraitement
  /// du téléchargement de module, puis la parse comme le fait l'app.
  Future<ObjectConfig> downloadObservationConfig(
      Map<String, dynamic> observation) async {
    final config = <String, dynamic>{'observation': observation};
    await container
        .read(modulesRepositoryProvider)
        .refreshModuleConfiguration(1, config);
    return ModuleConfiguration.fromJson(config).observation!;
  }

  Future<ObjectConfig> downloadConfig(
      String objectType, Map<String, dynamic> objectConfig) async {
    final config = <String, dynamic>{objectType: objectConfig};
    await container
        .read(modulesRepositoryProvider)
        .refreshModuleConfiguration(1, config);
    final parsed = ModuleConfiguration.fromJson(config);
    return switch (objectType) {
      'visit' => parsed.visit!,
      'site' => parsed.site!,
      _ => parsed.observation!,
    };
  }

  Future<DynamicFormBuilderState> pumpForm(
      WidgetTester tester, ObjectConfig objectConfig,
      {String objectType = 'observation',
      Map<String, dynamic>? initialValues}) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: objectConfig,
                objectType: objectType,
                initialValues: initialValues,
              ),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    return tester.state(find.byType(DynamicFormBuilder));
  }

  /// Champ texte/nombre non requis, retrouvé par la clé posée par
  /// DynamicFormBuilder (`<nom du champ>_<requis>`).
  Finder field(String fieldName, {bool required = false}) =>
      find.byKey(ValueKey('${fieldName}_$required'));

  bool isShown(String label) =>
      find.textContaining(label).evaluate().isNotEmpty;

  group('Bug 1 — nomenclatures multiples id_nomenclature_*', () {
    testWidgets(
        'une sélection multiple survit au traitement avant enregistrement',
        (tester) async {
      final config = await downloadObservationConfig({
        'specific': {
          'id_nomenclature_meth_audit': {
            'type_widget': 'nomenclature',
            'attribut_label': 'Méthodes',
            'code_nomenclature_type': 'METH_AUDIT',
            'multiple': true,
          },
        },
      });
      final form = await pumpForm(tester, config);

      await tester.tap(find.text('Vu'));
      await settle(tester);
      await tester.tap(find.text('Entendu'));
      await settle(tester);

      final values = form.getFormValues();
      expect(values['id_nomenclature_meth_audit'], containsAll([901, 902]),
          reason: 'Témoin : le formulaire doit produire la liste des IDs');

      // Même appel que ObservationsViewModel avant l'enregistrement local.
      final processed =
          await container.read(formDataProcessorProvider).processFormData(values);
      expect(processed['id_nomenclature_meth_audit'], containsAll([901, 902]),
          reason: 'BUG 1 : FormDataProcessor supprime les listes sur les '
              'champs id_nomenclature_* (form_data_processor.dart:149)');
    });
  });

  group('Bugs 2-4 — expressions hidden après téléchargement', () {
    testWidgets('Témoin : comparaison simple', (tester) async {
      final config = await downloadObservationConfig({
        'specific': {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Présence',
            'values': ['Oui', 'Non'],
          },
          'cible': {
            'type_widget': 'text',
            'attribut_label': 'Champ cible',
            'hidden': "({value}) => value.presence === 'Non'",
          },
        },
      });
      await pumpForm(tester, config);
      expect(isShown('Champ cible'), isTrue);

      await tester.tap(find.text('Non'));
      await settle(tester);
      expect(isShown('Champ cible'), isFalse,
          reason: 'Témoin : presence = Non doit masquer le champ');
    });

    testWidgets("Bug 2 : `value.a || value.b` masque dès qu'un champ est rempli",
        (tester) async {
      final config = await downloadObservationConfig({
        'specific': {
          'champ_a': {'type_widget': 'text', 'attribut_label': 'Champ A'},
          'champ_b': {'type_widget': 'text', 'attribut_label': 'Champ B'},
          'cible': {
            'type_widget': 'text',
            'attribut_label': 'Champ cible',
            'hidden': '({value}) => value.champ_a || value.champ_b',
          },
        },
      });
      await pumpForm(tester, config);
      expect(isShown('Champ cible'), isTrue,
          reason: 'Témoin : A et B vides, le champ est visible');

      await tester.enterText(field('champ_a'), 'x');
      await settle(tester);
      expect(isShown('Champ cible'), isFalse,
          reason: 'BUG 2 : après conversion en value[\'a\'] || value[\'b\'], '
              "l'expression est lue comme un seul accès et vaut false "
              '(hidden_expression_evaluator.dart:159)');
    });

    testWidgets("Bug 3 : `&&` avec comparaisons dans un hidden",
        (tester) async {
      final config = await downloadObservationConfig({
        'specific': {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Présence',
            'values': ['Oui', 'Non'],
          },
          'nombre': {'type_widget': 'number', 'attribut_label': 'Nombre'},
          'cible': {
            'type_widget': 'text',
            'attribut_label': 'Champ cible',
            'hidden':
                "({value}) => value.presence === 'Oui' && value.nombre > 0",
          },
        },
      });
      await pumpForm(tester, config);

      await tester.tap(find.text('Oui'));
      await settle(tester);
      await tester.enterText(field('nombre'), '3');
      await settle(tester);
      expect(isShown('Champ cible'), isFalse,
          reason: "BUG 3 : presence = Oui et nombre = 3 → doit être masqué ; "
              "la normalisation des hidden avec && ignore les comparaisons");
    });

    testWidgets('Bug 4a : `> 5` sur un champ vide ne doit pas masquer',
        (tester) async {
      final config = await downloadObservationConfig({
        'specific': {
          'nombre': {'type_widget': 'number', 'attribut_label': 'Nombre'},
          'cible': {
            'type_widget': 'text',
            'attribut_label': 'Champ cible',
            'hidden': '({value}) => value.nombre > 5',
          },
        },
      });
      await pumpForm(tester, config);
      expect(isShown('Champ cible'), isTrue,
          reason: 'BUG 4 : nombre vide → `nombre > 5` est faux en JS, '
              'le champ doit rester visible');
    });

    testWidgets('Bug 4b : soustraction non supportée ne doit pas masquer',
        (tester) async {
      final config = await downloadObservationConfig({
        'specific': {
          'champ_a': {'type_widget': 'number', 'attribut_label': 'Champ A'},
          'champ_b': {'type_widget': 'number', 'attribut_label': 'Champ B'},
          'cible': {
            'type_widget': 'text',
            'attribut_label': 'Champ cible',
            'hidden': '({value}) => value.champ_a - value.champ_b > 10',
          },
        },
      });
      await pumpForm(tester, config);

      await tester.enterText(field('champ_a'), '3');
      await settle(tester);
      await tester.enterText(field('champ_b'), '1');
      await settle(tester);
      expect(isShown('Champ cible'), isTrue,
          reason: 'BUG 4 : 3 - 1 > 10 est faux, le champ doit rester visible '
              "(un opérande non reconnu rend la comparaison toujours vraie)");
    });
  });

  group('Bug 5 — règles change contenant un if', () {
    Map<String, dynamic> specific() => {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Présence',
            'values': ['Oui', 'Non'],
          },
          'remarque': {'type_widget': 'text', 'attribut_label': 'Remarque'},
          'auto': {'type_widget': 'text', 'attribut_label': 'Champ auto'},
        };

    testWidgets('Témoin : patchValue sans if est appliqué', (tester) async {
      final config = await downloadObservationConfig({
        'specific': specific(),
        'change': [
          '({objForm}) => {',
          "  objForm.patchValue({auto: 'rempli'})",
          '}',
        ],
      });
      final form = await pumpForm(tester, config);

      await tester.enterText(field('remarque'), 'test');
      await settle(tester);
      expect(form.getFormValues()['auto'], 'rempli',
          reason: 'Témoin : une règle sans if doit être appliquée');
    });

    testWidgets('patchValue hors if conservé quand un if est présent',
        (tester) async {
      final config = await downloadObservationConfig({
        'specific': specific(),
        'change': [
          '({objForm}) => {',
          "  if (objForm.value.presence === 'Non') {",
          "    objForm.patchValue({remarque: 'absent'})",
          '  }',
          "  objForm.patchValue({auto: 'rempli'})",
          '}',
        ],
      });
      final form = await pumpForm(tester, config);

      await tester.enterText(field('remarque'), 'test');
      await settle(tester);
      expect(form.getFormValues()['auto'], 'rempli',
          reason: 'BUG 5 : dès qu\'un if existe, la conversion au '
              'téléchargement ne garde que les patchValue des if '
              '(modules_repository_impl.dart, _convertChangeRulesToStructured)');
    });
  });

  // Extraits copiés tels quels de https://github.com/PnX-SI/protocoles_suivi
  // (origin/master au 25/09/2026). Comportement attendu = celui du web,
  // qui exécute ces expressions en JavaScript natif.
  group('Configs réelles protocoles_suivi', () {
    testWidgets(
        'POPAmphibien visite : « Etat du site » masqué au passage n°2',
        (tester) async {
      final config = await downloadConfig('visit', {
        'specific': {
          'accessibility': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Accessibilité',
            'values': ['Oui', 'Non'],
            'value': 'Oui',
            'default': 'Oui',
          },
          'num_passage': {
            'type_widget': 'number',
            'attribut_label': 'Numéro de passage',
            'required': true,
            'min': 1,
            'max': 10,
            'default': 1,
          },
          'etat_site': {
            'type_widget': 'radio',
            'attribut_label': 'Etat du site',
            'definition': "Cette information n'est à renseigner que pour "
                "le premier passage de l'année.",
            'values': [
              'Site existant',
              'Site nouvellement créé (travaux, etc.)',
            ],
            'required':
                "({value}) => value.accessibility === 'Oui' && (value.num_passage === 1)",
            'hidden':
                "({value}) => value.accessibility === 'Non' || (value.num_passage !== 1)",
          },
        },
      });
      await pumpForm(tester, config, objectType: 'visit');

      await tester.enterText(field('num_passage', required: true), '1');
      await settle(tester);
      expect(isShown('Etat du site'), isTrue,
          reason: 'Témoin : passage 1 → le champ est demandé');

      await tester.enterText(field('num_passage', required: true), '2');
      await settle(tester);
      expect(isShown('Etat du site'), isFalse,
          reason: 'Passage 2 → le web masque le champ ; la parenthèse '
              '`(value.num_passage !== 1)` n\'est pas évaluée par l\'app');
    });

    testWidgets(
        'pt_ecoute_avifaune visite : relevés de végétation masqués hors passage 2',
        (tester) async {
      final config = await downloadConfig('visit', {
        'specific': {
          'num_passage': {
            'type_widget': 'select',
            'attribut_label': 'N° de passage',
            'values': ['1', '2'],
            'required': true,
          },
          'st_veg_lign_16_32': {
            'attribut_label': 'Recouvrement ligneux 16-32m(%)',
            'type_widget': 'number',
            'min': 0,
            'default': 0,
            'required': '({value}) => value.num_passage == 2',
            'hidden': '({value}) => !(value.num_passage == 2)',
          },
        },
      });
      await pumpForm(tester, config, objectType: 'visit');

      expect(isShown('Recouvrement ligneux 16-32m'), isFalse,
          reason: 'Passage non renseigné → le web masque le champ '
              '(`!( … )` non évalué par l\'app)');
    });

    testWidgets(
        'RHOMEOFlore site : base_site_name calculé par la règle change',
        (tester) async {
      final config = await downloadConfig('site', {
        'specific': {
          'base_site_name': {'hidden': true, 'required': false},
          'num_transect': {
            'type_widget': 'number',
            'attribut_label': 'N° du transect',
            'required': true,
          },
          'num_placette': {
            'type_widget': 'number',
            'attribut_label': 'N° de la placette',
            'required': true,
          },
        },
        'change': [
          '({objForm, meta}) => {',
          "const base_site_name = 'T' + (objForm.value.num_transect) + 'Q' + (objForm.value.num_placette);",
          'if (!objForm.controls.base_site_name.dirty) {',
          'objForm.patchValue({base_site_name})',
          '}',
          '}',
          '',
        ],
      });
      final form = await pumpForm(tester, config, objectType: 'site');

      await tester.enterText(field('num_transect', required: true), '3');
      await settle(tester);
      await tester.enterText(field('num_placette', required: true), '5');
      await settle(tester);
      expect(form.getFormValues()['base_site_name'], 'T3Q5',
          reason: 'Le web nomme le site T<transect>Q<placette> ; la '
              'conversion au téléchargement perd le `const` et la propriété '
              'abrégée (bug 5)');
    });

    // Fork Geomaticien-shf/protocoles_suivi, branche dev/popanomaloglossus.
    testWidgets(
        'popanomaloglossus observation : taxon fixe (champ caché + value) enregistré',
        (tester) async {
      final config = await downloadConfig('observation', {
        'specific': {
          'cd_nom': {
            'type_widget': 'text',
            'attribut_label': 'Nom espèce (latin)',
            'type_util': 'taxonomy',
            'value': 888501,
            'hidden': true,
          },
          'count': {
            'type_widget': 'number',
            'attribut_label': "Nombre d'Anomaloglossus blanci",
            'required': true,
            'hidden': false,
            'min': 0,
          },
        },
      });
      final form = await pumpForm(tester, config);

      await tester.enterText(field('count', required: true), '4');
      await settle(tester);
      final values = form.getFormValues();
      expect(values['count'], 4, reason: 'Témoin : le comptage est saisi');
      expect(values['cd_nom'], 888501,
          reason: 'Le web envoie la value des champs cachés : sans elle, '
              "l'observation part sans espèce");
    });

    // suivi_loutre_SACs_gmb/observation.json : taxon lu en objet
    // (`value.cd_nom.cd_nom`) et `meta.nomenclatures`.
    Map<String, dynamic> loutreObservation() => {
          'specific': {
            'cd_nom': {
              'type_widget': 'taxonomy',
              'attribut_label': 'Taxon',
              'type_util': 'taxonomy',
              'required': true,
            },
            'technique_observation': {
              'type_widget': 'datalist',
              'attribut_label': "Méthode d'observation",
              'api': 'nomenclatures/nomenclature/METH_OBS',
              'keyValue': 'id_nomenclature',
              'keyLabel': 'label_fr',
              'type_util': 'nomenclature',
              'required': true,
            },
            'nombre_individus': {
              'attribut_label': "Nombre d'individus",
              'type_widget': 'number',
              'hidden':
                  "({value, meta}) => (meta.nomenclatures[value.technique_observation] || {}).cd_nomenclature !== '0'",
              'required':
                  "({value, meta}) => (meta.nomenclatures[value.technique_observation] || {}).cd_nomenclature === '0'",
            },
            'nb_epreinte_tot': {
              'type_widget': 'number',
              'attribut_label': "Nombre total d'épreintes",
              'hidden': '({value}) => !(value.cd_nom && value.cd_nom.cd_nom == 60630)',
              'required': '({value}) => value.cd_nom && value.cd_nom.cd_nom == 60630',
            },
          },
        };

    Future<void> seedMethObs() async {
      await testApp.nomenclaturesDatabase.insertNomenclatureTypes(const [
        NomenclatureType(
          idType: 910,
          mnemonique: 'METH_OBS',
          labelDefault: "Méthode d'observation",
          labelFr: "Méthode d'observation",
          definitionDefault: '',
          definitionFr: '',
        ),
      ]);
      await testApp.nomenclaturesDatabase.insertNomenclatures(const [
        Nomenclature(
          id: 911,
          idType: 910,
          cdNomenclature: '0',
          mnemonique: 'Vu',
          labelDefault: 'Vu',
          labelFr: 'Vu',
          definitionDefault: '',
          definitionFr: '',
          hierarchy: '',
          active: true,
        ),
        Nomenclature(
          id: 912,
          idType: 910,
          cdNomenclature: '1',
          mnemonique: 'Entendu',
          labelDefault: 'Entendu',
          labelFr: 'Entendu',
          definitionDefault: '',
          definitionFr: '',
          hierarchy: '',
          active: true,
        ),
      ]);
    }

    testWidgets('suivi_loutre : champs propres à la loutre (taxon en objet)',
        (tester) async {
      final config = await downloadConfig('observation', loutreObservation());
      await pumpForm(tester, config, initialValues: {'cd_nom': 60630});
      expect(isShown("Nombre total d'épreintes"), isTrue,
          reason: 'Loutre (60630) → champ affiché, comme sur le web');
    });

    testWidgets('suivi_loutre : autre taxon → champs loutre masqués',
        (tester) async {
      final config = await downloadConfig('observation', loutreObservation());
      await pumpForm(tester, config, initialValues: {'cd_nom': 1234});
      expect(isShown("Nombre total d'épreintes"), isFalse);
    });

    testWidgets('suivi_loutre : méthode de cd_nomenclature "0" → nombre demandé',
        (tester) async {
      await seedMethObs();
      final config = await downloadConfig('observation', loutreObservation());
      await pumpForm(tester, config,
          initialValues: {'technique_observation': 911});
      expect(isShown("Nombre d'individus"), isTrue);
    });

    testWidgets('suivi_loutre : autre méthode → nombre masqué (meta.nomenclatures)',
        (tester) async {
      await seedMethObs();
      final config = await downloadConfig('observation', loutreObservation());
      await pumpForm(tester, config,
          initialValues: {'technique_observation': 912});
      expect(isShown("Nombre d'individus"), isFalse,
          reason: 'Sans meta.nomenclatures, l\'expression lève une erreur et '
              'le champ reste affiché');
    });

    // suivi_terriers_blaireau_gmb/visit.json — erreur remontée du terrain
    // en v1.1.1 : « type '_Map<String, dynamic>' is not a subtype of type
    // 'num?' in type cast » à l'enregistrement de la visite.
    testWidgets('blaireautière : enregistrement d\'une visite avec méthode',
        (tester) async {
      await testApp.nomenclaturesDatabase.insertNomenclatureTypes(const [
        NomenclatureType(
          idType: 920,
          mnemonique: 'TECHNIQUE_OBS',
          labelDefault: "Technique d'observation",
          labelFr: "Technique d'observation",
          definitionDefault: '',
          definitionFr: '',
        ),
      ]);
      await testApp.nomenclaturesDatabase.insertNomenclatures(const [
        Nomenclature(
          id: 330,
          idType: 920,
          cdNomenclature: '12',
          mnemonique: 'Observation directe',
          labelDefault: 'Observation directe',
          labelFr: 'Observation directe',
          definitionDefault: '',
          definitionFr: '',
          hierarchy: '',
          active: true,
        ),
      ]);
      final config = await downloadConfig('visit', {
        'specific': {
          'id_nomenclature_tech_collect_campanule': {
            'type_widget': 'datalist',
            'attribut_label': "Méthode d'observation",
            'api': 'nomenclatures/nomenclature/TECHNIQUE_OBS',
            'type_util': 'nomenclature',
            'required': false,
          },
          'nb_gueule_act': {
            'type_widget': 'number',
            'attribut_label': 'Nombre de gueules actives',
            'required': true,
          },
        },
      });
      final form = await pumpForm(tester, config, objectType: 'visit');

      await tester.tap(find.byKey(const ValueKey('nomenclature_TECHNIQUE_OBS_null')));
      await settle(tester);
      await tester.tap(find.text('Observation directe').last);
      await settle(tester);
      await tester.enterText(field('nb_gueule_act', required: true), '3');
      await settle(tester);

      final values = {
        ...form.getFormValues(),
        'visit_date_min': '2026-09-25',
      };
      expect(values['id_nomenclature_tech_collect_campanule'], isA<Map>(),
          reason: 'Témoin : le sélecteur stocke un objet {id, cd_nomenclature…}');

      const siteId = TestDataSeeder.testSiteId1;
      const moduleId = TestDataSeeder.testModuleId;
      final viewModel =
          container.read(siteVisitsViewModelProvider((siteId, moduleId)).notifier);
      final visitId = await viewModel.createVisitFromFormData(
          values, const BaseSite(idBaseSite: siteId, baseSiteName: 'Blaireautière'));
      expect(visitId, greaterThan(0),
          reason: 'L\'enregistrement doit aboutir sans erreur de cast');
    });

    // stom/visit.json : widget web `multiselect` (rendu en champ texte avant
    // 09/2026, idem ecrevisses_pattes_blanches et nidif_gypa).
    testWidgets('stom : multiselect en cases à cocher', (tester) async {
      final config = await downloadConfig('visit', {
        'specific': {
          'elem_paysager': {
            'type_widget': 'multiselect',
            'attribut_label': 'Éléments paysagers',
            'values': [
              {'value': 'Bâti', 'label': 'Bâti'},
              {'value': 'Câblage', 'label': 'Câblage'},
              {'value': 'Clôture', 'label': 'Clôture'},
            ],
          },
        },
      });
      final form = await pumpForm(tester, config, objectType: 'visit');

      await tester.tap(find.text('Bâti'));
      await settle(tester);
      await tester.tap(find.text('Clôture'));
      await settle(tester);
      expect(form.getFormValues()['elem_paysager'],
          unorderedEquals(['Bâti', 'Clôture']));
    });

    // petite_chouette_montagne/site.json : sites sous un groupe ou sous le
    // module ; depuis l'onglet Sites, « Groupe de site » (obligatoire) était
    // une liste vide et bloquait l'enregistrement.
    testWidgets('petite_chouette_montagne : groupe de site sélectionnable',
        (tester) async {
      final config = await downloadConfig('site', {
        'specific': {
          'id_sites_group': {
            'type_widget': 'datalist',
            'attribut_label': 'Groupe de site',
            'type_util': 'sites_group',
            'api':
                '__MONITORINGS_PATH/list/__MODULE.MODULE_CODE/sites_group?id_module=__MODULE.ID_MODULE',
            'required': true,
            'hidden': false,
          },
        },
      });
      final form = await pumpForm(
        tester,
        siteConfigWithSitesGroupOptions(config, const [
          SiteGroup(idSitesGroup: 12, sitesGroupName: 'Zone Nord'),
          SiteGroup(idSitesGroup: 13, sitesGroupName: 'Zone Sud'),
        ]),
        objectType: 'site',
      );

      await tester.tap(find.byType(TextField).first);
      await settle(tester);
      await tester.tap(find.text('Zone Sud').last);
      await settle(tester);
      expect(form.getFormValues()['id_sites_group'], '13');
      expect(form.validate(), isTrue);
    });
  });
}

Future<void> settle(WidgetTester tester) => tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 10),
    );
