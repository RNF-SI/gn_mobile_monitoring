import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with the ModuleDetailPage.
class ModuleDetailRobot extends BaseRobot {
  ModuleDetailRobot(super.tester);

  /// Assert the module detail page is displayed with the given title.
  ///
  /// L'AppBar affiche `"Module: <moduleLabel>"` dans un unique Text widget,
  /// donc `find.text(moduleLabel)` strict ne matcherait pas. On utilise
  /// `findRichText: true` + `textContaining` pour matcher le label où qu'il
  /// soit (AppBar préfixé, breadcrumb détaillé, etc.).
  void expectModuleDetailVisible(String moduleLabel) {
    expect(find.textContaining(moduleLabel), findsWidgets,
        reason: 'Expected module label "$moduleLabel" to be visible on page');
  }

  /// Assert that a site is listed
  void expectSite(String siteName) {
    expectText(siteName);
  }

  /// Tap the create site button
  Future<void> tapCreateSite() async {
    await tapKeyAndSettle('create-site-button');
  }

  /// Tap the create site group button
  Future<void> tapCreateSiteGroup() async {
    await tapKeyAndSettle('create-site-group-button');
  }

  /// Tap on a site by its name.
  ///
  /// Les sites sont listés dans une `DataTable` où les cellules de texte sont
  /// non-tappables — seul l'`IconButton` visibilité (`Icons.visibility`) dans
  /// la colonne "Actions" déclenche la navigation vers `SiteDetailPage`. On
  /// vérifie d'abord que le site est présent (matching du texte) puis on tape
  /// la première icône visibilité visible. Le seeder ordonne les sites
  /// déterministiquement (Alpha avant Beta) donc `.first` correspond au site
  /// du test.
  Future<void> tapSite(String siteName) async {
    final siteText = find.text(siteName);
    expect(siteText, findsWidgets, reason: 'Site "$siteName" not found');

    final visibilityIcon = find.byIcon(Icons.visibility);
    if (visibilityIcon.evaluate().isEmpty) {
      // Fallback : tap direct sur le texte (layouts legacy non-DataTable)
      await tapAndSettle(siteText.first);
      return;
    }
    await tapAndSettle(visibilityIcon.first);
  }

  /// Tap on a site group by its name. Même logique que [tapSite] : les
  /// groupes exposent l'icône visibilité comme action de navigation.
  Future<void> tapSiteGroup(String groupName) async {
    final groupText = find.text(groupName);
    expect(groupText, findsWidgets, reason: 'Site group "$groupName" not found');

    final visibilityIcon = find.byIcon(Icons.visibility);
    if (visibilityIcon.evaluate().isEmpty) {
      await tapAndSettle(groupText.first);
      return;
    }
    await tapAndSettle(visibilityIcon.first);
  }

  /// Go back to previous page
  Future<void> goBack() async {
    final backButton = find.byType(BackButton);
    if (backButton.evaluate().isNotEmpty) {
      await tapAndSettle(backButton);
    } else {
      // Try the AppBar back button
      final iconBack = find.byIcon(Icons.arrow_back);
      if (iconBack.evaluate().isNotEmpty) {
        await tapAndSettle(iconBack.first);
      }
    }
  }
}
