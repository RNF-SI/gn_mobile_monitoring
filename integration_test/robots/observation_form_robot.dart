import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with observation forms.
class ObservationFormRobot extends BaseRobot {
  ObservationFormRobot(super.tester);

  /// Search for a taxon by name in the taxon selector
  Future<void> searchTaxon(String name) async {
    // Find the taxon search field
    final searchField = find.byType(TextField);
    if (searchField.evaluate().isNotEmpty) {
      await tester.enterText(searchField.last, name);
      // Wait for debounce
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
    }
  }

  /// Select the first taxon result
  Future<void> selectFirstTaxonResult() async {
    // Look for taxon result items in a list
    final listTiles = find.byType(ListTile);
    if (listTiles.evaluate().isNotEmpty) {
      await tester.tap(listTiles.first);
      await tester.pumpAndSettle();
    }
  }

  /// Enter a comment
  Future<void> enterComment(String comment) async {
    final finder = find.byKey(const ValueKey('comments_false'));
    if (finder.evaluate().isNotEmpty) {
      await tester.enterText(finder, comment);
      await tester.pump();
    } else {
      await enterTextByLabel('Commentaires', comment);
    }
  }

  /// Tap the save button
  Future<void> tapSave() async {
    await tapKeyAndSettle('form-save-button');
  }

  /// Tap the cancel button
  Future<void> tapCancel() async {
    await tapKeyAndSettle('form-cancel-button');
  }

  /// Assert the form is visible
  void expectFormVisible() {
    expectKey('form-save-button');
  }
}
