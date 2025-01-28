import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run scripts/create_repository.dart <Name>');
    print('Example: dart run scripts/create_repository.dart Sites');
    exit(1);
  }

  final name = args[0].trim();
  final snakeCaseName = _toSnakeCase(name);

  // "SitesRepository" => "sites_repository.dart"
  final interfaceName = '${name}Repository';
  final interfaceContent = '''
abstract class I$interfaceName {
  // TODO: Define methods
  Future<void> fetchData();
}
''';

  final implName = '${name}RepositoryImpl';
  final implContent = '''
import 'package:gn_mobile_monitoring/domain/repository/${snakeCaseName}_repository.dart';

class $implName implements I$interfaceName {
  // TODO: Add data source references or other dependencies
  $implName();

  @override
  Future<void> fetchData() async {
    // TODO: implement
  }
}
''';

  final interfacePath =
      'lib/domain/repository/${snakeCaseName}_repository.dart';
  final implPath = 'lib/data/repository/${snakeCaseName}_repository_impl.dart';

  File(interfacePath).writeAsStringSync(interfaceContent);
  File(implPath).writeAsStringSync(implContent);

  print('Created: $interfacePath');
  print('Created: $implPath');
}

String _toSnakeCase(String input) {
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
  return input.split(regex).join('_').toLowerCase();
}
