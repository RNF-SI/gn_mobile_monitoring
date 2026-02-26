import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with the SiteDetailPage.
class SiteDetailRobot extends BaseRobot {
  SiteDetailRobot(super.tester);

  /// Assert the site detail page is displayed with the given name
  void expectSiteDetailVisible(String siteName) {
    expectText(siteName);
  }

  /// Assert a visit is listed with the given date
  void expectVisit(String visitDate) {
    expectText(visitDate);
  }

  /// Tap the create visit button
  Future<void> tapCreateVisit() async {
    await tapKeyAndSettle('create-visit-button');
  }

  /// Tap the edit site button
  Future<void> tapEditSite() async {
    await tapKeyAndSettle('edit-site-button');
  }

  /// Tap on a visit row by date
  Future<void> tapVisit(String visitDate) async {
    final finder = find.text(visitDate);
    expect(finder, findsWidgets, reason: 'Visit with date "$visitDate" not found');
    await tapAndSettle(finder.first);
  }

  /// Go back to previous page
  Future<void> goBack() async {
    final backButton = find.byIcon(Icons.arrow_back);
    if (backButton.evaluate().isNotEmpty) {
      await tapAndSettle(backButton.first);
    }
  }
}
