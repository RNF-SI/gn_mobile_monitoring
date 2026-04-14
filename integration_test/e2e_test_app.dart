import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/authentication_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/global_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/modules_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observation_details_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/observations_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/taxon_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/api/visits_api_impl.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:go_router/go_router.dart';

import 'helpers/fake_get_user_location.dart';
import 'helpers/in_memory_local_storage.dart';
import 'mocks/mock_api_interceptor.dart';
import 'mocks/mock_databases.dart';

/// Creates a Dio instance with the mock interceptor attached.
Dio createMockDio(MockApiInterceptor interceptor) {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://mock.geonature.test/api',
  ));
  dio.interceptors.add(interceptor);
  return dio;
}

/// Creates a fully configured [ProviderScope] for E2E testing.
///
/// Overrides ALL providers:
/// - Local storage → in-memory
/// - All API providers → mock Dio
/// - All database providers → in-memory mocks
/// - DatabaseService → no-op
/// - SyncService → idle state
class E2ETestApp {
  final MockApiInterceptor interceptor;
  final InMemoryLocalStorage localStorage;
  final Dio _mockDio;

  /// Exposé pour les tests qui veulent déclencher manuellement une requête
  /// (p. ex. valider l'enregistrement par l'interceptor). Les vrais appels
  /// de l'app passent par les providers Dio injectés dans [buildProviderScope].
  Dio get dio => _mockDio;

  /// Stub de localisation utilisé par tous les tests : retourne une
  /// position connue pour que les boutons dépendants du GPS (header
  /// de création / édition de site) soient actifs. Les tests peuvent
  /// le remplacer avant `buildProviderScope` en réassignant ce champ.
  FakeGetUserLocation userLocation = const FakeGetUserLocation();

  // Expose mock databases for seeding test data
  final MockModuleDatabaseImpl moduleDatabase;
  final MockSitesDatabase sitesDatabase;
  final MockVisitesDatabase visitesDatabase;
  final MockObservationsDatabase observationsDatabase;
  final MockObservationDetailsDatabase observationDetailsDatabase;
  final MockNomenclaturesDatabase nomenclaturesDatabase;
  final MockDatasetsDatabase datasetsDatabase;
  final MockTaxonDatabase taxonDatabase;
  final MockGlobalDatabase globalDatabase;

  E2ETestApp._({
    required this.interceptor,
    required this.localStorage,
    required Dio mockDio,
    required this.moduleDatabase,
    required this.sitesDatabase,
    required this.visitesDatabase,
    required this.observationsDatabase,
    required this.observationDetailsDatabase,
    required this.nomenclaturesDatabase,
    required this.datasetsDatabase,
    required this.taxonDatabase,
    required this.globalDatabase,
  }) : _mockDio = mockDio;

  factory E2ETestApp({MockApiInterceptor? interceptor}) {
    final mockInterceptor = interceptor ?? MockApiInterceptor();
    final localStorage = InMemoryLocalStorage();
    final mockDio = createMockDio(mockInterceptor);

    return E2ETestApp._(
      interceptor: mockInterceptor,
      localStorage: localStorage,
      mockDio: mockDio,
      moduleDatabase: MockModuleDatabaseImpl(),
      sitesDatabase: MockSitesDatabase(),
      visitesDatabase: MockVisitesDatabase(),
      observationsDatabase: MockObservationsDatabase(),
      observationDetailsDatabase: MockObservationDetailsDatabase(),
      nomenclaturesDatabase: MockNomenclaturesDatabase(),
      datasetsDatabase: MockDatasetsDatabase(),
      taxonDatabase: MockTaxonDatabase(),
      globalDatabase: MockGlobalDatabase(),
    );
  }

  /// Build the ProviderScope with all overrides
  ProviderScope buildProviderScope({Widget? child}) {
    return ProviderScope(
      overrides: overrides,
      child: child ?? const E2EMainApp(),
    );
  }

  /// Get the list of provider overrides (for custom widget trees)
  List<Override> get overrides => [
        // --- Local storage ---
        localStorageProvider.overrideWithValue(localStorage),

        // --- All API providers with mock Dio ---
        authenticationApiProvider
            .overrideWithValue(AuthenticationApiImpl(dio: _mockDio)),
        modulesApiProvider.overrideWithValue(ModulesApiImpl(dio: _mockDio)),
        globalApiProvider.overrideWithValue(GlobalApiImpl(dio: _mockDio)),
        sitesApiProvider.overrideWithValue(SitesApiImpl(dio: _mockDio)),
        visitsApiProvider.overrideWithValue(VisitsApiImpl(dio: _mockDio)),
        observationsApiProvider
            .overrideWithValue(ObservationsApiImpl(dio: _mockDio)),
        observationDetailsApiProvider
            .overrideWithValue(ObservationDetailsApiImpl(dio: _mockDio)),
        taxonApiProvider.overrideWithValue(TaxonApiImpl(dio: _mockDio)),

        // --- All database providers with in-memory mocks ---
        globalDatabaseProvider.overrideWithValue(globalDatabase),
        moduleDatabaseProvider.overrideWithValue(moduleDatabase),
        siteDatabaseProvider.overrideWithValue(sitesDatabase),
        visitDatabaseProvider.overrideWithValue(visitesDatabase),
        observationsDatabaseProvider.overrideWithValue(observationsDatabase),
        observationDetailsDatabaseProvider
            .overrideWithValue(observationDetailsDatabase),
        nomenclatureDatabaseProvider.overrideWithValue(nomenclaturesDatabase),
        datasetsDatabaseProvider.overrideWithValue(datasetsDatabase),
        taxonDatabaseProvider.overrideWithValue(taxonDatabase),

        // --- DatabaseService: skip real DB init ---
        databaseServiceProvider.overrideWith((ref) {
          return _NoOpDatabaseService(ref);
        }),

        // --- Localisation : stub pour éviter l'appel Geolocator réel ---
        getUserLocationUseCaseProvider.overrideWithValue(userLocation),
      ];
}

/// A DatabaseService that doesn't initialize the real SQLite database.
class _NoOpDatabaseService
    extends StateNotifier<custom_async_state.State<void>>
    implements DatabaseService {
  _NoOpDatabaseService(this.ref)
      : super(const custom_async_state.State.success(null));

  @override
  final Ref ref;

  @override
  Future<void> deleteAndReinitializeDatabase() async {}
}

/// Create a fresh GoRouter for each test (avoid shared state between tests).
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

/// The main app widget for E2E tests.
/// Mirrors the production [MainApp] but with test-specific configuration.
class E2EMainApp extends StatelessWidget {
  const E2EMainApp({super.key});

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
