import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with the HomePage.
class HomeRobot extends BaseRobot {
  HomeRobot(super.tester);

  /// Assert the home page is displayed
  void expectHomePageVisible() {
    expectText('Mes Modules');
  }

  /// Assert that a module card with the given label is visible
  void expectModuleCard(String moduleLabel) {
    expectText(moduleLabel);
  }

  /// Tap on a module card by its code
  Future<void> tapModuleCard(String moduleCode) async {
    await tapKeyAndSettle('module-card-$moduleCode');
  }

  /// Open the menu (hamburger icon)
  Future<void> openMenu() async {
    final menuButton = find.byIcon(Icons.menu);
    expect(menuButton, findsOneWidget, reason: 'Menu button not found');
    await tapAndSettle(menuButton);
  }

  /// Tap logout in the menu
  Future<void> tapLogout() async {
    await openMenu();
    await tapKeyAndSettle('menu-logout');
  }

  /// Tap sync download in the menu
  Future<void> tapSyncDownload() async {
    await openMenu();
    await tapKeyAndSettle('menu-sync-download');
  }

  /// Confirm a logout dialog if present
  Future<void> confirmLogout() async {
    // The logout dialog button text is "Confirmer la déconnexion"
    final confirmButton = find.text('Confirmer la déconnexion');
    if (confirmButton.evaluate().isNotEmpty) {
      await tester.tap(confirmButton);
      // Don't use pumpAndSettle — logout shows a CircularProgressIndicator dialog
      for (int i = 0; i < 50; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    } else {
      // Fallback: try "Confirmer" or "Oui"
      final altButton = find.text('Confirmer');
      if (altButton.evaluate().isNotEmpty) {
        await tester.tap(altButton);
        for (int i = 0; i < 50; i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
      }
    }
  }
}
