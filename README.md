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

## Compatibilité des versions

| Version app mobile | Version minimale monitoring |
|---|---|
| 1.0.0+ | 1.2.0 |

L'application vérifie automatiquement la version du module monitoring sur le serveur avant chaque téléchargement de module. Si la version est inférieure à la version minimale requise, le téléchargement est bloqué avec un message explicatif.

## Déploiement et mise à jour

### Publier une nouvelle version

1. Compiler l'APK : `flutter build apk --release`
2. Créer une release sur GitHub avec l'APK en pièce jointe

### Configurer le serveur GeoNature

Pour que les utilisateurs soient notifiés des mises à jour, l'administrateur du serveur GeoNature doit :

1. **Créer le dossier et le fichier de configuration** :
   ```bash
   mkdir -p <GEONATURE>/backend/media/mobile/monitoring/
   echo '{}' > <GEONATURE>/backend/media/mobile/monitoring/settings.json
   ```

2. **Déposer l'APK** (téléchargé depuis les releases GitHub) :
   ```bash
   cp monitoring-x.y.z.apk <GEONATURE>/backend/media/mobile/monitoring/monitoring.apk
   ```

3. **Enregistrer l'application** dans l'admin GeoNature :
   - Aller dans **Administration > Autres > Applications mobiles**
   - Créer une entrée avec :

   | Champ | Valeur |
   |-------|--------|
   | Code application | `MONITORING` |
   | Chemin relatif de l'APK | `monitoring/monitoring.apk` |
   | Nom du paquet | `fr.geonature.monitoring` |
   | Code de version | Le buildNumber de la version (ex: `2`) |

4. **Mettre à jour** : lors d'une nouvelle version, remplacer l'APK et incrémenter le **Code de version** dans l'admin.

L'application vérifie automatiquement au lancement et après chaque synchronisation si une mise à jour est disponible.

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
