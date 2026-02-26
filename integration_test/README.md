# Tests End-to-End (E2E)

Tests d'intégration E2E pour gn_mobile_monitoring, utilisant `integration_test` (Flutter natif).

## Architecture

```
integration_test/
├── e2e_test_app.dart                # Factory ProviderScope avec overrides
├── helpers/
│   ├── fixture_loader.dart          # Chargement JSON depuis fichiers
│   ├── in_memory_local_storage.dart # LocalStorageRepository in-memory
│   └── mock_connectivity.dart       # Connectivity mock (toujours wifi)
├── mocks/
│   ├── mock_api_interceptor.dart    # Dio Interceptor principal
│   └── mock_api_handlers.dart       # Sets de handlers pré-configurés
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
└── scenarios/                       # Tests E2E
    ├── auth_e2e_test.dart
    ├── module_browsing_e2e_test.dart
    ├── site_management_e2e_test.dart
    ├── visit_workflow_e2e_test.dart
    ├── observation_workflow_e2e_test.dart
    ├── sync_e2e_test.dart
    └── full_user_journey_e2e_test.dart
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
