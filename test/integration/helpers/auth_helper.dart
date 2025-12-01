import 'package:gn_mobile_monitoring/data/datasource/implementation/api/authentication_api_impl.dart';
import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import '../config/test_server_config.dart';

/// Helper pour gérer l'authentification dans les tests d'intégration
class AuthHelper {
  static UserEntity? _currentUser;
  static String? _currentToken;

  /// Connecte un utilisateur au serveur de test et retourne le token
  static Future<String> login({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    // Configurer l'URL de base
    Config.setStoredApiUrl(serverUrl);

    // Créer l'API d'authentification
    final authApi = AuthenticationApiImpl();

    // Se connecter
    final userEntity = await authApi.login(username, password);

    // Sauvegarder l'utilisateur et le token
    _currentUser = userEntity;
    _currentToken = userEntity.token;

    print('✅ Connexion réussie: ${userEntity.nomRole} (ID: ${userEntity.idRole})');
    print('🔑 Token: ${_currentToken!.substring(0, 20)}...');

    return _currentToken!;
  }

  /// Se connecte avec les credentials de test depuis la config
  static Future<String> loginWithTestConfig(TestServerConfig config) async {
    return login(
      serverUrl: config.url,
      username: config.username,
      password: config.password,
    );
  }

  /// Récupère l'utilisateur actuellement connecté
  static UserEntity? get currentUser => _currentUser;

  /// Récupère le token actuel
  static String? get currentToken => _currentToken;

  /// Vérifie si un utilisateur est connecté
  static bool get isLoggedIn => _currentUser != null && _currentToken != null;

  /// Déconnexion (nettoyage)
  static Future<void> logout() async {
    _currentUser = null;
    _currentToken = null;
    Config.setStoredApiUrl(null);
    print('🚪 Déconnexion effectuée');
  }

  /// Reset complet (pour cleanup entre tests)
  static Future<void> reset() async {
    await logout();
  }
}
