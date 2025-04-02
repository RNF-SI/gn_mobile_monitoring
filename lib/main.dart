import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/data/repository/local_storage_repository_impl.dart';
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
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
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageRepositoryImpl.init();
  runApp(
    const ProviderScope(
      child: MainApp(),
    ),
  );
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
    );
  }
}
