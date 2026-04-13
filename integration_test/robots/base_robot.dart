import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Base class for all E2E test robots.
///
/// Provides common helper methods for interacting with the widget tree.
/// Each robot encapsulates interaction logic for a specific page/screen.
abstract class BaseRobot {
  final WidgetTester tester;

  BaseRobot(this.tester);

  /// Default timeout for pumpAndSettle operations
  Duration get settleTimeout => const Duration(seconds: 10);

  /// Pump and settle with a generous timeout
  Future<void> settle() async {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      settleTimeout,
    );
  }

  /// Try to settle, but don't fail if it times out
  Future<void> tryStetle() async {
    try {
      await settle();
    } catch (_) {
      // Settle timed out — likely due to ongoing animations
      await tester.pump(const Duration(milliseconds: 500));
    }
  }

  /// Tap a widget found by [finder] and settle
  Future<void> tapAndSettle(Finder finder) async {
    await tester.tap(finder);
    await settle();
  }

  /// Tap a widget found by key and settle
  Future<void> tapKeyAndSettle(String key) async {
    final finder = find.byKey(Key(key));
    expect(finder, findsOneWidget, reason: 'Widget with key "$key" not found');
    await tapAndSettle(finder);
  }

  /// Enter text into a text field found by key
  Future<void> enterTextByKey(String key, String text) async {
    final finder = find.byKey(Key(key));
    expect(finder, findsOneWidget,
        reason: 'Text field with key "$key" not found');
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Enter text into a text field found by label
  Future<void> enterTextByLabel(String label, String text) async {
    final finder = find.widgetWithText(TextFormField, label);
    if (finder.evaluate().isEmpty) {
      // Try with TextField instead
      final altFinder = find.widgetWithText(TextField, label);
      expect(altFinder, findsOneWidget,
          reason: 'Text field with label "$label" not found');
      await tester.enterText(altFinder, text);
    } else {
      await tester.enterText(finder, text);
    }
    await tester.pump();
  }

  /// Scroll down in the first Scrollable found
  Future<void> scrollDown({double delta = 300}) async {
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.byType(SizedBox).last,
      delta,
      scrollable: scrollable,
    );
    await tester.pump();
  }

  /// Wait for a widget with the given key to appear
  Future<void> waitForKey(String key, {Duration? timeout}) async {
    final effectiveTimeout = timeout ?? settleTimeout;
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < effectiveTimeout) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.byKey(Key(key)).evaluate().isNotEmpty) {
        return;
      }
    }
    fail('Widget with key "$key" did not appear within $effectiveTimeout');
  }

  /// Wait for a widget with the given text to appear
  Future<void> waitForText(String text, {Duration? timeout}) async {
    final effectiveTimeout = timeout ?? settleTimeout;
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < effectiveTimeout) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text(text).evaluate().isNotEmpty) {
        return;
      }
    }
    fail('Text "$text" did not appear within $effectiveTimeout');
  }

  /// Assert that a widget with the given text is visible
  void expectText(String text) {
    expect(find.text(text), findsWidgets,
        reason: 'Expected to find text "$text"');
  }

  /// Assert that a widget with the given text is NOT visible
  void expectNoText(String text) {
    expect(find.text(text), findsNothing,
        reason: 'Expected NOT to find text "$text"');
  }

  /// Assert that a widget with the given key is visible
  void expectKey(String key) {
    expect(find.byKey(Key(key)), findsOneWidget,
        reason: 'Expected to find widget with key "$key"');
  }

  /// Assert that a widget with the given key is NOT visible
  void expectNoKey(String key) {
    expect(find.byKey(Key(key)), findsNothing,
        reason: 'Expected NOT to find widget with key "$key"');
  }
}
