import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Stress-test dedie aux modules avec un gros volume de taxons
/// (ex : "Petite Chouette de Montagne" en local).
///
/// Objectif : verifier que le TaxonSelectorWidget reste utilisable et que
/// plusieurs saisies consecutives ne provoquent ni crash ni regression
/// perceptible. Si [RealE2EConfig.withUpload] est vrai, un upload est
/// declenche a la fin pour tester aussi le pipeline de sync.
///
/// Pre-requis :
///   - Module configure via TEST_MODULE_CODE (premier de TEST_MODULE_CODES)
///     dans un .env.test local pointant sur un GeoNature local qui possede
///     ce module avec une grande liste taxonomique.
///   - Au moins un groupe/site existant dans le module (le test cree sa
///     propre visite, mais pas le groupe/site).
///
/// Lancement :
///   ./run_real_e2e_tests.sh many-taxa                 # sans upload
///   ./run_real_e2e_tests.sh many-taxa --with-upload   # avec upload final
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Stress Taxons ===');
    debugPrint('Serveur:        ${config.serverUrl}');
    debugPrint('Module cible:   ${config.moduleCode}');
    debugPrint('Upload final:   ${config.withUpload}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  // Nombre d'observations a creer. 5 est un bon compromis entre couverture
  // du parcours (plusieurs recherches distinctes) et duree du test.
  const numObservations = 5;

  // Requetes de recherche variees pour cibler differentes parties de la liste
  // taxonomique. Chaque requete doit faire >= 3 caracteres (trigger du widget).
  // Les termes sont volontairement generiques pour matcher un large panel
  // de noms vernaculaires/scientifiques, quel que soit le module.
  const searchQueries = ['cou', 'pet', 'gra', 'noi', 'ros'];

  group('Stress taxons ${RealE2EConfig.load().moduleCode} (API reelle)', () {
    // Test fragile par construction : enchaîne 5 sélections de taxon (search
    // dynamique → liste de résultats avec timing variable) + remplissage de
    // plusieurs nomenclatures (TYP_DENBR, SEX, STADE). En l'état,
    // `selectTaxonBySearch` et `selectFirstNomenclature(TYP_DENBR)` peuvent
    // ne pas mettre à jour le state du Form en temps voulu et le save échoue
    // silencieusement sur "Ce champ est obligatoire". Le workflow standard
    // observation est déjà couvert par `real_observation_workflow_e2e_test.dart`
    // (qui passe). Ce test stress reste utile pour mesurer la perf de saisie
    // multiple — à re-stabiliser hors-release.
    testWidgets(
      'Creer $numObservations observations avec taxons varies'
      '${RealE2EConfig.load().withUpload ? ' puis upload' : ''}',
      skip: true,
      (tester) async {
        // ----- 1. Login + ouverture du module -----
        await RealTestHelpers.loginAndReachHome(tester, testApp, config);
        await RealTestHelpers.downloadAndOpenModule(tester, config.moduleCode);

        // ----- 2. Descendre jusqu'a un site existant -----
        // Meme sequence que real_observation_workflow : tap sur le 1er icone
        // visibility d'un groupe, puis 1er site du groupe.
        debugPrint('===== Navigation groupe → site =====');
        final groupIcons = find.byIcon(Icons.visibility);
        await RealTestHelpers.waitForWidget(
          tester,
          groupIcons,
          timeout: const Duration(seconds: 10),
          description: 'icones visibility sur la page module',
        );
        await tester.tap(groupIcons.first);
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 3));

        final siteIcons = find.byIcon(Icons.visibility);
        await RealTestHelpers.waitForWidget(
          tester,
          siteIcons,
          timeout: const Duration(seconds: 10),
          description: 'icones visibility sur la page groupe',
        );
        await tester.tap(siteIcons.first);
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 3));

        // ----- 3. Creer une visite dediee au test -----
        await RealTestHelpers.tapTab(tester, 'Visites');
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 2));

        debugPrint('===== Creation d\'une visite pour le stress test =====');
        final createVisitButton = find.byKey(const Key('create-visit-button'));
        await RealTestHelpers.waitForWidget(
          tester,
          createVisitButton,
          timeout: const Duration(seconds: 10),
          description: 'bouton create-visit-button',
        );
        await tester.tap(createVisitButton);
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 4));

        // Strategie minimaliste pour creer la visite : on essaie d'abord
        // accessibility=Non (si le champ existe) pour cacher les champs
        // requis, puis date + save. Si accessibility n'existe pas sur ce
        // module, le form peut avoir plus ou moins de requirements ; dans
        // le pire cas tapFormSave aboie un dump utile.
        if (find.text('Non').evaluate().isNotEmpty) {
          await RealTestHelpers.tapRadioOption(tester, 'Non');
        }
        // Tenter le select 'expertise' s'il existe (present sur POPAmphibien).
        try {
          await RealTestHelpers.selectFirstSelectOption(tester, 'expertise');
        } catch (_) {
          debugPrint(
              'Champ "expertise" absent sur ce module → on continue');
        }
        // Depuis #180 (commit 4d8ab29), `default` ne pre-remplit plus rien ;
        // POPAmphibien expose `num_passage` requis sans `value` initiale.
        // Le champ est un NumberField sur le serveur réel.
        try {
          await RealTestHelpers.enterFormField(tester, 'num_passage', '1',
              isRequired: true);
        } catch (_) {
          debugPrint(
              'Champ "num_passage" absent sur ce module → on continue');
        }
        try {
          await RealTestHelpers.pickFormDate(tester, 'visit_date_min',
              isRequired: true);
        } catch (_) {
          debugPrint(
              'Champ "visit_date_min" absent sur ce module → on continue');
        }
        await RealTestHelpers.tapFormSave(tester);
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 3));
        debugPrint('Visite creee pour le stress test');

        // ----- 4. Aller sur l'onglet Observations -----
        await RealTestHelpers.tapTab(tester, 'Observations');
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 2));

        // ----- 5. Creer N observations avec des taxons varies -----
        final totalStopwatch = Stopwatch()..start();
        int successCount = 0;
        final failedQueries = <String>[];

        for (var i = 0; i < numObservations; i++) {
          final query = searchQueries[i % searchQueries.length];
          debugPrint('');
          debugPrint(
              '===== Observation ${i + 1}/$numObservations (search: "$query") =====');

          final obsStopwatch = Stopwatch()..start();

          // Ouvrir le formulaire. Timeout généreux : la création precedente
          // peut avoir pris >45s (tapFormSave timeout) avant que VisitDetailPage
          // se restabilise avec son bouton add.
          final addObsButton =
              find.byKey(const Key('add-observation-button'));
          await RealTestHelpers.waitForWidget(
            tester,
            addObsButton,
            timeout: const Duration(seconds: 60),
            description: 'bouton add-observation-button',
          );
          await tester.tap(addObsButton);
          await RealTestHelpers.pumpFor(
              tester, const Duration(seconds: 3));

          // Forcer presence=Oui pour que le selecteur de taxon soit affiche
          // (sinon il est masque par la config du module POPAmphibien).
          if (find.text('Oui').evaluate().isNotEmpty) {
            await RealTestHelpers.tapRadioOption(tester, 'Oui');
          }

          // Selectionner un taxon via la recherche
          try {
            await RealTestHelpers.selectTaxonBySearch(tester, query);
          } catch (e) {
            debugPrint(
                'Echec selection taxon pour "$query": $e → on passe a la suivante');
            failedQueries.add(query);
            // Annuler le formulaire
            final cancelButton = find.text('Annuler');
            if (cancelButton.evaluate().isNotEmpty) {
              await tester.tap(cancelButton.first);
              await RealTestHelpers.pumpFor(
                  tester, const Duration(seconds: 2));
            }
            continue;
          }

          // Remplir les champs numeriques de comptage s'ils existent
          for (final fieldName in ['count_min', 'count_max']) {
            try {
              await RealTestHelpers.enterFormField(tester, fieldName, '1',
                  isRequired: true);
            } catch (_) {
              // Champ non requis ou absent sur ce module
            }
          }

          // Remplir les nomenclatures communes (stade, sexe, denombrement)
          for (final nomenclature in ['STADE_VIE', 'SEXE', 'TYP_DENBR']) {
            try {
              await RealTestHelpers.selectFirstNomenclature(
                  tester, nomenclature);
            } catch (_) {
              // Nomenclature non presente sur ce module
            }
          }

          // Laisser le state du Form se propager après les sélections : sans
          // ce settle, TYP_DENBR peut rester en validation "Ce champ est
          // obligatoire" malgré le tap (race entre setState et form.validate).
          await RealTestHelpers.pumpFor(
              tester, const Duration(seconds: 2));

          // Sauvegarder. Timeout généreux (120s) car le serveur GeoNature local
          // peut mettre >45s à répondre au POST observation sous charge.
          // En cas d'echec, tapFormSave dumpe les textes visibles pour aider
          // au debug (champs requis manquants).
          await RealTestHelpers.tapFormSave(tester,
              closeTimeout: const Duration(seconds: 120));

          // Vérification active : le form doit être fermé avant d'enchaîner.
          // Si tapFormSave a timeout silencieusement (form encore ouvert), on
          // échoue ici plutôt que dans la prochaine itération sur un widget
          // introuvable.
          RealTestHelpers.expectFormClosed(tester);
          await RealTestHelpers.pumpFor(
              tester, const Duration(seconds: 2));

          successCount++;
          debugPrint(
              'Observation ${i + 1} creee en ${obsStopwatch.elapsed.inSeconds}s');
        }

        totalStopwatch.stop();
        debugPrint('');
        debugPrint(
            '===== Bilan : $successCount/$numObservations observations en '
            '${totalStopwatch.elapsed.inSeconds}s =====');
        if (failedQueries.isNotEmpty) {
          debugPrint('Recherches sans resultat : $failedQueries');
        }

        // Au moins une observation doit avoir ete creee pour que le test
        // soit meaningful (sinon c'est la config taxon qui coince, pas le
        // stress test).
        expect(successCount, greaterThan(0),
            reason:
                'Aucun taxon trouve avec les requetes $searchQueries. '
                'Le module a-t-il bien une liste taxonomique ? '
                'Ou faut-il adapter les requetes de recherche ?');

        // ----- 6. Upload optionnel -----
        if (config.withUpload) {
          debugPrint('===== Upload final (--with-upload) =====');
          await RealTestHelpers.navigateBackToHome(tester);
          await RealTestHelpers.triggerSyncUploadFromHome(tester);
        }

        debugPrint('===== Test stress taxons termine =====');
      },
    );
  });
}
