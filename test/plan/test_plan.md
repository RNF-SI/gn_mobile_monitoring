# Plan de Tests pour GN Mobile Monitoring

Ce document détaille les tests à implémenter pour couvrir l'ensemble de l'application selon l'approche TDD.

## 1. Couche Data (Repository)

| Repository | Status | Priorité |
|------------|--------|----------|
| `ModulesRepository` | ✅ Testé | - |
| `SitesRepository` | ✅ Testé | - |
| `AuthenticationRepository` | ✅ Testé | - |
| `GlobalDatabaseRepository` | ❌ Non testé | 2 - Moyenne |
| `LocalStorageRepository` | ✅ Testé | - |

## 2. Couche Domain (UseCases)

| UseCase | Status | Priorité |
|---------|--------|----------|
| `GetModulesUseCase` | ✅ Testé | - |
| `FetchModulesUseCase` | ✅ Testé | - |
| `GetSitesUseCase` | ✅ Testé | - |
| `FetchSitesUseCase` | ✅ Testé | - |
| `GetSiteGroupsUseCase` | ✅ Testé | - |
| `FetchSiteGroupsUseCase` | ✅ Testé | - |
| `LoginUseCase` | ✅ Testé | - |
| `DownloadModuleDataUseCase` | ✅ Testé | - |
| `InitLocalMonitoringDatabaseUseCase` | ❌ Non testé | 2 - Moyenne |
| `DeleteLocalMonitoringDatabaseUseCase` | ❌ Non testé | 2 - Moyenne |
| `IncrementalSyncAllUseCase` | ❌ Non testé | 2 - Moyenne |
| Use cases de stockage local | ❌ Non testés | 3 - Basse |

## 3. Couche Presentation (ViewModels)

| ViewModel | Status | Priorité |
|-----------|--------|----------|
| `UserModulesViewModel` | ✅ Testé | - |
| `SitesUtilisateurViewModel` | ✅ Testé | - |
| `SiteGroupsUtilisateurViewModel` | ✅ Testé | - |
| `AuthViewModel` | ✅ Testé | - |
| `DatabaseService` | ❌ Non testé | 2 - Moyenne |
| `SyncService` | ❌ Non testé | 2 - Moyenne |

## 4. Couche Presentation (Widgets)

| Widget | Status | Priorité |
|--------|--------|----------|
| `ModuleListWidget` | ✅ Testé | - |
| `SiteListWidget` | ✅ Testé | - |
| `SiteGroupListWidget` | ✅ Testé | - |
| `LoginPage` | ✅ Testé | - |
| `HomePage` | ✅ Testé | - |
| `ModuleItemCardWidget` | ❌ Non testé | 2 - Moyenne |
| `ModuleDownloadButton` | ❌ Non testé | 2 - Moyenne |
| `SyncStatusWidget` | ❌ Non testé | 2 - Moyenne |
| `MenuActions` | ❌ Non testé | 2 - Moyenne |
| `AuthChecker` | ✅ Testé | - |
| `ModuleDetailPage` | ❌ Non testé | 2 - Moyenne |
| `ErrorScreen` | ❌ Non testé | 3 - Basse |
| `LoadingScreen` | ❌ Non testé | 3 - Basse |

## 5. Tests d'intégration

| Intégration | Status | Priorité |
|-------------|--------|----------|
| `Repository -> ViewModel (Modules)` | ✅ Testé | - |
| `Repository -> ViewModel (Sites)` | ✅ Testé | - |
| `Repository -> ViewModel (SiteGroups)` | ✅ Testé | - |
| `AuthRepository -> AuthViewModel` | ✅ Testé | - |
| `DatabaseService -> Repositories` | ❌ Non testé | 2 - Moyenne |
| `SyncService -> Repositories` | ❌ Non testé | 2 - Moyenne |
| `End-to-End (Auth -> Modules -> Sites)` | ❌ Non testé | 3 - Basse |

## 6. Correction des tests échoués

| Problème | Status | Solution |
|----------|--------|----------|
| Tests auth_repository_viewmodel_test | ✅ Corrigé | Simplification de l'implémentation des mocks |
| Tests auth_view_model_test | ✅ Corrigé | Réécriture des tests avec mocks simplifiés |
| Tests des exceptions dans FetchModulesUseCase | ✅ Corrigé | Suppression des sorties de log dans les tests |
| Tests de l'interface LoginPage | ✅ Corrigé | Adaptation aux patterns de conception UI de la page |

## Plan d'implémentation

### Progression actuelle (état au 11/03/2025)
✅ Tous les tests existants ont été réparés et passent avec succès
✅ Tous les composants prioritaires (Priorité 1) ont été testés
❌ Prochaines étapes à effectuer :

### Phase 2 : Tests importants (Priorité 2)
1. UseCases de synchronisation restants
2. ViewModels de service (`DatabaseService`, `SyncService`)
3. Widgets secondaires (`ModuleItemCardWidget`, `ModuleDownloadButton`, etc.)
4. Tests d'intégration des services

### Phase 3 : Tests complémentaires (Priorité 3)
1. UseCases de gestion locale
2. Widgets d'UI auxiliaires 
3. Tests d'intégration end-to-end

## Approche TDD recommandée

Pour chaque composant à tester :

1. Créer le template de test avec `dart scripts/test_utils/create_tdd_test.dart <type> <nom_classe>`
2. Implémenter les tests selon l'approche Red-Green-Refactor
3. Vérifier que le composant s'intègre correctement avec le reste du système

## Bonnes pratiques identifiées lors des corrections

1. **Gestion des sorties de console** :
   - Utiliser la fonction utilitaire `suppressOutput` de `mocks.dart` pour éviter que les logs d'erreur n'apparaissent dans la sortie des tests
   - Cette approche est particulièrement utile pour les tests qui vérifient le comportement de gestion d'erreur

2. **Simplification des mocks** :
   - Éviter les mocks trop complexes qui dépendent d'autres mocks
   - Préférer des mocks simples et directs qui testent une seule responsabilité
   - Utiliser des fallback values pour les types fréquemment utilisés

3. **Tests d'interface utilisateur** :
   - Prendre en compte l'état de l'interface (comme _isLoading) lors de l'écriture des tests
   - Utiliser des patterns de test adaptés aux composants d'UI testés
   - Contrôler les opérations asynchrones dans les tests pour qu'ils soient fiables
   - Utiliser tester.pumpAndSettle() avec précaution, avec un timeout si nécessaire