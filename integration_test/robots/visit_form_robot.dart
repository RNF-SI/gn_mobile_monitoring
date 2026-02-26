import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with visit forms.
class VisitFormRobot extends BaseRobot {
  VisitFormRobot(super.tester);

  /// Enter a comment
  Future<void> enterComment(String comment) async {
    // DynamicFormBuilder fields use ValueKey('comments_false') or similar
    final finder = find.byKey(const ValueKey('comments_false'));
    if (finder.evaluate().isNotEmpty) {
      await tester.enterText(finder, comment);
      await tester.pump();
    } else {
      // Try by label
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

  /// Select a date in the date picker (if a date field is present)
  Future<void> selectDate() async {
    // Look for a date field and tap it to open the date picker
    final dateField = find.byKey(const ValueKey('visit_date_min_true'));
    if (dateField.evaluate().isNotEmpty) {
      await tester.tap(dateField);
      await tester.pumpAndSettle();

      // Tap OK in the date picker dialog
      final okButton = find.text('OK');
      if (okButton.evaluate().isNotEmpty) {
        await tester.tap(okButton);
        await tester.pumpAndSettle();
      }
    }
  }

  /// Assert the form is visible
  void expectFormVisible() {
    // The form should have save/cancel buttons
    expectKey('form-save-button');
  }
}
