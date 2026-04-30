import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:go_router/go_router.dart';

import 'helpers/in_memory_local_storage.dart';

/// Configuration chargee depuis .env.test ou --dart-define
class RealE2EConfig {
  final String serverUrl;
  final String username;
  final String password;

  /// Liste des modules a tester (source de verite).
  /// Pour les tests mono-module existants, on utilise le getter [moduleCode]
  /// qui retourne le premier element. Les tests multi-modules iterent sur
  /// la liste complete.
  final List<String> moduleCodes;

  /// Active l'etape d'upload dans les tests qui le supportent.
  final bool withUpload;

  const RealE2EConfig({
    required this.serverUrl,
    required this.username,
    required this.password,
    required this.moduleCodes,
    this.withUpload = false,
  });

  /// Module courant pour les tests mono-module (= moduleCodes.first).
  String get moduleCode => moduleCodes.first;

  /// Charge la configuration depuis les --dart-define passes au build.
  /// Fallback : lit le fichier .env.test a la racine du projet.
  factory RealE2EConfig.load() {
    // Priorite 1 : --dart-define (passe via flutter test --dart-define=...)
    const envServerUrl = String.fromEnvironment('TEST_SERVER_URL');
    const envUsername = String.fromEnvironment('TEST_USERNAME');
    const envPassword = String.fromEnvironment('TEST_PASSWORD');
    const envModuleCodes = String.fromEnvironment('TEST_MODULE_CODES');
    const envModuleCode = String.fromEnvironment('TEST_MODULE_CODE');
    const envWithUpload = String.fromEnvironment('TEST_WITH_UPLOAD');

    if (envServerUrl.isNotEmpty) {
      return RealE2EConfig(
        serverUrl: envServerUrl,
        username: envUsername.isNotEmpty ? envUsername : 'admin',
        password: envPassword.isNotEmpty ? envPassword : 'admin',
        moduleCodes: _parseModuleCodes(envModuleCodes, envModuleCode),
        withUpload: envWithUpload == 'true' || envWithUpload == '1',
      );
    }

    // Priorite 2 : fichier .env.test (pour le lancement depuis le host)
    return _loadFromEnvFile();
  }

  static List<String> _parseModuleCodes(String csv, String single) {
    if (csv.isNotEmpty) {
      final parsed = csv
          .split(',')
          .map((m) => m.trim())
          .where((m) => m.isNotEmpty)
          .toList();
      if (parsed.isNotEmpty) return parsed;
    }
    if (single.isNotEmpty) return [single];
    return ['POPAmphibien'];
  }

  static RealE2EConfig _loadFromEnvFile() {
    final envMap = <String, String>{};

    // Essayer plusieurs emplacements possibles
    final possiblePaths = [
      '.env.test',
      '../.env.test', // depuis integration_test/
    ];

    for (final path in possiblePaths) {
      final file = File(path);
      if (file.existsSync()) {
        for (final line in file.readAsLinesSync()) {
          final trimmed = line.trim();
          if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
          final idx = trimmed.indexOf('=');
          if (idx > 0) {
            envMap[trimmed.substring(0, idx).trim()] =
                trimmed.substring(idx + 1).trim();
          }
        }
        break;
      }
    }

    final withUpload = envMap['TEST_WITH_UPLOAD'];
    return RealE2EConfig(
      serverUrl: envMap['TEST_SERVER_URL'] ?? 'http://10.0.2.2:8000',
      username: envMap['TEST_USERNAME'] ?? 'admin',
      password: envMap['TEST_PASSWORD'] ?? 'admin',
      moduleCodes: _parseModuleCodes(
        envMap['TEST_MODULE_CODES'] ?? '',
        envMap['TEST_MODULE_CODE'] ?? '',
      ),
      withUpload: withUpload == 'true' || withUpload == '1',
    );
  }
}

/// Test app pour les tests E2E contre un vrai serveur GeoNature.
///
/// Differences avec [E2ETestApp] (version mockee) :
/// - Dio reel (pas de MockApiInterceptor) → appels reseau reels
/// - DatabaseService reel → initialisation SQLite sur l'appareil
/// - Seul override : localStorage (pour controler l'etat entre tests)
class RealE2ETestApp {
  final RealE2EConfig config;
  final InMemoryLocalStorage localStorage;

  RealE2ETestApp._({
    required this.config,
    required this.localStorage,
  });

  factory RealE2ETestApp({RealE2EConfig? config}) {
    final effectiveConfig = config ?? RealE2EConfig.load();
    final localStorage = InMemoryLocalStorage();

    // Configurer l'URL de l'API pour que tous les providers Dio l'utilisent
    Config.setStoredApiUrl(effectiveConfig.serverUrl);

    return RealE2ETestApp._(
      config: effectiveConfig,
      localStorage: localStorage,
    );
  }

  /// Construit le ProviderScope avec un minimum d'overrides.
  /// Seul localStorage est override pour controler l'etat entre tests.
  /// Tout le reste utilise les vrais providers (API, DB, services).
  ProviderScope buildProviderScope({Widget? child}) {
    return ProviderScope(
      overrides: [
        // On override uniquement localStorage pour pouvoir reset entre tests
        // et eviter la dependance a SharedPreferences.init()
        localStorageProvider.overrideWithValue(localStorage),
      ],
      child: child ?? const _RealE2EMainApp(),
    );
  }

  /// Reset l'etat pour un nouveau test
  void reset() {
    localStorage.reset();
    Config.setStoredApiUrl(config.serverUrl);
  }
}

/// GoRouter frais pour chaque test (evite l'etat partage)
GoRouter _createRouter() => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const AuthChecker(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
      ],
    );

/// Widget principal pour les tests E2E reels.
/// Identique au MainApp de production mais sans ErrorBoundary/observers.
class _RealE2EMainApp extends StatelessWidget {
  const _RealE2EMainApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _createRouter(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
      ],
      locale: const Locale('fr', 'FR'),
      theme: ThemeData(
        primaryColor: AppColors.dark,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.dark,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
