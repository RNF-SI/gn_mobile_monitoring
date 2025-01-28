import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run scripts/create_data_source_api.dart <Name>');
    print(
        'Example: dart run scripts/create_data_source_api.dart Authentication');
    exit(1);
  }

  final name = args[0].trim();
  final snakeCaseName = _toSnakeCase(name);

  // Interface content (e.g. authentication_api.dart)
  final interfaceContent = '''
abstract class I${name}Api {
  // TODO: Define methods
  Future<void> fetchData();
}
''';

  // Implementation content (e.g. authentication_api_impl.dart)
  final implContent = '''
import 'package:gn_mobile_monitoring/data/datasource/interface/api/${snakeCaseName}_api.dart';
import 'package:dio/dio.dart';

class ${name}ApiImpl implements I${name}Api {
  final Dio _dio;

  ${name}ApiImpl(this._dio);

  @override
  Future<void> fetchData() async {
    // TODO: implement
  }
}
''';

  // Write files
  final interfacePath =
      'lib/data/datasource/interface/api/${snakeCaseName}_api.dart';
  final implPath =
      'lib/data/datasource/implementation/api/${snakeCaseName}_api_impl.dart';

  File(interfacePath).writeAsStringSync(interfaceContent);
  File(implPath).writeAsStringSync(implContent);

  print('Created: $interfacePath');
  print('Created: $implPath');
}

/// Converts PascalCase or camelCase to snake_case
String _toSnakeCase(String input) {
  final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
  return input.split(regex).join('_').toLowerCase();
}
