import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_error_reporter.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/errors/error_handler.dart';
import 'package:gn_mobile_monitoring/data/repository/local_storage_repository_impl.dart';
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:gn_mobile_monitoring/presentation/view/error_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/error_boundary_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

final _router = GoRouter(
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

// Function to create MaterialColor
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

void main() async {
  // Améliore les stacktraces pour le débogage
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser le gestionnaire d'erreurs et le système de rapport
  final errorHandler = ErrorHandler();
  await errorHandler.initialize();
  await AppErrorReporter().initialize();
  
  try {
    // Initialize local storage
    await LocalStorageRepositoryImpl.init();
    
    // Initialize stored API URL if available
    final localStorageRepository = LocalStorageRepositoryImpl();
    final apiUrl = await localStorageRepository.getApiUrl();
    if (apiUrl != null && apiUrl.isNotEmpty) {
      Config.setStoredApiUrl(apiUrl);
      AppLogger().i('Using stored API URL: $apiUrl', tag: 'CONFIG');
    } else {
      AppLogger().i('No stored API URL found, login page will use default URL: ${Config.DEFAULT_API_URL}', tag: 'CONFIG');
    }
    
    // Lancer l'application avec le provider error listener
    runApp(
      ProviderScope(
        observers: [
          ProviderErrorObserver(),
        ],
        child: const ErrorSafeApp(),
      ),
    );
  } catch (e, stackTrace) {
    // Capturer et journaliser toute erreur d'initialisation
    AppLogger().e(
      'Erreur lors du démarrage de l\'application',
      tag: 'STARTUP',
      error: e, 
      stackTrace: stackTrace,
    );
    
    // Afficher un écran d'erreur de démarrage
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              const Text('Erreur de démarrage de l\'application',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$e', style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Redémarrer l'application
                  main();
                },
                child: const Text('Redémarrer l\'application'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

/// Observer qui journalise les erreurs de provider
class ProviderErrorObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger().e(
      'Erreur dans provider: ${provider.name ?? provider.runtimeType}',
      tag: 'PROVIDER',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Wrapper autour de MainApp qui gère les erreurs
class ErrorSafeApp extends StatelessWidget {
  const ErrorSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      tag: 'APP_ROOT',
      child: const MainApp(),
    );
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // S'assurer que les services essentiels sont initialisés
    ref.watch(databaseServiceProvider);
    ref.watch(nomenclatureServiceProvider);
    final MaterialColor customBlueSwatch = createMaterialColor(
      const Color(0xFF8AAC3E),
    );

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false, // Masquer la bannière de débogage
      theme: ThemeData(
        primaryColor:
            const Color(0xFF598979), // Used for elements needing emphasis
        scaffoldBackgroundColor:
            const Color(0xFFF4F1E4), // Background color for Scaffold widgets
        appBarTheme: const AppBarTheme(
          color: Color(0xFF598979), // Custom color for AppBar
          toolbarTextStyle: TextStyle(
              color: Colors.white, fontSize: 18), // Simplified text style
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF8B5500),
            backgroundColor: const Color(0xFF8AAC3E), // Button background color
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)), // Rounded buttons
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF7DAB9C), // Icon color
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Color(0xFF1a1a18)), // General text styling
          bodyMedium: TextStyle(color: Color(0xFF1a1a18)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor:
                const Color(0xFF8AAC3E), // Text color for elevated buttons
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: customBlueSwatch)
            .copyWith(secondary: const Color(0xFF8AAC3E)),
      ),
      // Gestionnaire global des erreurs de navigation
      builder: (context, child) {
        // Ajouter un observateur d'erreurs pour les widgets
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          AppLogger().e(
            'Widget build error: ${errorDetails.exception}',
            tag: 'WIDGET',
            error: errorDetails.exception,
            stackTrace: errorDetails.stack,
          );
          
          // En mode debug, utiliser l'erreur standard de Flutter
          if (kDebugMode) {
            return ErrorWidget(errorDetails.exception);
          }
          
          // En mode production, afficher notre écran d'erreur personnalisé
          return ErrorScreen(
            title: 'Erreur d\'affichage',
            message: 'Une erreur s\'est produite lors de l\'affichage de cette page.',
            error: errorDetails.exception,
            stackTrace: errorDetails.stack,
          );
        };
        
        return child ?? const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
