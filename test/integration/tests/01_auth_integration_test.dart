@Tags(['integration'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';

import '../config/test_environment_setup.dart';
import '../config/test_server_config.dart';
import '../helpers/auth_helper.dart';

/// Tests d'intégration pour l'authentification avec le serveur GeoNature réel
///
/// Ces tests valident:
/// - La connexion avec un serveur GeoNature 16 de test
/// - La récupération d'un token JWT valide
/// - La récupération des informations utilisateur
/// - La gestion des erreurs d'authentification
void main() {
  TestServerConfig? config;

  setUpAll(() async {
    await TestEnvironmentSetup.setUpAll();
    config = await TestEnvironmentSetup.getConfig();
  });

  tearDownAll(() async {
    await TestEnvironmentSetup.tearDownAll();
  });

  setUp(() async {
    await TestEnvironmentSetup.setUp();
    await AuthHelper.reset();
  });

  tearDown(() async {
    await AuthHelper.reset();
    await TestEnvironmentSetup.tearDown();
  });

  group(
    'Authentification avec serveur GeoNature de test',
    skip:
        'TestWidgetsFlutterBinding bloque les HTTP réels (status 400 forcé) → '
        'ces tests ne peuvent pas valider auth contre un vrai serveur. '
        'Pour de l\'auth E2E réelle, utiliser '
        'integration_test/scenarios_real/real_auth_e2e_test.dart '
        '(qui passe via IntegrationTestWidgetsFlutterBinding sur device).',
    () {
    test('Connexion réussie avec credentials valides', () async {
      // Skip si pas de configuration
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Act
      final token = await AuthHelper.loginWithTestConfig(config!);

      // Assert
      expect(token, isNotEmpty);
      expect(token.length, greaterThan(20)); // JWT minimum length
      expect(AuthHelper.isLoggedIn, isTrue);
      expect(AuthHelper.currentUser, isNotNull);
      expect(AuthHelper.currentToken, equals(token));

      print('✅ Token reçu: ${token.substring(0, 30)}...');
      print('✅ Utilisateur: ${AuthHelper.currentUser!.nomRole} ${AuthHelper.currentUser!.prenomRole ?? ""}');
    });

    test('Vérification des informations utilisateur retournées', () async {
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Act
      await AuthHelper.loginWithTestConfig(config!);
      final user = AuthHelper.currentUser!;

      // Assert
      expect(user.idRole, isNotNull);
      expect(user.idRole, greaterThan(0));
      expect(user.nomRole, isNotEmpty);
      expect(user.token, isNotEmpty);
      expect(user.token, equals(AuthHelper.currentToken));

      print('✅ User ID: ${user.idRole}');
      print('✅ Nom: ${user.nomRole}');
      print('✅ Prénom: ${user.prenomRole ?? "N/A"}');
      print('✅ Email: ${user.email ?? "N/A"}');
    });

    test('Configuration de l\'URL de base après connexion', () async {
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Arrange
      final urlBefore = Config.apiBase;

      // Act
      await AuthHelper.loginWithTestConfig(config!);

      // Assert
      final urlAfter = Config.apiBase;
      expect(urlAfter, contains(config!.url.replaceAll('https://', '').replaceAll('http://', '')));
      print('✅ URL avant: $urlBefore');
      print('✅ URL après: $urlAfter');
    });

    test('Échec de connexion avec credentials invalides', () async {
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Act & Assert
      expect(
        () => AuthHelper.login(
          serverUrl: config!.url,
          username: 'invalid_user',
          password: 'wrong_password',
        ),
        throwsException,
      );

      // Vérifier qu'on n'est pas connecté
      expect(AuthHelper.isLoggedIn, isFalse);
      expect(AuthHelper.currentUser, isNull);
      expect(AuthHelper.currentToken, isNull);
    });

    test('Échec de connexion avec URL serveur invalide', () async {
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Act & Assert
      expect(
        () => AuthHelper.login(
          serverUrl: 'https://serveur-inexistant-12345.com',
          username: config!.username,
          password: config!.password,
        ),
        throwsException,
      );

      // Vérifier qu'on n'est pas connecté
      expect(AuthHelper.isLoggedIn, isFalse);
    });

    test('Déconnexion nettoie les données d\'authentification', () async {
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Arrange
      await AuthHelper.loginWithTestConfig(config!);
      expect(AuthHelper.isLoggedIn, isTrue);

      // Act
      await AuthHelper.logout();

      // Assert
      expect(AuthHelper.isLoggedIn, isFalse);
      expect(AuthHelper.currentUser, isNull);
      expect(AuthHelper.currentToken, isNull);
    });

    test('Token JWT est bien formé', () async {
      if (config == null) {
        print('⏭️  Test skipped: no test server configuration available');
        return;
      }

      // Act
      final token = await AuthHelper.loginWithTestConfig(config!);

      // Assert - Un JWT a 3 parties séparées par des points
      final parts = token.split('.');
      expect(parts.length, equals(3));
      expect(parts[0], isNotEmpty); // Header
      expect(parts[1], isNotEmpty); // Payload
      expect(parts[2], isNotEmpty); // Signature

      print('✅ JWT Header: ${parts[0].substring(0, min(parts[0].length, 20))}...');
      print('✅ JWT Payload: ${parts[1].substring(0, min(parts[1].length, 20))}...');
      print('✅ JWT Signature: ${parts[2].substring(0, min(parts[2].length, 20))}...');
    });
  });
}

int min(int a, int b) => a < b ? a : b;
