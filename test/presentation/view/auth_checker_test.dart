import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_complete_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:gn_mobile_monitoring/presentation/view/error_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/loading_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:mocktail/mocktail.dart';

class MockGetIsLoggedInUseCase
    with Mock
    implements GetIsLoggedInFromLocalStorageUseCase {}

// Stub SyncService that doesn't create timers
class StubSyncService extends SyncService {
  StubSyncService() : super(
    _MockGetTokenUseCase(),
    _MockIncrementalSyncAllUseCase(),
    _MockGetLastSyncDateUseCase(),
    _MockUpdateLastSyncDateUseCase(),
    _MockSyncRepository(),
    _MockSyncCompleteUseCase(),
  );

  @override
  void initialize(WidgetRef ref) {
    // Ne fait rien - évite de créer le timer périodique
  }
}

// Mocks minimaux pour SyncService
class _MockGetTokenUseCase with Mock implements GetTokenFromLocalStorageUseCase {}
class _MockIncrementalSyncAllUseCase with Mock implements IncrementalSyncAllUseCase {}
class _MockGetLastSyncDateUseCase with Mock implements GetLastSyncDateUseCase {}
class _MockUpdateLastSyncDateUseCase with Mock implements UpdateLastSyncDateUseCase {}
class _MockSyncRepository with Mock implements SyncRepository {}
class _MockSyncCompleteUseCase with Mock implements SyncCompleteUseCase {}

void main() {
  late MockGetIsLoggedInUseCase mockGetIsLoggedInUseCase;
  late ProviderContainer? container;

  setUp(() {
    mockGetIsLoggedInUseCase = MockGetIsLoggedInUseCase();
    container = null;
  });

  tearDown(() {
    // Dispose du container pour nettoyer les timers et resources
    container?.dispose();
  });

  testWidgets(
      'AuthChecker should display LoadingScreen while checking login status',
      (WidgetTester tester) async {
    // Use a Completer that we can manually complete for reliable testing
    final completer = Completer<bool>();
    when(() => mockGetIsLoggedInUseCase.execute()).thenAnswer((_) => completer.future);

    final stubSyncService = StubSyncService();

    container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
        syncServiceProvider.overrideWith((ref) => stubSyncService),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container!,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    // Verify loading is shown initially
    expect(find.byType(LoadingScreen), findsOneWidget);

    // Complete the future
    completer.complete(true);

    // Process the completion with multiple pumps to avoid timer issues
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify we've navigated to the correct screen
    expect(find.byType(HomePage), findsOneWidget);

    // Advance time to let the SyncService timer complete (2 seconds)
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('AuthChecker should navigate to HomePage when user is logged in',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute())
        .thenAnswer((_) async => true);

    final stubSyncService = StubSyncService();

    container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
        syncServiceProvider.overrideWith((ref) => stubSyncService),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container!,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(HomePage), findsOneWidget);

    // Advance time to let the SyncService timer complete (2 seconds)
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets(
      'AuthChecker should navigate to LoginPage when user is not logged in',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute())
        .thenAnswer((_) async => false);

    container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container!,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('AuthChecker should display ErrorScreen when an error occurs',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute())
        .thenThrow("Erreur de vérification");

    container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container!,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.text("Erreur de vérification"), findsOneWidget);
  });
}
