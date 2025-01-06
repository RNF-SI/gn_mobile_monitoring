import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepositoryImpl implements LocalStorageRepository {
  static SharedPreferences? _preferences;
  static const String inProgressCorCyclePlacetteKey =
      'inProgressCorCyclePlacetteIdList';
  static const String _lastSyncPrefix = 'lastSyncTime_';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  @override
  Future<int> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    return int.parse(userId!);
  }

  @override
  Future<void> setUserId(int? userId) async {
    await _preferences?.setString('userId', userId.toString());
  }

  @override
  Future<void> setUserName(String userName) async {
    await _preferences?.setString('userName', userName);
  }

  @override
  Future<void> clearUserId() async {
    await _preferences?.remove('userId');
  }

  @override
  Future<void> clearUserName() async {
    await _preferences?.remove('userName');
  }

  @override
  Future<String?> getUserName() async {
    return _preferences?.getString('userName');
  }

  @override
  Future<void> setTerminalName(String terminalName) async {
    await _preferences?.setString('terminalName', terminalName);
  }

  @override
  Future<String?> getTerminalName() async {
    return _preferences?.getString('terminalName');
  }

  @override
  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    await _preferences?.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Future<bool> getIsLoggedIn() async {
    return _preferences?.getBool('isLoggedIn') ?? false;
  }

  @override
  Future<void> setToken(String token) async {
    await _preferences?.setString('token', token);
  }

  @override
  Future<String?> getToken() async {
    return _preferences?.getString('token');
  }
}
