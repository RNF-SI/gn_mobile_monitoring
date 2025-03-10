# Guide des Tests pour GN Mobile Monitoring

Ce projet suit une approche TDD (Test-Driven Development) organisée selon l'architecture Clean. Ce document explique comment structurer les tests et les meilleures pratiques à suivre.

## Structure des Tests

```
test/
├── data/              # Tests pour la couche data
│   └── repository/    # Tests des implémentations de repositories
├── domain/            # Tests pour la couche domain
│   └── usecase/       # Tests des use cases
├── presentation/      # Tests pour la couche presentation
│   ├── view/          # Tests des widgets UI
│   └── viewmodel/     # Tests des ViewModels
├── integration/       # Tests d'intégration entre les couches
├── mocks/             # Classes mock réutilisables
└── templates/         # Modèles pour nouveaux tests
```

## Types de Tests

### Tests Unitaires

- **Repositories**: Testez chaque méthode du repository avec des mocks pour les datasources.
- **Use Cases**: Testez chaque use case avec des mocks pour les repositories.
- **ViewModels**: Testez la logique des viewmodels avec des mocks pour les use cases.
- **Widgets**: Testez le comportement UI des widgets avec différents états.

### Tests d'Intégration

Testez l'interaction entre les différentes couches pour s'assurer que les données circulent correctement.

## Meilleures Pratiques TDD

1. **Red**: Commencez par écrire un test qui échoue.
2. **Green**: Écrivez le minimum de code pour faire passer le test.
3. **Refactor**: Améliorez le code sans changer son comportement.

## Exemple de Cycle TDD

```dart
// 1. Écrire un test qui échoue (Red)
test('should return modules from local database', () async {
  when(() => mockModulesDatabase.getAllModules())
      .thenAnswer((_) async => mockModules);
      
  final result = await repository.getModulesFromLocal();
  
  expect(result, equals(mockModules));
  verify(() => mockModulesDatabase.getAllModules()).called(1);
});

// 2. Implémenter le code minimal (Green)
@override
Future<List<Module>> getModulesFromLocal() async {
  return await database.getAllModules();
}

// 3. Refactoriser si nécessaire (Refactor)
```

## Commandes Utiles

```bash
# Exécuter tous les tests
flutter test

# Exécuter un seul fichier de test
flutter test test/path/to/test_file.dart

# Exécuter avec coverage
flutter test --coverage
```

## Mocking

Nous utilisons `mocktail` pour créer des mocks. Les mocks réutilisables sont définis dans `test/mocks/mocks.dart`.

## Conventions de Nommage

- Fichiers de test: `*_test.dart`
- Groupes de test: Nommez-les d'après la fonctionnalité testée
- Tests individuels: Commencez par "should" et décrivez le comportement attendu