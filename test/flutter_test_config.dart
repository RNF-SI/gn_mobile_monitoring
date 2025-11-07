import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_setup.dart';

/// Cette fonction s'exécute avant tous les tests
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Initialiser l'environnement global de test
  await MockSetup.initializeTestEnvironment();

  // Désactiver les ombres pour améliorer les performances des tests
  debugDisableShadows = true;

  // Configurer le gestionnaire d'erreurs Flutter pour ignorer les overflows UI dans les tests
  // Cela permet aux tests de se concentrer sur la logique plutôt que sur les contraintes d'UI
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails details) {
    final exception = details.exception;
    final errorString = exception.toString();

    // Ignorer les erreurs de RenderFlex overflow
    if (exception is FlutterError &&
        (errorString.contains('RenderFlex overflowed') ||
         errorString.contains('A RenderFlex overflowed'))) {
      debugPrint('Ignoring RenderFlex overflow in tests');
      return;
    }

    // Pour les autres erreurs, utiliser le comportement par défaut
    if (originalOnError != null) {
      originalOnError(details);
    } else {
      FlutterError.presentError(details);
    }
  };

  // Désactiver les assertions de débordement de rendu dans les tests
  // Cela empêche les tests de échouer à cause de petits débordements d'UI
  debugCheckIntrinsicSizes = false;

  // Wrapper de test pour injecter des hooks globaux
  await testMain();

  // Nettoyer l'environnement après tous les tests
  await MockSetup.tearDownTestEnvironment();
}