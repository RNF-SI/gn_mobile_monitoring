# Outils pour les Tests TDD

Ce répertoire contient des scripts utilitaires pour faciliter la création de tests suivant l'approche TDD (Test-Driven Development).

## create_tdd_test.dart

Ce script génère automatiquement un fichier de test basé sur des templates prédéfinis pour chaque couche de l'architecture Clean.

### Usage

```bash
dart scripts/test_utils/create_tdd_test.dart <type> <nom_classe>
```

Où :
- `<type>` est le type de test à créer : `repository`, `usecase`, `viewmodel`, ou `widget`
- `<nom_classe>` est le nom de la classe à tester (en PascalCase)

### Exemples

```bash
# Créer un test pour un repository
dart scripts/test_utils/create_tdd_test.dart repository SitesRepository

# Créer un test pour un use case
dart scripts/test_utils/create_tdd_test.dart usecase GetSitesUseCase

# Créer un test pour un viewmodel
dart scripts/test_utils/create_tdd_test.dart viewmodel SitesUtilisateurViewModel

# Créer un test pour un widget
dart scripts/test_utils/create_tdd_test.dart widget SiteListWidget
```

### Avantages

- Génère la structure de base du test avec les mocks et les tests essentiels
- Applique les bonnes pratiques TDD de manière cohérente
- Accélère la création de nouveaux tests
- Assure la cohérence entre les tests de l'application

## Workflow TDD recommandé

1. Créez d'abord le test avec `create_tdd_test.dart`
2. Complétez les sections TODO du template généré
3. Exécutez le test (il devrait échouer)
4. Implémentez le code minimal pour faire passer le test
5. Refactorisez si nécessaire
6. Ajoutez plus de tests au besoin

## Intégration avec le processus de développement

Pour un nouveau feature, suivez ce processus TDD :

1. Créez les tests de repository
2. Implémentez le repository
3. Créez les tests de use case
4. Implémentez le use case
5. Créez les tests de viewmodel
6. Implémentez le viewmodel
7. Créez les tests de widget
8. Implémentez le widget