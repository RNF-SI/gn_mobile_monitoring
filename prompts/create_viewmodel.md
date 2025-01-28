---

## 3. `create_viewmodel.prompt`

**File Name**: `create_viewmodel.prompt`

**Description**: Generates a new `StateNotifier` or `AsyncNotifier` for Riverpod.

````md
# create_viewmodel.prompt

You are an expert in Flutter, Dart, and Riverpod.

Create a new ViewModel in `presentation/viewmodel/` that uses Riverpod’s `StateNotifier` or `AsyncNotifier`.
The ViewModel class must:

- Have a private state class or a `freezed` state.
- Expose methods for updating the state.
- Follow Clean Architecture (call usecases from domain layer).

**Template**:

```dart
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// TODO: Import usecases

part '{{viewmodel_name.snakeCase()}}_state.freezed.dart';

@freezed
class {{viewmodel_name.pascalCase()}}State with _${{viewmodel_name.pascalCase()}}State {
  const factory {{viewmodel_name.pascalCase()}}State({
    // TODO: Define your fields
    @Default(false) bool isLoading,
    // ...
  }) = _{{viewmodel_name.pascalCase()}}State;
}

class {{viewmodel_name.pascalCase()}} extends StateNotifier<{{viewmodel_name.pascalCase()}}State> {
  {{viewmodel_name.pascalCase()}}() : super(const {{viewmodel_name.pascalCase()}}State());

  // TODO: Inject use cases (ex: fetch data)

  Future<void> loadSomething() async {
    state = state.copyWith(isLoading: true);
    try {
      // final result = await _fetchSomethingUseCase();
      // update state
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final {{viewmodel_name.camelCase()}}Provider =
    StateNotifierProvider<{{viewmodel_name.pascalCase()}}, {{viewmodel_name.pascalCase()}}State>(
  (ref) => {{viewmodel_name.pascalCase()}}(),
);
```
````
