# Plan de Tests pour GN Mobile Monitoring

Ce document détaille les tests à implémenter pour couvrir l'ensemble de l'application selon l'approche TDD.

## 1. Couche Data (Repository)

| Repository | Status | Priorité |
|------------|--------|----------|
| `ModulesRepository` | ✅ Testé partiellement | 2 - Ajouter tests manquants |
| `SitesRepository` | ✅ Testé | - |
| `AuthenticationRepository` | ✅ Testé | - |
| `GlobalDatabaseRepository` | ❌ Non testé | 2 - Moyenne |
| `LocalStorageRepository` | ❌ Non testé | 1 - Haute |

## 2. Couche Domain (UseCases)

| UseCase | Status | Priorité |
|---------|--------|----------|
| `GetModulesUseCase` | ✅ Testé | - |
| `FetchModulesUseCase` | ❌ Non testé | 1 - Haute |
| `GetSitesUseCase` | ✅ Testé | - |
| `FetchSitesUseCase` | ❌ Non testé | 1 - Haute |
| `GetSiteGroupsUseCase` | ✅ Testé | - |
| `FetchSiteGroupsUseCase` | ❌ Non testé | 1 - Haute |
| `LoginUseCase` | ✅ Testé | - |
| `DownloadModuleDataUseCase` | ❌ Non testé | 1 - Haute |
| `InitLocalMonitoringDatabaseUseCase` | ❌ Non testé | 2 - Moyenne |
| `DeleteLocalMonitoringDatabaseUseCase` | ❌ Non testé | 2 - Moyenne |
| `IncrementalSyncAllUseCase` | ❌ Non testé | 2 - Moyenne |
| Use cases de stockage local | ❌ Non testés | 3 - Basse |

## 3. Couche Presentation (ViewModels)

| ViewModel | Status | Priorité |
|-----------|--------|----------|
| `UserModulesViewModel` | ✅ Testé partiellement | 2 - Ajouter tests manquants |
| `SitesUtilisateurViewModel` | ❌ Non testé | 1 - Haute |
| `SiteGroupsUtilisateurViewModel` | ❌ Non testé | 1 - Haute |
| `AuthViewModel` | ❌ Non testé | 1 - Haute |
| `DatabaseService` | ❌ Non testé | 2 - Moyenne |
| `SyncService` | ❌ Non testé | 2 - Moyenne |

## 4. Couche Presentation (Widgets)

| Widget | Status | Priorité |
|--------|--------|----------|
| `ModuleListWidget` | ✅ Testé | - |
| `SiteListWidget` | ❌ Non testé | 1 - Haute |
| `SiteGroupListWidget` | ❌ Non testé | 1 - Haute |
| `LoginPage` | ❌ Non testé | 1 - Haute |
| `HomePage` | ❌ Non testé | 1 - Haute |
| `ModuleItemCardWidget` | ❌ Non testé | 2 - Moyenne |
| `ModuleDownloadButton` | ❌ Non testé | 2 - Moyenne |
| `SyncStatusWidget` | ❌ Non testé | 2 - Moyenne |
| `MenuActions` | ❌ Non testé | 2 - Moyenne |
| `AuthChecker` | ❌ Non testé | 1 - Haute |
| `ModuleDetailPage` | ❌ Non testé | 2 - Moyenne |
| `ErrorScreen` | ❌ Non testé | 3 - Basse |
| `LoadingScreen` | ❌ Non testé | 3 - Basse |

## 5. Tests d'intégration

| Intégration | Status | Priorité |
|-------------|--------|----------|
| `Repository -> ViewModel (Modules)` | ✅ Testé | - |
| `Repository -> ViewModel (Sites)` | ❌ Non testé | 1 - Haute |
| `Repository -> ViewModel (SiteGroups)` | ❌ Non testé | 1 - Haute |
| `AuthRepository -> AuthViewModel` | ❌ Non testé | 1 - Haute |
| `DatabaseService -> Repositories` | ❌ Non testé | 2 - Moyenne |
| `SyncService -> Repositories` | ❌ Non testé | 2 - Moyenne |
| `End-to-End (Auth -> Modules -> Sites)` | ❌ Non testé | 3 - Basse |

## Plan d'implémentation

### Phase 1 : Tests critiques (Priorité 1)
1. Repositories d'accès aux données principales (Sites, Auth)
2. UseCases clés (Login, Sites, SiteGroups)
3. ViewModels principaux (Auth, Sites, SiteGroups)
4. Widgets essentiels (LoginPage, HomePage, AuthChecker)
5. Tests d'intégration des flux principaux

### Phase 2 : Tests importants (Priorité 2)
1. Repositories secondaires
2. UseCases de synchronisation
3. ViewModels de service
4. Widgets secondaires
5. Tests d'intégration des services

### Phase 3 : Tests complémentaires (Priorité 3)
1. UseCases de gestion locale
2. Widgets d'UI auxiliaires 
3. Tests d'intégration end-to-end

## Approche TDD recommandée

Pour chaque composant à tester :

1. Créer le template de test avec `dart scripts/test_utils/create_tdd_test.dart <type> <nom_classe>`
2. Implémenter les tests selon l'approche Red-Green-Refactor
3. Vérifier que le composant s'intègre correctement avec le reste du système