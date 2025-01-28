# Changements concernant le fichier .cursorrules

Nous avons ajouté le fichier `.cursorrules` à la racine du projet pour guider **Cursor**
dans la génération de code adaptée à notre architecture Clean Architecture et nos conventions de développement
(Flutter, Dart, Riverpod, Drift, Freezed, etc.).
Ce fichier n'est pas obligatoire, et il figure dans le gitignore.
Voici une suggestion de contenu pour ce fichier :

```
You are an expert in Flutter, Dart, Riverpod, Drift, Freezed, and Clean Architecture.

////////////////////////////////////////////////////////////////////////
// Flexibility Notice
////////////////////////////////////////////////////////////////////////
// These guidelines describe recommended structures and best practices.
// If the project already follows a different organization, adapt as needed
// while still applying clean code principles and Flutter best practices.
// Always maintain the existing 3-layer architecture (data, domain, presentation),
// plus any feature-based organization if relevant.

////////////////////////////////////////////////////////////////////////
// Flutter Best Practices
////////////////////////////////////////////////////////////////////////

1. Use Flutter 3.x features and Material 3 design patterns when possible.
2. Follow the 3-layer Clean Architecture approach (data/domain/presentation), or
   a feature-based variant that still respects separation of concerns.
3. For state management, prefer Riverpod with best practices:
   - Use `StateNotifier` or `AsyncNotifier` for complex logic.
   - If a project uses BLoC, remain consistent but consider Riverpod for new code.
4. Use proper dependency injection (e.g., Riverpod providers or another DI solution).
5. Implement proper error handling and surface domain-friendly failures.
6. Follow platform-specific design guidelines (iOS/Android).
7. Use proper localization/internationalization techniques (e.g. `intl`).
8. Keep widgets small, with minimal rebuilds; use `const` constructors where possible.

////////////////////////////////////////////////////////////////////////
// Project Structure and Organization
////////////////////////////////////////////////////////////////////////

// Reference structure for gn_mobile_monitoring (adapt or expand as needed):
lib/
  core/
    // errors, helpers, types...
  data/
    datasource/
      interface/
      implementation/
    db/
    entity/
    mapper/
    repository/
  domain/
    model/
    repository/
    usecase/
  presentation/
    viewmodel/
    view/
    state/
main.dart

// If using a feature-based approach, you may group code by feature:
// e.g., lib/features/<feature_name>/data/, domain/, presentation/, shared/
// ... but preserve the data/domain/presentation layers within each feature.

// Guidelines:
- Keep classes and files small and focused; prefer composition over inheritance.
- Use @immutable classes when possible (especially for state/data models).
- Follow existing naming conventions (snake_case filenames, PascalCase classes, etc.).
- Keep domain logic in domain/usecase or domain/repository.
- Keep infrastructure (e.g., DB, network calls) in data/.
- Keep UI in presentation/, with subfolders for screens, widgets, viewmodels, etc.
- If creating “controllers,” place them in the presentation layer (e.g., `viewmodel` or `controllers`).

////////////////////////////////////////////////////////////////////////
// Coding Guidelines
////////////////////////////////////////////////////////////////////////

1. Use proper null safety practices (non-nullable types, `late` only where truly needed).
2. If using functional error handling, prefer `Either<Failure, Value>` or `Result<Failure, Value>`.
3. Naming conventions:
   - Classes, enums, typedefs, and extensions: **UpperCamelCase**.
   - Variables, methods, parameters, constants: **lowerCamelCase**.
   - Files & directories: **snake_case** (e.g., `my_new_repository.dart`).
4. Use official Dart lints (`flutter_lints`) for consistency.
5. Avoid `var` if the type is not obvious; prefer explicit types (`final`, `int`, `String`, etc.).
6. Keep functions short (≈30 lines max). Refactor large functions.
7. Hide internal data logic behind repository interfaces; expose only what the domain/presentation needs.

////////////////////////////////////////////////////////////////////////
// Widget Guidelines
////////////////////////////////////////////////////////////////////////

1. Keep widgets small, single-purpose. Break down large widgets into sub-widgets.
2. Use const constructors whenever possible to reduce rebuilds.
3. Use widget keys in lists or whenever uniqueness is critical.
4. Follow layout best practices and accessibility guidelines (semantics, contrast, etc.).
5. Optimize performance: avoid excessive rebuilds, use memoization or caching if needed.
6. If using feature-based screens, name them `<feature>_screen.dart`, e.g. `home_screen.dart`.

////////////////////////////////////////////////////////////////////////
// Riverpod Guidelines
////////////////////////////////////////////////////////////////////////

1. Organize providers by feature or domain (e.g., `modules_provider`, `sites_provider`, `auth_provider`).
2. Use `ref.watch()` for reactive UI updates, `ref.read()` for one-shot calls (e.g. `login()`).
3. Prefer `autoDispose` if the state should not persist in memory indefinitely.
4. For complex state, use `StateNotifier` or `AsyncNotifier` classes. Keep them in `presentation/viewmodel/`.
5. Combine multiple providers carefully; keep them small and composable.
6. Handle exceptions gracefully—wrap external failures in domain-friendly error classes or pass them through usecases.

////////////////////////////////////////////////////////////////////////
// Drift Guidelines
////////////////////////////////////////////////////////////////////////

1. Organize each table definition logically. Large tables can go in their own file.
2. Use DAO classes with clear naming, e.g., `SitesDao`, `ModulesDao`.
3. Keep `mapper` classes or methods in a dedicated folder for converting DB tables <-> domain entities.
4. Maintain migrations in chronological order; automate incremental migrations if possible.
5. Consider separation: `db/` for DB code, `datasource/implementation/database` for bridging domain/data.

////////////////////////////////////////////////////////////////////////
// Freezed & Immutable Data Classes
////////////////////////////////////////////////////////////////////////

1. Use `freezed` for data models in domain and optionally in presentation if needed.
2. Keep `.freezed.dart` and `.g.dart` in the same folder as the main model file.
3. Mark classes as immutable with `@freezed` and `const` constructors where possible.
4. Ensure naming consistency between domain models and data (DTO) models if both exist.

////////////////////////////////////////////////////////////////////////
// Performance Guidelines
////////////////////////////////////////////////////////////////////////

1. Cache or memoize expensive operations in data layer or Riverpod providers.
2. Optimize lists with `ListView.builder`, `itemCount`, etc. to avoid large in-memory lists.
3. Use `const` constructors whenever possible to reduce widget rebuild overhead.
4. Consider image caching, lazy loading, or placeholders for heavy resources.
5. Monitor memory usage and CPU profiling with DevTools if performance is critical.

////////////////////////////////////////////////////////////////////////
// Testing Guidelines
////////////////////////////////////////////////////////////////////////

1. Write tests for:
   - Usecases (domain logic)
   - Repositories (data access)
   - Data sources (API/DB)
   - Widgets or screens
2. Use `flutter_test` with `WidgetTester` for widget tests; place them in `test/`.
3. Mock or fake dependencies in unit tests as needed.
4. Mirror your `lib/` structure in `test/` to keep organization consistent.
5. Aim for good coverage of domain logic and critical features.
6. Consider integration tests (`integration_test/`) for end-to-end scenarios.

////////////////////////////////////////////////////////////////////////
// Best Practices
////////////////////////////////////////////////////////////////////////

1. Use dependency injection for testability (e.g., Riverpod or other DI container).
2. Avoid singletons or global variables unless absolutely necessary.
3. Adhere to official Flutter & Dart docs for ambiguous cases.
4. Maintain a consistent approach if the project uses something other than Riverpod (BLoC, Provider, etc.), but prefer Riverpod for new code if allowed.
5. Use environment-specific configs (dev, prod) in `config/` or a similar folder if needed.
6. Follow the recommended “feature isolation” approach if it suits your scale, but do not break existing `data/domain/presentation` layering.

////////////////////////////////////////////////////////////////////////
// Additional Notes
////////////////////////////////////////////////////////////////////////
// - If a product-like "features/products" structure is used, ensure it aligns
//   with data/domain/presentation subfolders or your existing structure
//   (datasource, repository, domain, usecases, presentation).
// - Keep consistent naming for all layers (e.g., `feature_name_datasource_impl.dart`).

////////////////////////////////////////////////////////////////////////
// End of .cursorrules
////////////////////////////////////////////////////////////////////////

```

## Principaux Points Couverts

1. **Règles Riverpod**

   - Séparation des providers par fonctionnalité (ex: `auth_provider`, `modules_provider`).
   - Usage de `StateNotifier` ou `AsyncNotifier` pour la logique complexe.
   - Gestion élégante des erreurs (par ex., classes de Failure).

2. **Organisation du Code**

   - Maintien des trois couches : `data/`, `domain/`, `presentation/`.
   - Mise en avant de classes et fichiers **concis** et **cohérents**.
   - Recommandation d’utiliser `@freezed` pour créer des entités immuables.

3. **Performance et Tests**
   - Adoption des `const constructors` quand c’est possible, pour réduire les rebuilds.
   - Encouragement à l’écriture de tests unitaires pour chaque use case, repository, etc.
   - Suivi des bonnes pratiques pour éviter les ralentissements et faciliter la maintenance.

## Pourquoi .cursorrules est Important

- **Cursor** lit ce fichier pour proposer des complétions **qui respectent** notre archi et nos conventions.
- Il **évite** de proposer du code ou des structures contraires à nos pratiques (ex: code `BLoC` si on utilise `Riverpod`).
- Il **accélère** la production de code et **améliore** la cohérence du projet.

---
