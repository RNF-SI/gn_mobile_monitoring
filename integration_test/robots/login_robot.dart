import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'base_robot.dart';

/// Robot for interacting with the LoginPage.
class LoginRobot extends BaseRobot {
  LoginRobot(super.tester);

  /// Enter the identifiant (username)
  Future<void> enterIdentifiant(String identifiant) async {
    await enterTextByKey('login-identifiant-field', identifiant);
  }

  /// Enter the password
  Future<void> enterPassword(String password) async {
    await enterTextByKey('login-password-field', password);
  }

  /// Enter the API URL
  Future<void> enterApiUrl(String url) async {
    // The API URL field uses a label, not a key
    await enterTextByLabel('URL du serveur GeoNature', url);
  }

  /// Tap the login button
  Future<void> tapLogin() async {
    await tapKeyAndSettle('login-button');
  }

  /// Perform a complete login flow
  Future<void> login({
    required String identifiant,
    required String password,
    String apiUrl = 'https://mock.geonature.test',
  }) async {
    await enterApiUrl(apiUrl);
    await enterIdentifiant(identifiant);
    await enterPassword(password);
    await tapLogin();
  }

  /// Assert the login page is displayed
  void expectLoginPageVisible() {
    expectText('Se connecter');
    expectKey('login-identifiant-field');
    expectKey('login-password-field');
  }

  /// Assert that a loading indicator is shown
  void expectLoading() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Assert that an error message is displayed
  void expectError(String errorText) {
    expectText(errorText);
  }
}
