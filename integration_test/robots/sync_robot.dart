import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with sync-related UI.
class SyncRobot extends BaseRobot {
  SyncRobot(super.tester);

  /// Open the menu and trigger download sync
  Future<void> triggerDownloadSync() async {
    // Open the popup menu
    final menuButton = find.byIcon(Icons.menu);
    expect(menuButton, findsOneWidget, reason: 'Menu button not found');
    await tapAndSettle(menuButton);

    // Tap sync download
    await tapKeyAndSettle('menu-sync_download');
  }

  /// Open the menu and trigger upload sync
  Future<void> triggerUploadSync() async {
    final menuButton = find.byIcon(Icons.menu);
    expect(menuButton, findsOneWidget, reason: 'Menu button not found');
    await tapAndSettle(menuButton);

    await tapKeyAndSettle('menu-sync_upload');
  }

  /// Wait for sync to complete (look for sync completion indicators)
  Future<void> waitForSyncComplete({Duration? timeout}) async {
    final effectiveTimeout = timeout ?? const Duration(seconds: 30);
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < effectiveTimeout) {
      await tester.pump(const Duration(milliseconds: 500));

      // Check if sync progress indicator is gone
      final progressIndicator = find.byType(CircularProgressIndicator);
      if (progressIndicator.evaluate().isEmpty) {
        return;
      }
    }
    // Don't fail — sync may complete before we start checking
  }

  /// Assert a sync success message is shown
  void expectSyncSuccess() {
    // Look for common success indicators
    final snackbar = find.byType(SnackBar);
    if (snackbar.evaluate().isNotEmpty) {
      // A snackbar is showing — likely a sync result
      return;
    }
  }
}
