---
alwaysApply: true
---
# GeoNature Mobile Monitoring - Cursor Rules

## Project Overview
This is a Flutter mobile app for field data collection in the GeoNature ecosystem. It follows Clean Architecture with strict separation of concerns.

## Essential Commands
Always run these commands from the project root:
- `make generate_code` - Run after ANY model changes (required!)
- `make run` - Start app in debug mode
- `make test` - Run all tests
- `make test-unit` - Run unit tests only
- `make test-integration` - Run integration tests
- `make format` - Format code
- `make analyze` - Analyze code
- `make apk` - Build Android APK

## Architecture Rules
Follow Clean Architecture strictly:
- **lib/data/** - Infrastructure layer (APIs, database, repositories)
- **lib/domain/** - Business logic layer (models, interfaces, use cases)
- **lib/presentation/** - UI layer (views, viewmodels, widgets)

## Code Generation
CRITICAL: Always run `make generate_code` after modifying:
- @freezed annotated classes
- Drift database schema
- @JsonSerializable classes

## Key Technologies
- State Management: Riverpod with hooks_riverpod
- Database: Drift (SQLite ORM)
- Navigation: GoRouter
- Immutable Models: Freezed
- HTTP Client: Dio

## Development Workflow
1. Start with domain models and use cases
2. Define repository interface in domain, implement in data layer
3. Use Riverpod StateNotifier or AsyncNotifier for state
4. Write tests for each layer (TDD approach)
5. Run `make generate_code` before testing/running

## File Naming Conventions
- Files: snake_case (e.g., user_repository.dart)
- Classes: PascalCase (e.g., UserRepository)
- Variables/Methods: lowerCamelCase (e.g., getUserData())

## Testing Requirements
- Mirror lib/ structure in test/ directory
- Write unit tests for use cases, repositories, and datasources
- Write widget tests for UI components
- Use mocks for external dependencies

## Common Patterns

### Domain Model (Freezed)
```dart
@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    String? email,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### Use Case
```dart
@riverpod
class GetUserUseCase extends _$GetUserUseCase {
  Future<User> call(int userId) {
    return ref.read(userRepositoryProvider).getUser(userId);
  }
}
```

### Repository Implementation
```dart
// Domain interface
abstract class UserRepository {
  Future<User> getUser(int id);
}

// Data implementation
class UserRepositoryImpl implements UserRepository {
  final UserApiDataSource _apiDataSource;
  final UserDatabaseDataSource _databaseDataSource;
  
  // Implementation...
}
```

### ViewModel
```dart
@riverpod
class UserViewModel extends _$UserViewModel {
  @override
  Future<User> build(int userId) async {
    return ref.read(getUserUseCaseProvider).call(userId);
  }
}
```

## Error Handling
- Use custom exceptions from lib/core/errors/
- Handle errors at presentation layer
- Provide meaningful error messages

## Important Notes
- Flutter version: 3.22.3
- Use autoDispose for non-persistent Riverpod providers
- Generated files (*.freezed.dart, *.g.dart) are excluded from analysis
- Follow existing patterns for consistency
- This is an offline-first mobile app with sync capabilities

## Integration with GeoNature
- Backend API: Flask/Python GeoNature instance
- Authentication: JWT tokens
- Data sync: Periodic synchronization with server
- Offline mode: SQLite database for offline data collection

## Before Committing
1. Run `make format`
2. Run `make analyze` (warnings OK, errors must be fixed)
3. Run `make test`
4. Ensure all generated code is up to date

## Helper Scripts
Use scripts in scripts/ directory for boilerplate generation:
- create_data_source_api.dart - Generate API datasource
- create_data_source_database.dart - Generate database datasource
- create_repository.dart - Generate repository
- create_usecase.dart - Generate use case
- test_utils/create_tdd_test.dart - Generate test templates