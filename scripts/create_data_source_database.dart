import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run scripts/create_data_source_database.dart <Name>');
    print(
        'Example: dart run scripts/create_data_source_database.dart Authentication');
    exit(1);
  }

  final name = args[0].trim();
  final snakeCaseName = _toSnakeCase(name);

  final interfaceContent = '''
abstract class I${name}Database {
  // TODO: Define methods
  Future<void> getDataFromDb();
}
''';

  final implContent = '''
import 'package:gn_mobile_monitoring/data/datasource/interface/database/${snakeCaseName}_database.dart';
import 'package:drift/drift.dart'; // or any local DB logic

class ${name}DatabaseImpl implements I${name}Database {
  // final Database _db; // Example reference to your drift Database
  
  ${name}DatabaseImpl(/* this._db */);

  @override
  Future<void> getDataFromDb() async {
    // TODO: implement
  }
}
''';

  final interfacePath =
      'lib/data/datasource/interface/database/${snakeCaseName}_database.dart';
  final implPath =
      'lib/data/datasource/implementation/database/${snakeCaseName}_database_impl.dart';

  File(interfacePath).writeAsStringSync(interfaceContent);
  File(implPath).writeAsStringSync(implContent);

  print('Created: $interfacePath');
  print('Created: $implPath');
}

/// Convert PascalCase or camelCase to snake_case
String _toSnakeCase(String input) {
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
  return input.split(regex).join('_').toLowerCase();
}
