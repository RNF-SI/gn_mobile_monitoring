import 'dart:io';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Usage: dart run scripts/create_usecase.dart <UseCaseName>');
    print(
        'Example: dart run scripts/create_usecase.dart ClearTokenFromLocalStorage');
    exit(1);
  }

  final useCaseName = arguments[0].trim();
  final snakeCaseName = _toSnakeCase(useCaseName);

  // 1) Build the interface content.
  final interfaceContent = '''
abstract class ${useCaseName}Usecase {
  Future<void> execute();
}
''';

  // 2) Build the implementation content.
  final implContent = '''
import 'package:gn_mobile_monitoring/domain/usecase/${snakeCaseName}_usecase.dart';

// TODO: Update the import(s) below if you need to reference a repository or other dependencies.
// import 'package:gn_mobile_monitoring/domain/repository/some_repository.dart';

class ${useCaseName}UseCaseImpl implements ${useCaseName}Usecase {
  // TODO: Uncomment or change this if you have a repository dependency.
  // final SomeRepository _someRepository;
  
  ${useCaseName}UseCaseImpl(
      // this._someRepository,
      );

  @override
  Future<void> execute() async {
    // TODO: Implement your use case logic.
    // e.g., _someRepository.clearToken();
  }
}
''';

  // 3) Determine file paths.
  final interfaceFilePath = 'lib/domain/usecase/${snakeCaseName}_usecase.dart';
  final implFilePath = 'lib/domain/usecase/${snakeCaseName}_usecase_impl.dart';

  // 4) Create the files (or overwrite if they already exist).
  File(interfaceFilePath).writeAsStringSync(interfaceContent);
  File(implFilePath).writeAsStringSync(implContent);

  print('Created: $interfaceFilePath');
  print('Created: $implFilePath');
}

/// Converts PascalCase or camelCase to snake_case.
/// Example: "ClearTokenFromLocalStorage" -> "clear_token_from_local_storage"
String _toSnakeCase(String input) {
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
  return input.split(regex).join('_').toLowerCase();
}
