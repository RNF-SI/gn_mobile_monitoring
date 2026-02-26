import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with the ModuleDetailPage.
class ModuleDetailRobot extends BaseRobot {
  ModuleDetailRobot(super.tester);

  /// Assert the module detail page is displayed with the given title
  void expectModuleDetailVisible(String moduleLabel) {
    expectText(moduleLabel);
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

  /// Tap on a site by its name
  Future<void> tapSite(String siteName) async {
    final finder = find.text(siteName);
    expect(finder, findsWidgets, reason: 'Site "$siteName" not found');
    await tapAndSettle(finder.first);
  }

  /// Tap on a site group by its name
  Future<void> tapSiteGroup(String groupName) async {
    final finder = find.text(groupName);
    expect(finder, findsWidgets, reason: 'Site group "$groupName" not found');
    await tapAndSettle(finder.first);
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
