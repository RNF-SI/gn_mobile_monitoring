import 'fixture_data.dart';

/// Loads JSON fixtures for E2E tests.
///
/// Uses inline data from [FixtureData] instead of reading files from disk,
/// because `dart:io File` does not work on Android devices/emulators.
class FixtureLoader {
  /// Load a fixture by path and return its parsed content.
  ///
  /// [path] is relative to the fixtures directory, e.g. 'auth/login_success.json'
  static Future<dynamic> load(String path) async {
    final data = FixtureData.fixtures[path];
    if (data == null) {
      throw Exception('Fixture not found: $path');
    }
    // Return a deep copy to avoid mutations between tests
    return _deepCopy(data);
  }

  /// Load a fixture — alias for [load] (raw string no longer needed with inline data).
  static Future<dynamic> loadRaw(String path) async {
    return load(path);
  }

  /// Deep copy a dynamic structure (Map/List) to avoid cross-test mutations.
  /// Also ensures all maps are typed as Map<String, dynamic> (Dart const maps
  /// become Map<dynamic, dynamic> at runtime, which breaks json_serializable).
  static dynamic _deepCopy(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.fromEntries(
        value.entries
            .map((e) => MapEntry(e.key.toString(), _deepCopy(e.value))),
      );
    } else if (value is List) {
      return value.map((e) => _deepCopy(e)).toList();
    }
    return value;
  }
}
