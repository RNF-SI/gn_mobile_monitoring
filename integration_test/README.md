# Tests End-to-End (E2E)

Tests d'intégration E2E pour gn_mobile_monitoring, utilisant `integration_test` (Flutter natif).

## Architecture

```
integration_test/
├── e2e_test_app.dart                # Factory ProviderScope avec overrides
├── e2e_test_app_real.dart           # Variante contre un vrai serveur GeoNature
├── helpers/
│   ├── fake_get_user_location.dart  # Stub de localisation GPS pour les tests
│   ├── fixture_data.dart            # Données de référence en mémoire
│   ├── fixture_loader.dart          # Chargement JSON depuis fichiers
│   ├── in_memory_local_storage.dart # LocalStorageRepository in-memory
│   ├── mock_connectivity.dart       # Connectivity mock (toujours wifi)
│   └── test_data_seeder.dart        # Seeder des bases mock (user, modules, sites...)
├── mocks/
│   ├── mock_api_interceptor.dart    # Dio Interceptor principal
│   ├── mock_api_handlers.dart       # Sets de handlers pré-configurés
│   └── mock_databases.dart          # Implémentations in-memory de tous les *Database
├── fixtures/                        # Données JSON de test
│   ├── auth/
│   ├── modules/
│   ├── sites/
│   ├── visits/
│   ├── observations/
│   ├── nomenclatures/
│   ├── taxons/
│   └── datasets/
├── robots/                          # Pattern Robot (un par page)
│   ├── base_robot.dart
│   ├── login_robot.dart
│   ├── home_robot.dart
│   ├── module_detail_robot.dart
│   ├── site_detail_robot.dart
│   ├── visit_form_robot.dart
│   ├── observation_form_robot.dart
│   └── sync_robot.dart
├── scenarios/                       # Tests E2E mock (APIs simulées)
│   ├── audit_bugs_e2e_test.dart     # Non-régression des formulaires (audit 09/2026)
│   ├── auth_e2e_test.dart
│   ├── module_browsing_e2e_test.dart
│   ├── site_management_e2e_test.dart
│   ├── site_geometry_e2e_test.dart
│   ├── site_lifecycle_e2e_test.dart
│   ├── visit_workflow_e2e_test.dart
│   ├── observation_workflow_e2e_test.dart
│   ├── sync_e2e_test.dart
│   ├── visit_stats_e2e_test.dart
│   └── full_user_journey_e2e_test.dart
└── scenarios_real/                  # Tests E2E réels (voir docs/E2E_REAL_API_TESTS.md)
    ├── helpers/real_test_helpers.dart
    ├── real_auth_e2e_test.dart
    ├── real_module_browsing_e2e_test.dart
    ├── real_site_management_e2e_test.dart
    ├── real_site_group_e2e_test.dart
    ├── real_visit_workflow_e2e_test.dart
    ├── real_observation_workflow_e2e_test.dart
    ├── real_sync_download_e2e_test.dart
    └── real_sync_upload_e2e_test.dart
```

## Approche

### Mock au niveau HTTP (Dio Interceptor)

Toute la chaîne applicative est testée :
```
Widget → ViewModel → UseCase → Repository → API Impl → Dio → MockApiInterceptor → Fixture JSON
```

### Pattern Robot

Chaque page a un "robot" qui encapsule les interactions :
```dart
final loginRobot = LoginRobot(tester);
await loginRobot.login(identifiant: 'user', password: 'pass');
```

## Exécution

```bash
# Tous les tests E2E (nécessite un émulateur Android)
flutter test integration_test/

# Un scénario spécifique
flutter test integration_test/scenarios/auth_e2e_test.dart
```

### Si `flutter test` échoue au build Gradle (JDK)

`flutter test` compile avec le JDK d'Android Studio, que Gradle 8.7 peut refuser. Le script suivant compile l'APK via `gradlew` avec le JDK 17 puis lance le test avec `flutter drive` :

```bash
scripts/run_device_test.sh integration_test/scenarios/<test>.dart emulator-5554
```

### Non-régression des formulaires

`scenarios/audit_bugs_e2e_test.dart` (19 scénarios) rejoue les bugs relevés puis corrigés lors de l'audit de septembre 2026 (voir `docs/FEATURES_OVERVIEW.md`, « Bugs corrigés »), dont des extraits de configurations réelles de protocoles_suivi (POPAmphibien, pt_ecoute_avifaune, RHOMEOFlore, suivi_loutre, suivi_terriers_blaireau, popanomaloglossus, stom, petite_chouette_montagne). Chaque test vérifie le comportement du module web : un échec signifie qu'un bug est revenu. Les tests « Témoin » vérifient le banc de test.

### Échec connu indépendant du code

`site_geometry_e2e_test.dart` › « Édition d'un site LineString » peut échouer par une `SocketException` sur `tile.openstreetmap.org` (errno 101) levée après la fin du test : l'émulateur n'atteint pas le serveur de tuiles (IPv6). L'échec se reproduit à l'identique sur le code antérieur à l'audit (vérifié en septembre 2026).

## Ajout d'un nouveau test

1. Ajouter les fixtures JSON dans `fixtures/`
2. Créer/mettre à jour un robot dans `robots/` si besoin
3. Enregistrer les handlers dans `mock_api_handlers.dart`
4. Créer le scénario dans `scenarios/`

## Keys des widgets

Les widgets clés ont des `Key` pour les retrouver dans les tests :
- `login-identifiant-field`, `login-password-field`, `login-button`
- `module-card-{moduleCode}`
- `menu-{value}` (logout, sync_download, etc.)
- `create-site-button`, `create-site-group-button`
- `edit-site-button`, `create-visit-button`
- `add-observation-button`
- `form-save-button`, `form-cancel-button`
