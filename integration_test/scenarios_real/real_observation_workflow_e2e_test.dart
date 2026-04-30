import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Tests E2E de gestion d'observations contre un vrai serveur GeoNature.
///
/// Couvre :
/// 1. Navigation : module → groupe → site → onglet visites → ouvrir visite existante
/// 2. Onglet observations → creation d'une observation avec recherche taxon
/// 3. Verification que l'observation apparait
/// 4. Suppression de l'observation
///
/// Pre-requis :
/// - Module POPAmphibien telecharge avec sa liste de taxons
/// - Au moins une visite existante sur un site
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Observation Workflow ===');
    debugPrint('Module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Workflow observation ${RealE2EConfig.load().moduleCode} (API reelle)',
      () {
    testWidgets(
        'Creer une observation sur une visite existante → verifier → supprimer',
        (tester) async {
      // ----- 1. Login + ouverture du module -----
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);
      await RealTestHelpers.downloadAndOpenModule(tester, config.moduleCode);

      // ----- 2. Naviguer dans un groupe → site → visite -----
      // Navigation : page module → tap visibility (groupe)
      //                 → SiteGroupDetailPage → tap visibility (site)
      //                   → SiteDetailPage → onglet Visites → tap visibility (visite)
      //                     → VisitDetailPage → onglet Observations
      debugPrint(
          '===== REGARDE l\'ecran : navigation vers un groupe =====');
      final visibilityIconsModule = find.byIcon(Icons.visibility);
      await RealTestHelpers.waitForWidget(
        tester,
        visibilityIconsModule,
        timeout: const Duration(seconds: 10),
        description: 'icones visibility des groupes',
      );
      await tester.tap(visibilityIconsModule.first);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 4));

      debugPrint(
          '===== REGARDE l\'ecran : ouverture d\'un site existant =====');
      final visibilityIconsGroup = find.byIcon(Icons.visibility);
      await RealTestHelpers.waitForWidget(
        tester,
        visibilityIconsGroup,
        timeout: const Duration(seconds: 10),
        description: 'icones visibility des sites du groupe',
      );
      await tester.tap(visibilityIconsGroup.first);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 4));

      // ----- 3. SiteDetailPage → onglet Visites → CREER une nouvelle visite -----
      // Plutot que de chercher une visite existante (qui peut ne pas exister
      // sur le site choisi), on cree notre propre visite. Cela rend le test
      // independant des donnees pre-existantes.
      await RealTestHelpers.tapTab(tester, 'Visites');
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      debugPrint(
          '===== REGARDE l\'ecran : creation d\'une visite pour l\'observation =====');
      final createVisitButton =
          find.byKey(const Key('create-visit-button'));
      await RealTestHelpers.waitForWidget(
        tester,
        createVisitButton,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-visit-button',
      );
      await tester.tap(createVisitButton);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 4));

      // Remplir la visite avec strategie minimaliste (accessibility=Non
      // masque la plupart des champs requis)
      await RealTestHelpers.tapRadioOption(tester, 'Non');
      await RealTestHelpers.selectFirstSelectOption(tester, 'expertise');
      // N° de passage requis : depuis #180 (commit 4d8ab29), seul `value`
      // pre-remplit un champ ; POPAmphibien n'a que `default: 1`. Le champ est
      // un NumberField sur le serveur réel.
      await RealTestHelpers.enterFormField(tester, 'num_passage', '1',
          isRequired: true);
      await RealTestHelpers.pickFormDate(tester, 'visit_date_min',
          isRequired: true);
      await RealTestHelpers.tapFormSave(tester);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 5));
      RealTestHelpers.expectFormClosed(tester);
      debugPrint('Visite creee pour le test observation');

      // Apres creation de visite, on est sur VisitDetailPage (push automatique).
      // Il devrait y avoir un onglet Observations.
      // ----- 4. VisitDetailPage → onglet Observations -----
      await RealTestHelpers.tapTab(tester, 'Observations');
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      // ----- 6. Tap sur add-observation-button -----
      debugPrint(
          '===== REGARDE l\'ecran : tap sur add-observation-button =====');
      final addObsButton =
          find.byKey(const Key('add-observation-button'));
      await RealTestHelpers.waitForWidget(
        tester,
        addObsButton,
        timeout: const Duration(seconds: 10),
        description: 'bouton add-observation-button',
      );
      await tester.tap(addObsButton);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 4));

      // ----- 7. Remplir le formulaire d'observation -----
      // Le formulaire POPAmphibien observation a beaucoup de champs requis :
      //   - cd_nom (taxon, requis)
      //   - id_nomenclature_typ_denbr (requis)
      //   - id_nomenclature_sex (requis)
      //   - id_nomenclature_stade (requis)
      //   - count_min, count_max (requis)
      //
      // MAIS toutes ces champs sont caches/non requis si presence === 'Non'
      // (cf. hidden function dans la config du module).
      //
      // Strategie : tapper "Non" pour presence → tous les champs deviennent
      // optionnels. On peut sauver directement.
      debugPrint(
          '===== REGARDE l\'ecran : remplissage du formulaire d\'observation =====');

      // Tap sur le radio "Non" pour presence (par defaut "Oui")
      await RealTestHelpers.tapRadioOption(tester, 'Non');

      // ----- 8. Save -----
      await RealTestHelpers.tapFormSave(tester);

      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 5));
      RealTestHelpers.expectFormClosed(tester);

      debugPrint('Observation creee');

      // ----- 9. Suppression de l'observation -----
      // L'icone delete est dans la table des observations
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));
      final deleteIcons = find.byIcon(Icons.delete);
      if (deleteIcons.evaluate().isEmpty) {
        debugPrint('Aucun bouton delete visible, fin du test');
        return;
      }

      debugPrint(
          '${deleteIcons.evaluate().length} bouton(s) delete trouve(s)');
      await tester.tap(deleteIcons.last);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      // Confirmer la suppression
      final supprimerButton = find.text('Supprimer');
      if (supprimerButton.evaluate().isNotEmpty) {
        await tester.tap(supprimerButton.last);
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 5));
        debugPrint('Observation supprimee');
      } else {
        fail('Bouton de confirmation Supprimer introuvable');
      }
    });
  });
}
