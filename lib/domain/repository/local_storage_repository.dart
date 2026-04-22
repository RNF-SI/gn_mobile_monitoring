abstract class LocalStorageRepository {
  Future<int> getUserId();
  Future<void> setUserId(int userId);
  Future<void> clearUserId();
  Future<void> clearUserName();
  Future<void> clearToken();
  Future<void> setUserName(String userName);
  Future<String?> getUserName();
  Future<void> setTerminalName(String terminalName);
  Future<String?> getTerminalName();
  Future<void> setIsLoggedIn(bool isLoggedIn);
  Future<bool> getIsLoggedIn();
  Future<void> setToken(String token);
  Future<String?> getToken();
  
  // API URL management
  Future<void> setApiUrl(String apiUrl);
  Future<String?> getApiUrl();
  Future<void> clearApiUrl();

  // Dernière version d'APK proposée et refusée par l'utilisateur (#170)
  Future<void> setLastDismissedAppVersionCode(String versionCode);
  Future<String?> getLastDismissedAppVersionCode();
}
