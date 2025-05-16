import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_setup.dart';

/// Cette fonction s'exécute avant tous les tests
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Initialiser l'environnement global de test
  await MockSetup.initializeTestEnvironment();
  
  // Wrapper de test pour injecter des hooks globaux
  await testMain();
  
  // Nettoyer l'environnement après tous les tests
  await MockSetup.tearDownTestEnvironment();
}