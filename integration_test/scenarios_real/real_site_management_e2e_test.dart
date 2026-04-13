import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Tests E2E de gestion de sites contre un vrai serveur GeoNature.
///
/// Couvre :
/// 1. Creation d'un site individuel sur le module POPAmphibien
/// 2. Verification que le site cree apparait dans la liste
/// 3. Edition du nom du site (mode edit)
/// 4. Suppression du site (avec confirmation)
///
/// Pre-requis :
/// - Module POPAmphibien telecharge ou telechargeable
/// - Le compte admin a les droits de creation/edition/suppression de sites
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Site Management ===');
    debugPrint('Module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Gestion de sites ${RealE2EConfig.load().moduleCode} (API reelle)',
      () {
    testWidgets('Creer un site → verifier presence → modifier → supprimer',
        (tester) async {
      // ----- 1. Login + ouverture du module -----
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);
      await RealTestHelpers.downloadAndOpenModule(tester, config.moduleCode);

      // Genere un nom unique pour ce test (evite les collisions)
      final siteName = RealTestHelpers.uniqueName('E2E_Site');
      final siteNameUpdated = '${siteName}_modifie';
      debugPrint('Nom du site cree : $siteName');

      // ----- 2. Naviguer vers la page de detail d'un groupe -----
      // POPAmphibien (et tout module avec sites_group) n'a PAS d'onglet Sites
      // au niveau module : la page module affiche directement les groupes via
      // _buildGroupsTab(). Pour creer un site, il faut entrer dans un groupe.
      //
      // Strategie :
      //   a) Si create-site-button est deja visible (module sans groupes),
      //      on tape directement
      //   b) Sinon, on tape sur l'icone visibility (l'oeil) du premier groupe
      //      pour ouvrir SiteGroupDetailPage qui contient create-site-button
      debugPrint(
          '===== REGARDE l\'ecran : recherche du bouton create-site-button =====');
      await RealTestHelpers.pumpFor(
          tester, RealTestHelpers.visualDelay);

      var createButton = find.byKey(const Key('create-site-button'));

      if (createButton.evaluate().isEmpty) {
        debugPrint(
            'Bouton create-site-button absent au niveau module → navigation dans un groupe');

        // Tap sur l'icone visibility (l'oeil) du premier groupe
        final visibilityIcons = find.byIcon(Icons.visibility);
        await RealTestHelpers.waitForWidget(
          tester,
          visibilityIcons,
          timeout: const Duration(seconds: 10),
          description: 'icone visibility d\'un groupe',
        );
        debugPrint(
            '===== REGARDE l\'ecran : tap sur l\'icone visibility du premier groupe =====');
        await tester.tap(visibilityIcons.first);
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 4));

        // Maintenant on est sur SiteGroupDetailPage qui doit contenir create-site-button
        createButton = find.byKey(const Key('create-site-button'));
      }

      await RealTestHelpers.waitForWidget(
        tester,
        createButton,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-site-button',
      );
      debugPrint(
          '===== REGARDE l\'ecran : tap sur create-site-button =====');
      await tester.tap(createButton);
      await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));

      // ----- 3. Remplir le formulaire -----
      // POPAmphibien a 3 champs requis :
      //   - base_site_name (texte) → nom du site
      //   - first_use_date (date) → "Date description *"
      //   - milieu_aquatique (texte) → "Description du milieu aquatique *"
      debugPrint('===== REGARDE l\'ecran : remplissage du formulaire =====');

      // Champ 1 : Nom de site
      await RealTestHelpers.enterFormField(
          tester, 'base_site_name', siteName,
          isRequired: true);

      // Champ 2 : Date (first_use_date) — tap pour ouvrir DatePicker, puis OK
      await RealTestHelpers.pickFormDate(tester, 'first_use_date',
          isRequired: true);

      // Champ 3 : Milieu aquatique (NomenclatureSelector → dropdown)
      // La key du dropdown est 'nomenclature_MILIEU_AQUATIQUE_<value>'
      await RealTestHelpers.selectFirstNomenclature(
          tester, 'MILIEU_AQUATIQUE');

      // Tapper le bouton Enregistrer.
      // tapFormSave fait un polling actif jusqu'a la fermeture du form
      // (45s max) en dismissant les dialogs qui apparaissent entre-temps
      // ("Creer une visite ?" apres save, etc.).
      await RealTestHelpers.tapFormSave(tester);

      // ----- 4. Verifier le retour sur la page de detail -----
      RealTestHelpers.expectFormClosed(tester);

      // ----- 5. Verification : on est deja sur SiteDetailPage -----
      // Apres creation, l'app navigue automatiquement vers SiteDetailPage
      // (cf. _navigateToSiteDetailPage dans site_form_wrapper.dart).
      try {
        await RealTestHelpers.waitForWidget(
          tester,
          find.text(siteName),
          timeout: const Duration(seconds: 30),
          description: 'nom du site sur SiteDetailPage',
        );
      } catch (e) {
        // En cas d'echec, dump les textes visibles pour diagnostic
        final visibleTexts = find
            .byType(Text)
            .evaluate()
            .map((el) => (el.widget as Text).data ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
        debugPrint('--- DIAGNOSTIC : textes visibles a l\'echec ---');
        debugPrint('Textes (${visibleTexts.length}): $visibleTexts');
        debugPrint(
            'AlertDialog present? ${find.byType(AlertDialog).evaluate().isNotEmpty}');
        debugPrint(
            'form-save-button present? ${find.byKey(const Key('form-save-button')).evaluate().isNotEmpty}');
        debugPrint('--- FIN DIAGNOSTIC ---');
        rethrow;
      }
      debugPrint('Site cree visible sur SiteDetailPage');

      // ----- 6. Tap sur edit-site-button -----
      final editButton = find.byKey(const Key('edit-site-button'));
      await RealTestHelpers.waitForWidget(
        tester,
        editButton,
        timeout: const Duration(seconds: 10),
        description: 'bouton edit-site-button',
      );
      await tester.tap(editButton);
      await RealTestHelpers.pumpFor(tester, const Duration(seconds: 3));

      // ----- 7. Modifier le nom -----
      await RealTestHelpers.enterFormField(
          tester, 'base_site_name', siteNameUpdated,
          isRequired: true);
      await RealTestHelpers.tapFormSave(tester);
      // tapFormSave fait deja le polling actif, pas besoin de pumpFor apres

      debugPrint('Site modifie');

      // ----- 8. Re-ouvrir l'edit pour acceder au bouton delete -----
      // Apres save d'un edit, on peut etre soit sur SiteDetailPage soit
      // retour sur la liste. On cherche le bouton edit pour rouvrir le form.
      final editButton2 = find.byKey(const Key('edit-site-button'));
      if (editButton2.evaluate().isEmpty) {
        // On est probablement revenu sur la liste → re-naviguer
        debugPrint('Retour sur liste detecte, re-navigation...');
        final updatedNameInList = find.text(siteNameUpdated);
        if (updatedNameInList.evaluate().isNotEmpty) {
          await tester.tap(updatedNameInList.first);
          await RealTestHelpers.pumpFor(
              tester, const Duration(seconds: 3));
        }
      }

      // Maintenant on doit voir le bouton edit
      await RealTestHelpers.waitForWidget(
        tester,
        find.byKey(const Key('edit-site-button')),
        timeout: const Duration(seconds: 10),
        description: 'edit button pour suppression',
      );
      await tester.tap(find.byKey(const Key('edit-site-button')));
      await RealTestHelpers.pumpFor(tester, const Duration(seconds: 3));

      // ----- 9. Tap sur le bouton delete (icon dans l'AppBar) -----
      // Le bouton delete est un IconButton(icon: Icons.delete) sans Key
      // dans l'AppBar du form en mode edit.
      final deleteIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.delete),
      );
      await RealTestHelpers.waitForWidget(
        tester,
        deleteIcon,
        timeout: const Duration(seconds: 10),
        description: 'icon delete dans AppBar',
      );
      await tester.tap(deleteIcon);
      await RealTestHelpers.pumpFor(tester, const Duration(seconds: 2));

      // ----- 10. Confirmer la suppression -----
      // Dialog : "Confirmer la suppression" avec bouton "Supprimer"
      final confirmDeleteButton = find.widgetWithText(ElevatedButton, 'Supprimer');
      if (confirmDeleteButton.evaluate().isEmpty) {
        // Fallback : tout bouton avec texte "Supprimer"
        final fallback = find.text('Supprimer');
        expect(fallback, findsWidgets,
            reason: 'Bouton de confirmation Supprimer introuvable');
        await tester.tap(fallback.last);
      } else {
        await tester.tap(confirmDeleteButton);
      }
      await RealTestHelpers.pumpFor(tester, const Duration(seconds: 5));

      debugPrint('Site supprime');

      // ----- 11. Verifier que le site n'est plus dans la liste -----
      // Apres delete, le form se ferme et on revient sur SiteDetailPage qui
      // affiche encore le site supprime (cache). Pour verifier la suppression
      // on revient sur SiteGroupDetailPage via la fleche de navigation.
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 3));

      // Pop la SiteDetailPage stale pour revenir sur SiteGroupDetailPage
      final backButton = find.byTooltip('Back');
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
      } else {
        // Fallback : icone arrow_back
        final arrowBack = find.byIcon(Icons.arrow_back);
        if (arrowBack.evaluate().isNotEmpty) {
          await tester.tap(arrowBack.first);
        }
      }
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 3));

      // Maintenant on devrait etre sur SiteGroupDetailPage. Verifier que le
      // site supprime n'est plus dans la liste des sites du groupe.
      // Note : le nom peut encore apparaitre dans le breadcrumb, donc on
      // verifie qu'il n'y a plus AUCUN ExpansionTile contenant ce nom.
      final stillInExpansionTile = find.ancestor(
        of: find.text(siteNameUpdated),
        matching: find.byType(ExpansionTile),
      );
      expect(
        stillInExpansionTile,
        findsNothing,
        reason:
            'Le site supprime ne devrait plus etre dans la liste (ExpansionTile)',
      );
      debugPrint(
          'Site bien absent de la liste des sites apres suppression');
    });
  });
}

