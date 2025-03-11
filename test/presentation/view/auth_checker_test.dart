import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/view/auth_checker.dart';
import 'package:gn_mobile_monitoring/presentation/view/error_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/loading_screen.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockGetIsLoggedInUseCase
    with Mock
    implements GetIsLoggedInFromLocalStorageUseCase {}

void main() {
  late MockGetIsLoggedInUseCase mockGetIsLoggedInUseCase;

  setUp(() {
    mockGetIsLoggedInUseCase = MockGetIsLoggedInUseCase();
  });

  testWidgets(
      'AuthChecker should display LoadingScreen while checking login status',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute()).thenAnswer((_) async =>
        Future.delayed(const Duration(milliseconds: 100), () => true));

    final container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    expect(find.byType(LoadingScreen), findsOneWidget);
  });

  testWidgets('AuthChecker should navigate to HomePage when user is logged in',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute())
        .thenAnswer((_) async => true);

    final container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets(
      'AuthChecker should navigate to LoginPage when user is not logged in',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute())
        .thenAnswer((_) async => false);

    final container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('AuthChecker should display ErrorScreen when an error occurs',
      (WidgetTester tester) async {
    when(() => mockGetIsLoggedInUseCase.execute())
        .thenThrow("Erreur de vérification");

    final container = ProviderContainer(
      overrides: [
        getIsLoggedInFromLocalStorageUseCaseProvider
            .overrideWithValue(mockGetIsLoggedInUseCase),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AuthChecker(),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.text("Erreur de vérification"), findsOneWidget);
  });
}
