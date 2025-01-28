# create_model.prompt

You are an expert in Flutter, Dart, and Clean Architecture.

Create a new domain model in the `domain/model/` directory. The model must:

- Use the `freezed` package for immutability.
- Annotate with `@freezed`.
- Include JSON serialization if needed (`with JsonSerializable`).
- Generate a `fromJson` factory constructor if required.

**Template**:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '{{model_name.snakeCase()}}.freezed.dart';
part '{{model_name.snakeCase()}}.g.dart';

@freezed
class {{model_name.pascalCase()}} with _${{model_name.pascalCase()}} {
  const factory {{model_name.pascalCase()}}({
    // TODO: Add fields
    required int id,
    required String name,
    // ...
  }) = _{{model_name.pascalCase()}};

  factory {{model_name.pascalCase()}}.fromJson(Map<String, dynamic> json) =>
      _${{model_name.pascalCase()}}FromJson(json);
}
```
