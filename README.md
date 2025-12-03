# gn_mobile_monitoring

Version mobile du module monitoring de Geonature.

## Documentation

### Fonctionnalités
- [Vue d'ensemble des fonctionnalités](./docs/FEATURES_OVERVIEW.md) - Types de widgets, compatibilité des modules et limitations
- [Expressions JavaScript supportées](./docs/JAVASCRIPT_EXPRESSIONS.md) - Documentation technique détaillée des expressions JS

### Développement
- [Tâches](./TASKS.md)
- [Snippets](./SNIPPETS.md)
- [.cursorrules](./CURSORRULES.md)
- [Fichiers de Prompts](./PROMPTS.md)

## Tests

### Tests unitaires
```bash
make test              # Exécute les tests unitaires
make test-unit         # Alias pour les tests unitaires
```

### Tests d'intégration
Les tests d'intégration vérifient l'interaction avec les API réelles de GeoNature.

#### Configuration
1. Copier le fichier de configuration : `cp .env.test.example .env.test`
2. Configurer avec des identifiants réels (déjà configuré pour POPAmphibien/POPReptile)

#### Exécution
```bash
make test-integration              # Tests d'intégration avec vraies requêtes HTTP
make test-integration-manual       # Validation rapide de la configuration
```

Pour plus de détails, voir [la documentation des tests d'intégration](./test/integration/README.md).

## CI/CD

Le projet utilise GitHub Actions pour l'intégration continue :
- Tests unitaires sur chaque push
- Tests d'intégration sur les pull requests vers `develop` et `main`
- Analyse statique du code avec `flutter analyze`

Voir [.github/workflows/integration_tests.yml](.github/workflows/integration_tests.yml) pour la configuration.
