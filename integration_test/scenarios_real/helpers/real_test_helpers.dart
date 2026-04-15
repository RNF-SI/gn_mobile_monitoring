import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../e2e_test_app_real.dart';
import '../../robots/login_robot.dart';

/// Helpers partages pour tous les scenarios E2E reels.
///
/// Ces helpers gerent les particularites de l'API reelle :
/// - Sync automatique post-login (ModalBarrier qui bloque les taps)
/// - Dialogs bloquants (AppUpdateDialog, etc.)
/// - Retries tolerants pour les operations sensibles a la latence reseau
class RealTestHelpers {
  RealTestHelpers._();

  /// Pompe des frames jusqu'a ce que la HomePage soit visible ou timeout.
  static Future<void> waitForNavigation(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 200));
      if (find.text('Mes Modules').evaluate().isNotEmpty) {
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
        return;
      }
    }
    fail('Navigation vers HomePage non completee apres $timeout');
  }

  /// Attend que la synchronisation automatique post-login soit terminee.
  /// La HomePage affiche un ModalBarrier (key: sync-modal-barrier) pendant
  /// la sync qui bloque tous les taps. On attend qu'il disparaisse.
  static Future<void> waitForSyncToFinish(
    WidgetTester tester, {
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final stopwatch = Stopwatch()..start();
    final barrierFinder = find.byKey(const Key('sync-modal-barrier'));

    // Donner le temps a la sync de demarrer
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }

    while (stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 500));
      if (barrierFinder.evaluate().isEmpty) {
        // Le barrier a disparu, sync terminee
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
        debugPrint('Sync terminee apres ${stopwatch.elapsed.inSeconds}s');
        return;
      }
    }
    fail('Synchronisation non terminee apres $timeout');
  }

  /// Tente de fermer UN dialog bloquant s'il est present dans le tree
  /// au moment de l'appel. Retourne true si un dialog a ete ferme.
  ///
  /// Cas connus :
  ///   - AppUpdateDialog ("Mise a jour disponible") → bouton "Plus tard"
  ///   - AskForVisit ("Creer une visite ?") apres creation site → bouton "Non"
  ///   - AskForObservation ("Creer une observation ?") apres creation visite → bouton "Non"
  ///   - AlertDialog generique → bouton OK/Fermer/Annuler/Plus tard/Non
  static Future<bool> _tryDismissOneDialog(WidgetTester tester) async {
    // 1. AppUpdateDialog
    if (find.text('Mise à jour disponible').evaluate().isNotEmpty) {
      final laterButton = find.text('Plus tard');
      if (laterButton.evaluate().isNotEmpty) {
        debugPrint('AppUpdateDialog detecte → fermeture via "Plus tard"');
        await tester.tap(laterButton);
        await pumpFor(tester, const Duration(seconds: 1));
        return true;
      }
    }

    // 2. Dialog "Creer une visite ?" → "Non"
    if (find.text('Créer une visite').evaluate().isNotEmpty) {
      final nonButton = find.text('Non');
      if (nonButton.evaluate().isNotEmpty) {
        debugPrint(
            'Dialog "Creer une visite ?" detecte → fermeture via "Non"');
        await tester.tap(nonButton.first);
        await pumpFor(tester, const Duration(seconds: 1));
        return true;
      }
    }

    // 3. Dialog "Creer une observation ?" → "Non"
    if (find.text('Créer une observation').evaluate().isNotEmpty) {
      final nonButton = find.text('Non');
      if (nonButton.evaluate().isNotEmpty) {
        debugPrint(
            'Dialog "Creer une observation ?" detecte → fermeture via "Non"');
        await tester.tap(nonButton.first);
        await pumpFor(tester, const Duration(seconds: 1));
        return true;
      }
    }

    // 4. Tout autre AlertDialog avec un bouton OK/Fermer/Annuler
    if (find.byType(AlertDialog).evaluate().isNotEmpty) {
      for (final btnText in ['OK', 'Fermer', 'Annuler', 'Plus tard', 'Non']) {
        final btn = find.text(btnText);
        if (btn.evaluate().isNotEmpty) {
          debugPrint('Dialog generique detecte → fermeture via "$btnText"');
          await tester.tap(btn.first);
          await pumpFor(tester, const Duration(seconds: 1));
          return true;
        }
      }
    }

    return false;
  }

  /// Ferme tout dialog bloquant (AppUpdateDialog, "Créer une visite ?",
  /// "Créer une observation ?", AlertDialog generique).
  ///
  /// Mode **polling actif** : boucle pendant [timeout] en dismissant chaque
  /// dialog trouve. Le dialog peut apparaitre tardivement (apres un appel API
  /// lent) donc on retry activement au lieu d'une tentative unique.
  ///
  /// Retourne quand aucun dialog n'est plus visible pendant au moins 1 seconde
  /// (stabilisation), ou quand le timeout est atteint.
  static Future<void> dismissBlockingDialogs(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final stopwatch = Stopwatch()..start();
    int consecutiveCleanChecks = 0;

    while (stopwatch.elapsed < timeout) {
      final dismissed = await _tryDismissOneDialog(tester);
      if (dismissed) {
        consecutiveCleanChecks = 0;
      } else {
        consecutiveCleanChecks++;
        // 3 checks consecutifs sans dialog = stable → on sort
        if (consecutiveCleanChecks >= 3) {
          return;
        }
      }
      await pumpFor(tester, const Duration(milliseconds: 300));
    }
  }

  /// Attend activement qu'un formulaire se ferme apres save, tout en
  /// dismissant les dialogs qui peuvent apparaitre entre-temps.
  ///
  /// Boucle pendant [timeout] :
  ///   - Si form-save-button n'est plus dans le tree → succes
  ///   - Sinon si un dialog bloquant est present → on le ferme
  ///   - Sinon on attend et retry
  ///
  /// Couvre le cas typique : apres save, l'app affiche un dialog
  /// ("Creer une visite ?" par ex.) avec un timing variable. On ne sait pas
  /// exactement quand il apparaitra, donc on retry activement.
  static Future<void> _waitForFormClosedOrDismiss(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 45),
  }) async {
    final stopwatch = Stopwatch()..start();
    final saveButtonFinder = find.byKey(const Key('form-save-button'));

    while (stopwatch.elapsed < timeout) {
      // 1. Un dialog bloquant est-il present ? → le fermer en priorite
      final dismissed = await _tryDismissOneDialog(tester);
      if (dismissed) {
        continue; // re-check du cote form apres dismiss
      }

      // 2. Le form a-t-il disparu ?
      if (saveButtonFinder.evaluate().isEmpty) {
        // Stabilisation plus longue : les transitions de navigation
        // (pop form → pushReplacement group → push detail) peuvent
        // encore etre en cours. On attend 5s et on re-check qu'il n'y
        // a pas de dialog qui reapparait.
        await pumpFor(tester, const Duration(seconds: 5));

        // Dernier check dialog au cas ou
        await _tryDismissOneDialog(tester);
        await pumpFor(tester, const Duration(milliseconds: 500));

        if (saveButtonFinder.evaluate().isEmpty) {
          return;
        }
      }

      await pumpFor(tester, const Duration(milliseconds: 500));
    }

    debugPrint(
        '[tapFormSave] Timeout: form toujours ouvert apres ${timeout.inSeconds}s');
  }

  /// Login complet : ouvre l'app, saisit les credentials, attend la HomePage,
  /// attend la fin de la sync auto, ferme les dialogs eventuels.
  static Future<void> loginAndReachHome(
    WidgetTester tester,
    RealE2ETestApp testApp,
    RealE2EConfig config,
  ) async {
    await tester.pumpWidget(testApp.buildProviderScope());
    await tester.pumpAndSettle();

    debugPrint('===== REGARDE l\'ecran : page de login =====');
    await pumpFor(tester, visualDelay);

    final loginRobot = LoginRobot(tester);
    loginRobot.expectLoginPageVisible();

    debugPrint('===== Saisie des credentials et tap sur "Se connecter" =====');
    await loginRobot.login(
      apiUrl: config.serverUrl,
      identifiant: config.username,
      password: config.password,
    );

    await waitForNavigation(tester, timeout: const Duration(seconds: 30));
    debugPrint('===== HomePage atteinte, sync auto en cours =====');
    await waitForSyncToFinish(tester, timeout: const Duration(minutes: 5));
    await dismissBlockingDialogs(tester);
    debugPrint('===== Sync terminee, HomePage prete =====');
    await pumpFor(tester, visualDelay);
  }

  /// Ouvre le menu burger et tape sur "Deconnexion".
  /// Tolere les retries au cas ou le menu n'est pas immediatement disponible.
  static Future<void> openMenuAndTapLogout(WidgetTester tester) async {
    const maxAttempts = 10;
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      if (find.byType(AlertDialog).evaluate().isNotEmpty) {
        await dismissBlockingDialogs(tester);
      }

      final menuButton = find.byIcon(Icons.menu);
      if (menuButton.evaluate().isEmpty) {
        debugPrint('Tentative $attempt/$maxAttempts : menu pas trouve');
        for (int i = 0; i < 5; i++) {
          await tester.pump(const Duration(milliseconds: 300));
        }
        continue;
      }

      await tester.tap(menuButton, warnIfMissed: false);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      final logoutItem = find.byKey(const Key('menu-logout'));
      if (logoutItem.evaluate().isNotEmpty) {
        debugPrint('Menu ouvert, tap sur Deconnexion');
        await tester.tap(logoutItem);
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
        return;
      }

      debugPrint(
          'Tentative $attempt/$maxAttempts : menu pas ouvert, retry...');
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 500));
      }
    }
    fail('Impossible d\'ouvrir le menu burger apres $maxAttempts tentatives');
  }

  /// Pompe des frames pendant une duree donnee (utile pour attendre des
  /// operations async qui n'ont pas de signal observable).
  static Future<void> pumpFor(
    WidgetTester tester,
    Duration duration, {
    Duration step = const Duration(milliseconds: 200),
  }) async {
    final iterations = duration.inMilliseconds ~/ step.inMilliseconds;
    for (int i = 0; i < iterations; i++) {
      await tester.pump(step);
    }
  }

  /// Attend qu'un widget apparaisse, avec timeout.
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 15),
    String? description,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 500));
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    fail(
        'Widget non trouve apres $timeout: ${description ?? finder.describeMatch(Plurality.many)}');
  }

  /// Attend qu'un widget disparaisse, avec timeout.
  static Future<void> waitForWidgetGone(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 15),
    String? description,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 500));
      if (finder.evaluate().isEmpty) {
        return;
      }
    }
    fail(
        'Widget toujours present apres $timeout: ${description ?? finder.describeMatch(Plurality.many)}');
  }

  /// Genere un identifiant unique pour les noms de tests
  /// (ex: "E2E_Site_1729012345678")
  static String uniqueName(String prefix) {
    return '${prefix}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Pause visible pour permettre a l'observateur humain de voir ce qui se
  /// passe a l'ecran. Mettre a 0 pour desactiver (CI ou tests rapides).
  static const Duration visualDelay = Duration(seconds: 2);

  /// Cache le clavier mobile et attend que les viewInsets se mettent a jour.
  ///
  /// IMPORTANT : sur les pages de formulaire (BaseFormLayout), le bouton
  /// `form-save-button` est RETIRE du widget tree quand le clavier est visible
  /// (cf. `if (!isKeyboardVisible) _buildActionButtons(context)`).
  /// Il faut donc cacher le clavier APRES une saisie de champ avant de
  /// chercher le bouton save, sinon `find.byKey` ne trouve rien.
  static Future<void> hideKeyboard(WidgetTester tester) async {
    // Defocus le champ courant pour declencher la fermeture du clavier
    FocusManager.instance.primaryFocus?.unfocus();
    // Pomper pour laisser le clavier OS se cacher et viewInsets se mettre a jour
    await pumpFor(tester, const Duration(seconds: 1));
  }

  /// Attend qu'un bouton specifique apparaisse dans une card de module donnee.
  /// Gere le cas ou la card se deplace dans la liste pendant l'attente
  /// (ce qui arrive quand un module change d'etat de telechargement et est
  /// reordonne en haut de la liste par l'app).
  ///
  /// Re-scroll periodiquement vers le haut si la card sort du viewport.
  static Future<void> _waitForButtonInModuleCardWithScroll(
    WidgetTester tester, {
    required Finder moduleCard,
    required Finder Function() targetButton,
    required String moduleCode,
    Duration timeout = const Duration(minutes: 5),
  }) async {
    final stopwatch = Stopwatch()..start();
    DateTime lastScrollAt = DateTime.fromMillisecondsSinceEpoch(0);

    while (stopwatch.elapsed < timeout) {
      await pumpFor(tester, const Duration(milliseconds: 500));

      // 1. Si le bouton cible est present dans la card, on a fini
      if (targetButton().evaluate().isNotEmpty) {
        return;
      }

      // 2. Si la card n'est plus dans le tree (sortie du viewport), scroll up
      // 3. Ou bien si on n'a pas scroll depuis 3s, re-scroll au cas ou
      final shouldScroll = moduleCard.evaluate().isEmpty ||
          DateTime.now().difference(lastScrollAt) >
              const Duration(seconds: 3);

      if (shouldScroll) {
        try {
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, 3000),
          );
          await pumpFor(tester, const Duration(milliseconds: 500));
          lastScrollAt = DateTime.now();
          debugPrint(
              'Scroll vers le haut pour retrouver $moduleCode '
              '(elapsed: ${stopwatch.elapsed.inSeconds}s)');
        } catch (e) {
          debugPrint('Scroll vers le haut a echoue: $e');
        }
      }

      // 4. Si la card est maintenant visible, ensureVisible pour la centrer
      if (moduleCard.evaluate().isNotEmpty) {
        try {
          await tester.ensureVisible(moduleCard);
          await pumpFor(tester, const Duration(milliseconds: 200));
        } catch (_) {}
      }
    }

    fail(
        'Bouton non trouve dans la card de $moduleCode apres $timeout (la card s\'est probablement deplacee dans la liste)');
  }

  /// Telecharge le module si necessaire et l'ouvre.
  /// Apres cette fonction, on est sur la page de detail du module.
  /// Pre-requis : on doit etre sur la HomePage avec la sync terminee.
  ///
  /// IMPORTANT : la recherche du bouton "Telecharger"/"Ouvrir" est scopee
  /// a la card du module cible (via descendant) pour ne pas accidentellement
  /// telecharger un autre module qui apparait avant dans la liste.
  static Future<void> downloadAndOpenModule(
    WidgetTester tester,
    String moduleCode,
  ) async {
    final moduleCardKey = 'module-card-$moduleCode';
    final moduleCard = find.byKey(Key(moduleCardKey));

    // Verifier que la card du module est presente
    await waitForWidget(
      tester,
      moduleCard,
      timeout: const Duration(seconds: 15),
      description: 'card du module $moduleCode',
    );

    // Faire defiler jusqu'a la card si elle n'est pas visible (liste de modules longue)
    debugPrint('===== REGARDE l\'ecran : scroll vers $moduleCode =====');
    await tester.ensureVisible(moduleCard);
    await pumpFor(tester, visualDelay);

    // Recherche scopee a l'INTERIEUR de la card du module cible.
    // Sans ce scoping, find.text('Telecharger').first peut tomber sur un autre
    // module (ex: "Petite chouette de montagne") affiche avant dans la liste.
    Finder downloadButtonInCard() => find.descendant(
          of: moduleCard,
          matching: find.text('Télécharger'),
        );
    Finder openButtonInCard() => find.descendant(
          of: moduleCard,
          matching: find.text('Ouvrir'),
        );

    if (downloadButtonInCard().evaluate().isNotEmpty) {
      // Log de confirmation : on extrait le label du module dans la card cible
      // pour verifier qu'on tape bien sur le bon module.
      final cardLabels = find.descendant(
        of: moduleCard,
        matching: find.byType(Text),
      );
      final labelTexts = cardLabels
          .evaluate()
          .map((e) => (e.widget as Text).data ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      debugPrint(
          'Module $moduleCode → labels visibles dans la card cible: $labelTexts');
      debugPrint(
          '===== REGARDE l\'ecran : tap sur "Telecharger" pour $moduleCode =====');
      await tester.tap(downloadButtonInCard().first);
      await tester.pump();
      await pumpFor(tester, visualDelay);

      // IMPORTANT : pendant le telechargement, l'app reordonne la liste et
      // place le module en cours de telechargement EN HAUT. Le viewport reste
      // a la meme position, donc la card sort du tree (ListView virtualisee).
      // On utilise une boucle qui re-scroll periodiquement vers le haut pour
      // retrouver la card a sa nouvelle position.
      debugPrint(
          '===== Telechargement en cours, scroll periodique vers le haut pour suivre $moduleCode =====');
      await _waitForButtonInModuleCardWithScroll(
        tester,
        moduleCard: moduleCard,
        targetButton: openButtonInCard,
        moduleCode: moduleCode,
        timeout: const Duration(minutes: 5),
      );
      debugPrint('Telechargement de $moduleCode termine');
      await pumpFor(tester, visualDelay);
    } else {
      debugPrint('Module $moduleCode deja telecharge');
    }

    // Tap sur "Ouvrir" SCOPED a la card du module cible
    final openBtn = openButtonInCard();
    expect(openBtn, findsWidgets,
        reason:
            'Le bouton Ouvrir devrait etre visible dans la card de $moduleCode');
    debugPrint('===== REGARDE l\'ecran : tap sur "Ouvrir" =====');
    await tester.tap(openBtn.first);

    // Attendre la navigation hors de la HomePage
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < const Duration(seconds: 30)) {
      await tester.pump(const Duration(milliseconds: 300));
      if (find.text('Mes Modules').evaluate().isEmpty) {
        debugPrint('===== Page de detail du module ouverte =====');
        await pumpFor(tester, visualDelay);
        return;
      }
    }
    fail('Page de detail du module $moduleCode non chargee apres 30s');
  }

  /// Tape sur le premier widget Card de la liste (en supposant que c'est
  /// un site ou un groupe de sites).
  static Future<void> tapFirstListCard(
    WidgetTester tester, {
    int skipFirst = 0,
  }) async {
    final cards = find.byType(Card);
    expect(cards, findsWidgets,
        reason: 'Aucune Card trouvee dans la liste');

    final index = skipFirst < cards.evaluate().length ? skipFirst : 0;
    await tester.tap(cards.at(index));
    await pumpFor(tester, const Duration(seconds: 3));
  }

  // ==========================================================================
  // FORMS HELPERS
  // ==========================================================================
  // Le DynamicFormBuilder utilise des conventions de Keys differentes selon
  // le type de widget :
  //   - TextField/DateField/TimeField : ValueKey('${fieldName}_$required')
  //   - DropdownButton (select) : ValueKey('select_${fieldName}_${value}')
  //   - NomenclatureSelector : ValueKey('nomenclature_${TYPE_CODE}_${value}')
  //
  // De plus :
  //   - Le bouton form-save-button est RETIRE du tree quand le clavier est
  //     visible. Toujours appeler hideKeyboard() apres une saisie.
  //   - Les formulaires demandent souvent plus de champs requis qu'on pense.
  //     En cas d'echec de save (form encore visible), dumper les Texts pour
  //     identifier les champs manquants.

  /// Saisit du texte dans un champ de formulaire dynamique.
  /// Tente plusieurs patterns de Keys (TextField, alt required) avant d'echouer.
  /// Cache automatiquement le clavier apres saisie.
  static Future<void> enterFormField(
    WidgetTester tester,
    String fieldName,
    String value, {
    required bool isRequired,
  }) async {
    final candidateKeys = <String>[
      '${fieldName}_$isRequired',
      '${fieldName}_${!isRequired}',
    ];

    Finder? targetField;
    for (final keyStr in candidateKeys) {
      final f = find.byKey(ValueKey(keyStr));
      if (f.evaluate().isNotEmpty) {
        targetField = f;
        break;
      }
    }

    if (targetField == null) {
      _dumpFormFieldKeys(fieldName, candidateKeys); // Never returns
    }

    await tester.enterText(targetField, value);
    await tester.pump();
    await hideKeyboard(tester);
  }

  /// Selectionne une date dans un champ DatePicker du formulaire.
  /// Tape sur le champ pour ouvrir le picker, puis confirme avec OK.
  static Future<void> pickFormDate(
    WidgetTester tester,
    String fieldName, {
    required bool isRequired,
  }) async {
    Finder field = find.byKey(ValueKey('${fieldName}_$isRequired'));
    if (field.evaluate().isEmpty) {
      field = find.byKey(ValueKey('${fieldName}_${!isRequired}'));
      if (field.evaluate().isEmpty) {
        fail('Champ de date "$fieldName" introuvable');
      }
    }

    await tester.ensureVisible(field);
    await pumpFor(tester, const Duration(milliseconds: 500));
    await tester.tap(field);

    // Attente active : le DatePicker peut mettre du temps a apparaitre
    // (animation + rendu). On attend activement qu'un bouton OK/Confirmer/Valider
    // apparaisse, au lieu d'un pumpFor fixe qui peut rater.
    final stopwatch = Stopwatch()..start();
    const timeout = Duration(seconds: 10);
    while (stopwatch.elapsed < timeout) {
      await pumpFor(tester, const Duration(milliseconds: 300));
      for (final txt in ['OK', 'Confirmer', 'Valider']) {
        final btn = find.text(txt);
        if (btn.evaluate().isNotEmpty) {
          await tester.tap(btn.first);
          await pumpFor(tester, const Duration(seconds: 1));
          return;
        }
      }
    }
    fail('Bouton OK/Confirmer du DatePicker introuvable apres $timeout');
  }

  /// Selectionne le premier item disponible dans un select dropdown standard.
  /// Le DropdownButtonFormField a une key 'select_${fieldName}_${value}'.
  static Future<void> selectFirstSelectOption(
    WidgetTester tester,
    String fieldName,
  ) async {
    return _tapDropdownAndPickFirst(
      tester,
      keyPrefix: 'select_${fieldName}_',
      label: 'select_$fieldName',
    );
  }

  /// Selectionne le premier item disponible dans un NomenclatureSelector.
  /// Le NomenclatureSelector wrappe un DropdownButtonFormField avec key
  /// 'nomenclature_${TYPE_CODE}_${value}'. Tape sur le dropdown pour l'ouvrir,
  /// puis selectionne le premier item disponible (pour passer la validation).
  static Future<void> selectFirstNomenclature(
    WidgetTester tester,
    String typeCode,
  ) async {
    final upperType = typeCode.toUpperCase();
    return _tapDropdownAndPickFirst(
      tester,
      keyPrefix: 'nomenclature_${upperType}_',
      label: 'nomenclature_$upperType',
    );
  }

  /// Helper interne : tape sur un dropdown identifie par prefix de key
  /// et selectionne le premier item disponible.
  static Future<void> _tapDropdownAndPickFirst(
    WidgetTester tester, {
    required String keyPrefix,
    required String label,
  }) async {
    final dropdown = find.byWidgetPredicate((w) {
      if (w.key is! ValueKey) return false;
      final keyValue = (w.key as ValueKey).value;
      return keyValue is String && keyValue.startsWith(keyPrefix);
    });

    if (dropdown.evaluate().isEmpty) {
      fail('Dropdown "$label" introuvable (key prefix: $keyPrefix)');
    }

    await tester.ensureVisible(dropdown.first);
    await pumpFor(tester, const Duration(milliseconds: 500));
    debugPrint('Tap sur le dropdown $label pour l\'ouvrir');
    await tester.tap(dropdown.first);
    await pumpFor(tester, const Duration(seconds: 2));

    final items = find.byWidgetPredicate(
      (w) => w.runtimeType.toString().startsWith('DropdownMenuItem'),
    );

    if (items.evaluate().isEmpty) {
      fail(
          'Aucun DropdownMenuItem visible apres ouverture du dropdown $label');
    }

    debugPrint(
        '${items.evaluate().length} DropdownMenuItem(s) trouve(s), tap sur le premier');
    // Index 1 si plusieurs items (le 0 est souvent la valeur courante null),
    // sinon 0.
    final itemsCount = items.evaluate().length;
    final indexToTap = itemsCount > 1 ? 1 : 0;

    try {
      await tester.tap(items.at(indexToTap));
    } catch (_) {
      await tester.tap(items.at(indexToTap), warnIfMissed: false);
    }
    await pumpFor(tester, const Duration(seconds: 2));
    debugPrint('Item dropdown selectionne pour $label');
  }

  /// Tape sur une option de radio button identifiee par son label texte
  /// (ex: "Non" pour un radio Oui/Non).
  ///
  /// Le widget Text seul n'est pas tappable. On cherche son ListTile parent
  /// (RadioListTile) ou son InkWell parent qui sont les vrais widgets cliquables.
  ///
  /// IMPORTANT : suppose que le label radio est unique dans la zone du form.
  /// Si plusieurs textes correspondent, on prend le premier.
  static Future<void> tapRadioOption(
    WidgetTester tester,
    String radioLabel,
  ) async {
    final textFinder = find.text(radioLabel);
    if (textFinder.evaluate().isEmpty) {
      fail('Radio "$radioLabel" introuvable');
    }

    // Strategie 1 : trouver le ListTile parent (cas RadioListTile)
    final listTileAncestor = find.ancestor(
      of: textFinder.first,
      matching: find.byType(ListTile),
    );
    if (listTileAncestor.evaluate().isNotEmpty) {
      debugPrint('Tap sur ListTile parent du radio "$radioLabel"');
      await tester.ensureVisible(listTileAncestor.first);
      await pumpFor(tester, const Duration(milliseconds: 300));
      await tester.tap(listTileAncestor.first);
      await pumpFor(tester, const Duration(seconds: 1));
      return;
    }

    // Strategie 2 : trouver l'InkWell parent
    final inkWellAncestor = find.ancestor(
      of: textFinder.first,
      matching: find.byType(InkWell),
    );
    if (inkWellAncestor.evaluate().isNotEmpty) {
      debugPrint('Tap sur InkWell parent du radio "$radioLabel"');
      await tester.ensureVisible(inkWellAncestor.first);
      await pumpFor(tester, const Duration(milliseconds: 300));
      await tester.tap(inkWellAncestor.first);
      await pumpFor(tester, const Duration(seconds: 1));
      return;
    }

    // Strategie 3 : tap direct sur le texte avec warnIfMissed: false
    debugPrint(
        'Pas de ListTile/InkWell parent, tap direct sur "$radioLabel"');
    await tester.ensureVisible(textFinder.first);
    await pumpFor(tester, const Duration(milliseconds: 300));
    await tester.tap(textFinder.first, warnIfMissed: false);
    await pumpFor(tester, const Duration(seconds: 1));
  }

  /// Tape sur le bouton form-save-button.
  /// Cache automatiquement le clavier au cas ou et ferme les dialogs eventuels
  /// qui apparaissent apres save (ex: "Creer une visite ?").
  static Future<void> tapFormSave(WidgetTester tester) async {
    await hideKeyboard(tester);

    final saveButton = find.byKey(const Key('form-save-button'));
    await waitForWidget(
      tester,
      saveButton,
      timeout: const Duration(seconds: 10),
      description: 'form-save-button',
    );

    await tester.ensureVisible(saveButton);
    await pumpFor(tester, const Duration(milliseconds: 500));
    await tester.tap(saveButton);

    // Polling actif : attendre que le form-save-button disparaisse
    // (succes du save) tout en dismissant les dialogs qui apparaissent
    // a timing variable ("Creer une visite ?", etc.).
    // Plus robuste qu'un pumpFor fixe suivi d'un dismiss one-shot.
    await _waitForFormClosedOrDismiss(tester,
        timeout: const Duration(seconds: 45));
  }

  /// Verifie qu'on n'est PLUS sur un formulaire (le bouton form-save-button
  /// doit etre absent du widget tree). Sinon, dump les textes visibles
  /// pour aider au debogage (souvent : champs requis non remplis).
  static void expectFormClosed(WidgetTester tester) {
    if (find.byKey(const Key('form-save-button')).evaluate().isNotEmpty) {
      final visibleTexts = find
          .byType(Text)
          .evaluate()
          .map((e) => (e.widget as Text).data ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      fail(
          'Le formulaire est toujours ouvert apres save. Validation echouee ?\n'
          'Champs requis manquants ? Textes visibles: $visibleTexts');
    }
  }

  /// Helper interne : echec avec dump des keys de form pour debogage.
  static Never _dumpFormFieldKeys(
      String fieldName, List<String> triedKeys) {
    final allKeys = <String>[];
    final allWidgetsWithKey = find.byWidgetPredicate(
      (w) => w.key is ValueKey,
    );
    for (final element in allWidgetsWithKey.evaluate()) {
      final widget = element.widget;
      final keyValue = (widget.key as ValueKey).value;
      if (keyValue is String &&
          (keyValue.endsWith('_true') ||
              keyValue.endsWith('_false') ||
              keyValue.startsWith('select_') ||
              keyValue.startsWith('nomenclature_'))) {
        allKeys.add('${widget.runtimeType}:$keyValue');
      }
    }
    fail(
        'Champ "$fieldName" introuvable. Patterns essayes: $triedKeys.\nKeys presentes: $allKeys');
  }

  // ==========================================================================
  // NAVIGATION HELPERS
  // ==========================================================================

  /// Revient a la HomePage depuis n'importe quelle page de navigation en
  /// pop-ant jusqu'a voir "Mes Modules".
  static Future<void> navigateBackToHome(
    WidgetTester tester, {
    int maxPops = 6,
  }) async {
    for (var i = 0; i < maxPops; i++) {
      if (find.text('Mes Modules').evaluate().isNotEmpty) return;
      final back = find.byTooltip('Back');
      if (back.evaluate().isNotEmpty) {
        await tester.tap(back.first);
        await pumpFor(tester, const Duration(seconds: 2));
        continue;
      }
      final backBtn = find.byType(BackButton);
      if (backBtn.evaluate().isNotEmpty) {
        await tester.tap(backBtn.first);
        await pumpFor(tester, const Duration(seconds: 2));
        continue;
      }
      break; // plus rien a pop
    }
    if (find.text('Mes Modules').evaluate().isEmpty) {
      fail('navigateBackToHome: impossible de revenir a la HomePage');
    }
  }

  /// Declenche un upload via le menu "Téléversement" depuis la HomePage.
  /// Attend la fin du sync. Si le dialog "Synchronisation requise" apparait
  /// et [requireDownloadFirst] est faux, l'upload est skip avec un warning.
  static Future<void> triggerSyncUploadFromHome(
    WidgetTester tester, {
    bool skipIfDownloadRequired = true,
  }) async {
    final menuButton = find.byIcon(Icons.menu);
    await waitForWidget(
      tester,
      menuButton,
      timeout: const Duration(seconds: 10),
      description: 'menu burger pour upload',
    );
    await tester.tap(menuButton);
    await pumpFor(tester, const Duration(seconds: 2));

    final uploadMenuItem = find.byKey(const Key('menu-sync_upload'));
    await waitForWidget(
      tester,
      uploadMenuItem,
      timeout: const Duration(seconds: 5),
      description: 'item menu-sync_upload',
    );
    await tester.tap(uploadMenuItem);
    await pumpFor(tester, const Duration(seconds: 3));

    if (find.text('Synchronisation requise').evaluate().isNotEmpty) {
      if (skipIfDownloadRequired) {
        debugPrint(
            'Dialog "Synchronisation requise" : upload skip (relancez apres sync-download)');
        for (final btnText in ['Fermer', 'Annuler', 'OK']) {
          final btn = find.text(btnText);
          if (btn.evaluate().isNotEmpty) {
            await tester.tap(btn.first);
            break;
          }
        }
        return;
      } else {
        fail(
            'Upload bloque par "Synchronisation requise" (download requis au prealable)');
      }
    }

    final sendButton = find.widgetWithText(ElevatedButton, 'Envoyer');
    await waitForWidget(
      tester,
      sendButton,
      timeout: const Duration(seconds: 10),
      description: 'bouton "Envoyer"',
    );
    await tester.tap(sendButton);
    await pumpFor(tester, const Duration(seconds: 2));

    // Module selector multi-modules : tout cocher si la UI le permet,
    // sinon choisir le premier item.
    if (find.text('Sélectionner un module').evaluate().isNotEmpty) {
      // Essayer de tout cocher via un bouton "Tout selectionner" s'il existe
      final selectAll = find.text('Tout sélectionner');
      if (selectAll.evaluate().isNotEmpty) {
        await tester.tap(selectAll.first);
        await pumpFor(tester, const Duration(seconds: 1));
      } else {
        // Fallback : cocher chaque checkbox visible
        final checkboxes = find.byType(Checkbox);
        for (var i = 0; i < checkboxes.evaluate().length; i++) {
          await tester.tap(checkboxes.at(i));
          await pumpFor(tester, const Duration(milliseconds: 300));
        }
        if (checkboxes.evaluate().isEmpty) {
          // Pas de checkbox → fallback premier ListTile
          final listTiles = find.byType(ListTile);
          if (listTiles.evaluate().isNotEmpty) {
            await tester.tap(listTiles.first);
            await pumpFor(tester, const Duration(seconds: 1));
          }
        }
      }
      // Valider la selection
      for (final btnText in ['Envoyer', 'Valider', 'OK']) {
        final btn = find.widgetWithText(ElevatedButton, btnText);
        if (btn.evaluate().isNotEmpty) {
          await tester.tap(btn.first);
          await pumpFor(tester, const Duration(seconds: 2));
          break;
        }
      }
    }

    await waitForSyncToFinish(
      tester,
      timeout: const Duration(minutes: 5),
    );
    debugPrint('Upload termine');
    await dismissBlockingDialogs(tester);
  }

  /// Selectionne un taxon via le TaxonSelectorWidget en tapant [searchQuery]
  /// dans le champ de recherche, puis en tapant sur le [resultIndex]-ieme
  /// resultat (index 0-based). Le champ declenche la recherche a partir de
  /// 3 caracteres, donc [searchQuery] doit faire >= 3 caracteres.
  ///
  /// Keys utilisees (ajoutees dans taxon_selector_widget.dart) :
  ///   - `taxon-search-field` : le TextFormField de recherche
  ///   - `taxon-search-results` : le Container qui wrappe la ListView
  ///
  /// Throws via fail() si le champ ou les resultats n'apparaissent pas.
  static Future<void> selectTaxonBySearch(
    WidgetTester tester,
    String searchQuery, {
    int resultIndex = 0,
    Duration debounce = const Duration(seconds: 2),
  }) async {
    assert(searchQuery.length >= 3,
        'searchQuery doit faire >= 3 caracteres (trigger de recherche du widget)');

    final searchField = find.byKey(const Key('taxon-search-field'));
    await waitForWidget(
      tester,
      searchField,
      timeout: const Duration(seconds: 10),
      description: 'taxon-search-field',
    );
    await tester.ensureVisible(searchField);
    await pumpFor(tester, const Duration(milliseconds: 300));
    await tester.enterText(searchField, searchQuery);
    await pumpFor(tester, debounce);
    await hideKeyboard(tester);

    // Attendre l'apparition du Container de resultats (recherche > 0 hits).
    final resultsContainer = find.byKey(const Key('taxon-search-results'));
    await waitForWidget(
      tester,
      resultsContainer,
      timeout: const Duration(seconds: 10),
      description: 'taxon-search-results pour "$searchQuery"',
    );

    final resultTiles = find.descendant(
      of: resultsContainer,
      matching: find.byType(ListTile),
    );
    final count = resultTiles.evaluate().length;
    if (count == 0) {
      fail('Aucun ListTile dans les resultats de recherche "$searchQuery"');
    }
    if (resultIndex >= count) {
      fail(
          'resultIndex $resultIndex hors plage (il y a $count resultats pour "$searchQuery")');
    }

    debugPrint(
        'Taxon search "$searchQuery" → $count resultat(s), tap sur index $resultIndex');
    await tester.tap(resultTiles.at(resultIndex));
    await pumpFor(tester, const Duration(seconds: 1));
  }

  /// Tape sur un onglet par son texte (TabBar).
  static Future<void> tapTab(WidgetTester tester, String tabText) async {
    final tab = find.widgetWithText(Tab, tabText);
    if (tab.evaluate().isEmpty) {
      // Fallback : cherche par texte simple
      final tabFallback = find.text(tabText);
      if (tabFallback.evaluate().isNotEmpty) {
        await tester.tap(tabFallback.first);
        await pumpFor(tester, const Duration(seconds: 1));
        return;
      }
      debugPrint('Onglet "$tabText" non trouve, on continue');
      return;
    }
    await tester.tap(tab);
    await pumpFor(tester, const Duration(seconds: 1));
  }
}
