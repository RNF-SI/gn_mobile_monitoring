import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';

/// In-memory implementation of [LocalStorageRepository] for E2E tests.
/// Avoids SharedPreferences platform channel dependency.
class InMemoryLocalStorage implements LocalStorageRepository {
  final Map<String, dynamic> _store = {};

  @override
  Future<int> getUserId() async => _store['userId'] as int? ?? 0;

  @override
  Future<void> setUserId(int userId) async => _store['userId'] = userId;

  @override
  Future<void> clearUserId() async => _store.remove('userId');

  @override
  Future<void> setUserName(String userName) async =>
      _store['userName'] = userName;

  @override
  Future<String?> getUserName() async => _store['userName'] as String?;

  @override
  Future<void> clearUserName() async => _store.remove('userName');

  @override
  Future<void> setTerminalName(String terminalName) async =>
      _store['terminalName'] = terminalName;

  @override
  Future<String?> getTerminalName() async =>
      _store['terminalName'] as String?;

  @override
  Future<void> setIsLoggedIn(bool isLoggedIn) async =>
      _store['isLoggedIn'] = isLoggedIn;

  @override
  Future<bool> getIsLoggedIn() async =>
      _store['isLoggedIn'] as bool? ?? false;

  @override
  Future<void> setToken(String token) async => _store['token'] = token;

  @override
  Future<String?> getToken() async => _store['token'] as String?;

  @override
  Future<void> clearToken() async => _store.remove('token');

  @override
  Future<void> setApiUrl(String apiUrl) async => _store['apiUrl'] = apiUrl;

  @override
  Future<String?> getApiUrl() async => _store['apiUrl'] as String?;

  @override
  Future<void> clearApiUrl() async => _store.remove('apiUrl');

  /// Reset all stored values
  void reset() => _store.clear();
}
