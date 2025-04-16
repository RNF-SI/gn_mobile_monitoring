# Plan de Tests pour GN Mobile Monitoring

Ce document détaille les tests à implémenter pour couvrir l'ensemble de l'application selon l'approche TDD.

## 1. Couche Data (Repository)

| Repository                     | Status       | Priorité    |
| ------------------------------ | ------------ | ----------- |
| `ModulesRepository`            | ✅ Testé     | -           |
| `SitesRepository`              | ✅ Testé     | -           |
| `AuthenticationRepository`     | ✅ Testé     | -           |
| `GlobalDatabaseRepository`     | ❌ Non testé | 2 - Moyenne |
| `LocalStorageRepository`       | ✅ Testé     | -           |
| `ObservationsRepository`       | ✅ Testé     | -           |
| `ObservationDetailsRepository` | ✅ Testé     | -           |
| `VisitRepository`              | ✅ Testé     | -           |
| `TaxonRepository`              | ✅ Testé     | -           |
| `NomenclaturesDatabase`        | ✅ Testé     | -           |

## 2. Couche Domain (UseCases)

| UseCase                                          | Status        | Priorité    |
| ------------------------------------------------ | ------------- | ----------- |
| `GetModulesUseCase`                              | ✅ Testé      | -           |
| `FetchModulesUseCase`                            | ✅ Testé      | -           |
| `GetSitesUseCase`                                | ✅ Testé      | -           |
| `FetchSitesUseCase`                              | ✅ Testé      | -           |
| `GetSiteGroupsUseCase`                           | ✅ Testé      | -           |
| `FetchSiteGroupsUseCase`                         | ✅ Testé      | -           |
| `LoginUseCase`                                   | ✅ Testé      | -           |
| `DownloadModuleDataUseCase`                      | ✅ Testé      | -           |
| `InitLocalMonitoringDatabaseUseCase`             | ✅ Testé      | -           |
| `DeleteLocalMonitoringDatabaseUseCase`           | ✅ Testé      | -           |
| `IncrementalSyncAllUseCase`                      | ✅ Testé      | -           |
| `CreateObservationUseCase`                       | ✅ Testé      | -           |
| `UpdateObservationUseCase`                       | ✅ Testé      | -           |
| `DeleteObservationUseCase`                       | ✅ Testé      | -           |
| `GetObservationByIdUseCase`                      | ✅ Testé      | -           |
| `GetObservationsbyVisitIdUseCase`                | ✅ Testé      | -           |
| `CreateVisitUseCase`                             | ✅ Testé      | -           |
| `UpdateVisitUseCase`                             | ✅ Testé      | -           |
| `DeleteVisitUseCase`                             | ✅ Testé      | -           |
| `GetVisitComplementUseCase`                      | ✅ Testé      | -           |
| `SaveVisitComplementUseCase`                     | ✅ Testé      | -           |
| `GetVisitWithDetailsUseCase`                     | ✅ Testé      | -           |
| `SaveObservationDetailUseCase`                   | ✅ Testé      | -           |
| `GetObservationDetailByIdUseCase`                | ✅ Testé      | -           |
| `GetObservationDetailsByObservationIdUseCase`    | ✅ Testé      | -           |
| `DeleteObservationDetailUseCase`                 | ✅ Testé      | -           |
| `DeleteObservationDetailsByObservationIdUseCase` | ✅ Testé      | -           |
| Use cases de stockage local                      | ❌ Non testés | 3 - Basse   |
| `DownloadModuleTaxonsUseCase`                    | ✅ Testé      | -           |
| `GetModuleTaxonsUseCase`                         | ✅ Testé      | -           |
| `SaveTaxonUseCase`                               | ❌ Non testé  | 2 - Moyenne |
| `GetTaxonByIdUseCase`                            | ✅ Testé      | -           |
| `GetTaxonsByListIdUseCase`                       | ✅ Testé      | -           |
| `SearchTaxonsByListIdUseCase`                    | ✅ Testé      | -           |
| `GetNomenclatureTypesUseCase`                    | ✅ Testé      | -           |
| `GetNomenclaturesByTypeUseCase`                  | ✅ Testé      | -           |

## 3. Couche Presentation (ViewModels)

| ViewModel                        | Status       | Priorité    |
| -------------------------------- | ------------ | ----------- |
| `UserModulesViewModel`           | ✅ Testé     | -           |
| `SitesUtilisateurViewModel`      | ✅ Testé     | -           |
| `SiteGroupsUtilisateurViewModel` | ✅ Testé     | -           |
| `AuthViewModel`                  | ✅ Testé     | -           |
| `DatabaseService`                | ❌ Non testé | 2 - Moyenne |
| `SyncService`                    | ❌ Non testé | 2 - Moyenne |
| `SiteVisitsViewModel`            | ✅ Testé     | -           |
| `ObservationsViewModel`          | ✅ Testé     | -           |
| `ObservationDetailViewModel`     | ✅ Testé     | -           |
| `TaxonService`                   | ✅ Testé     | -           |
| `NomenclatureService`            | ✅ Testé     | -           |

## 4. Couche Presentation (Widgets/Pages)

| Widget/Page                   | Status       | Priorité    |
| ----------------------------- | ------------ | ----------- |
| `ModuleListWidget`            | ✅ Testé     | -           |
| `SiteListWidget`              | ✅ Testé     | -           |
| `SiteGroupListWidget`         | ✅ Testé     | -           |
| `LoginPage`                   | ✅ Testé     | -           |
| `HomePage`                    | ✅ Testé     | -           |
| `ModuleItemCardWidget`        | ❌ Non testé | 2 - Moyenne |
| `ModuleDownloadButton`        | ❌ Non testé | 2 - Moyenne |
| `SyncStatusWidget`            | ❌ Non testé | 2 - Moyenne |
| `MenuActions`                 | ❌ Non testé | 2 - Moyenne |
| `AuthChecker`                 | ✅ Testé     | -           |
| `ModuleDetailPage`            | ✅ Testé     | -           |
| `SiteDetailPage`              | ✅ Testé     | -           |
| `VisitDetailPage`             | ✅ Testé     | -           |
| `VisitFormPage`               | ✅ Testé     | -           |
| `ObservationFormPage`         | ✅ Testé     | -           |
| `ObservationDetailPage`       | ✅ Testé     | -           |
| `ObservationDetailFormPage`   | ✅ Testé     | -           |
| `ObservationDetailDetailPage` | ✅ Testé     | -           |
| `DynamicFormBuilder`          | ✅ Testé     | -           |
| `PropertyDisplayWidget`       | ❌ Non testé | 2 - Moyenne |
| `BreadcrumbNavigation`        | ❌ Non testé | 2 - Moyenne |
| `ErrorScreen`                 | ❌ Non testé | 3 - Basse   |
| `LoadingScreen`               | ❌ Non testé | 3 - Basse   |
| `TaxonSelectorWidget`         | ✅ Testé     | -           |
| `FormConfigParser`            | ✅ Testé     | -           |

## 5. Tests d'intégration

| Intégration                                                       | Status       | Priorité    |
| ----------------------------------------------------------------- | ------------ | ----------- |
| `Repository -> ViewModel (Modules)`                               | ✅ Testé     | -           |
| `Repository -> ViewModel (Sites)`                                 | ✅ Testé     | -           |
| `Repository -> ViewModel (SiteGroups)`                            | ✅ Testé     | -           |
| `AuthRepository -> AuthViewModel`                                 | ✅ Testé     | -           |
| `DatabaseService -> Repositories`                                 | ❌ Non testé | 2 - Moyenne |
| `SyncService -> Repositories`                                     | ❌ Non testé | 2 - Moyenne |
| `VisitRepository -> SiteVisitsViewModel`                          | ❌ Non testé | 2 - Moyenne |
| `ObservationsRepository -> ObservationsViewModel`                 | ❌ Non testé | 2 - Moyenne |
| `ObservationDetailsRepository -> ObservationDetailViewModel`      | ❌ Non testé | 2 - Moyenne |
| `End-to-End (Auth -> Modules -> Sites -> Visits -> Observations)` | ❌ Non testé | 3 - Basse   |
| `TaxonRepository -> TaxonService`                                 | ✅ Testé     | -           |
| `NomenclaturesRepository -> NomenclatureService`                  | ✅ Testé     | -           |
| `TaxonService -> TaxonSelectorWidget`                             | ✅ Testé     | -           |
| `TaxonRepository -> DynamicFormBuilder`                           | ❌ Non testé | 2 - Moyenne |

## 6. Tests des nouvelles fonctionnalités

| Fonctionnalité | Status | Priorité |
|----------------|--------|----------|
| Flux de travail des observations | ✅ Testé | - |
| Flux de travail des détails d'observation | ✅ Testé | - |
| Gestion des visites nouvelles vs existantes (isNewVisit) | ❌ Non testé | 2 - Moyenne |
| Gestion des observations nouvelles vs existantes (isNewObservation) | ❌ Non testé | 2 - Moyenne |
| Navigation par fil d'Ariane | ❌ Non testé | 2 - Moyenne |
| Affichage des données structurées | ❌ Non testé | 2 - Moyenne |
| Chaînage des saisies (enchaînement des formulaires) | ✅ Testé | - |
| Sélection et validation des taxons | ✅ Testé | - |
| Gestion des listes taxonomiques | ✅ Testé | - |
| Persistance des taxons et nomenclatures | ✅ Testé | - |
| Recherche et filtrage des taxons | ✅ Testé | - |
| Configuration des champs taxonomie et nomenclature | ✅ Testé | - |
| Téléchargement et synchronisation des taxons | ✅ Testé | - |

## 7. Correction des tests échoués

| Problème                                      | Status     | Solution                                            |
| --------------------------------------------- | ---------- | --------------------------------------------------- |
| Tests auth_repository_viewmodel_test          | ✅ Corrigé | Simplification de l'implémentation des mocks        |
| Tests auth_view_model_test                    | ✅ Corrigé | Réécriture des tests avec mocks simplifiés          |
| Tests des exceptions dans FetchModulesUseCase | ✅ Corrigé | Suppression des sorties de log dans les tests       |
| Tests de l'interface LoginPage                | ✅ Corrigé | Adaptation aux patterns de conception UI de la page |

## Plan d'implémentation

### Progression actuelle (état au 15/04/2025)

✅ Tous les tests existants ont été réparés et passent avec succès
✅ Tous les composants prioritaires initiaux (Priorité 1) ont été testés
✅ Tests pour TaxonRepository implémentés et fonctionnels
✅ Tests pour TaxonSelectorWidget implémentés et fonctionnels
✅ Tests des Use Cases de nomenclatures vérifiés et fonctionnels
✅ Tests pour NomenclatureService corrigés et fonctionnels 
✅ Tests pour les use cases de taxons implémentés et fonctionnels
✅ Tests pour TaxonService implémentés et fonctionnels
✅ Tests pour FormConfigParser concernant les taxons et nomenclatures implémentés
✅ Tests pour le chaînage des saisies implémentés
✅ La Phase 0 est complétée avec 46 tests qui passent sur 46
✅ NomenclaturesDatabase entièrement testé

### Phase 1 : Tests restants de priorité moyenne (Priorité 2)
1. Tests pour SaveTaxonUseCase
2. Tests pour services (DatabaseService, SyncService)
3. Tests pour widgets auxiliaires (PropertyDisplayWidget, BreadcrumbNavigation, etc.)
4. Tests d'intégration pour les observations, visites et détails d'observation
5. Tests d'intégration supplémentaire (TaxonRepository -> DynamicFormBuilder)
6. Tests des nouvelles fonctionnalités (isNewVisit, isNewObservation, etc.)

### Phase 2 : Tests complémentaires (Priorité 3)

1. UseCases de gestion locale
2. Widgets d'UI auxiliaires (ErrorScreen, LoadingScreen, etc.)
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

   - Prendre en compte l'état de l'interface (comme \_isLoading) lors de l'écriture des tests
   - Utiliser des patterns de test adaptés aux composants d'UI testés
   - Contrôler les opérations asynchrones dans les tests pour qu'ils soient fiables
   - Utiliser tester.pumpAndSettle() avec précaution, avec un timeout si nécessaire

4. **Tests des flags booléens** :

   - Tester à la fois true et false pour les nouveaux flags comme isNewVisit et isNewObservation
   - Vérifier les comportements conditionnels associés à ces flags

5. **Tests des dialogues** :
   - Vérifier que les dialogues de proposition s'affichent correctement dans les bonnes conditions
   - Tester les actions associées aux boutons des dialogues

6. **Tests des taxons et nomenclatures** :
   - Tester les différentes façons de spécifier une liste taxonomique
   - Vérifier la recherche et le filtrage des taxons par liste
   - Tester la validation des taxons par rapport aux listes configurées
   - Vérifier l'intégration et l'affichage dans les formulaires dynamiques

7. **Tests d'enchaînement des saisies** :
   - Tester l'activation/désactivation du chaînage des formulaires
   - Vérifier la persistance de l'état d'enchaînement entre les formulaires
   - Tester la réinitialisation correcte des formulaires lors de l'enchaînement