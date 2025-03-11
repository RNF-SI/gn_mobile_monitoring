import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationViewModel extends Mock
    implements AuthenticationViewModel {}

class MockBuildContext extends Mock implements BuildContext {}

class MockWidgetRef extends Mock implements WidgetRef {}

void main() {
  late MockAuthenticationViewModel mockAuthViewModel;
  late ProviderContainer container;

  setUp(() {
    mockAuthViewModel = MockAuthenticationViewModel();
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(MockWidgetRef());
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> pumpLoginPage(
      WidgetTester tester, LoginStatusInfo loginStatus) async {
    container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => loginStatus),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('LoginPage should render form fields correctly',
      (WidgetTester tester) async {
    await pumpLoginPage(tester, LoginStatusInfo.initial);

    // Assert
    expect(find.byType(RichText), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de Passe'), findsOneWidget);
    expect(find.byType(MaterialButton), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('LoginPage should validate identifiant field',
      (WidgetTester tester) async {
    await pumpLoginPage(tester, LoginStatusInfo.initial);

    // Tap login button without filling fields
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert
    expect(find.text("L'identifiant est nécessaire"), findsOneWidget);
  });

  testWidgets('LoginPage should validate password field',
      (WidgetTester tester) async {
    await pumpLoginPage(tester, LoginStatusInfo.initial);

    // Fill identifiant field but not password
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert
    expect(find.text('Le mot de passe est nécessaire'), findsOneWidget);
  });

  testWidgets(
      'LoginPage should call signInWithEmailAndPassword when form is valid',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
        any(), any(), any(), any())).thenAnswer((_) async {});

    await pumpLoginPage(tester, LoginStatusInfo.initial);

    // Fill form fields
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // Submit form
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert
    verify(() => mockAuthViewModel.signInWithEmailAndPassword(
        'test@example.com', 'password123', any(), any())).called(1);
  });

  testWidgets(
      'LoginPage should display loading indicator during authentication',
      (WidgetTester tester) async {
    // Arrange
    when(() =>
        mockAuthViewModel.signInWithEmailAndPassword(
            any(), any(), any(), any())).thenAnswer(
        (_) async => await Future.delayed(const Duration(milliseconds: 100)));

    await pumpLoginPage(tester, LoginStatusInfo.authenticating);

    // Fill form fields
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    // Submit form
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert - Loading indicator should be visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Clean up any pending timers
    await tester.pumpAndSettle();
  });

  testWidgets('LoginPage should display login status message',
      (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
        any(), any(), any(), any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return;
    });

    await pumpLoginPage(tester, LoginStatusInfo.fetchingModules);

    // Fill form fields and submit to trigger loading
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert - should show status message
    expect(find.text(LoginStatusInfo.fetchingModules.message), findsOneWidget);
  });

  testWidgets('LoginPage should display error message',
      (WidgetTester tester) async {
    // Arrange
    const errorMessage = "Impossible de se connecter au serveur";
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
        any(), any(), any(), any())).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      return;
    });

    await pumpLoginPage(tester, LoginStatusInfo.error(errorMessage));

    // Fill form fields and submit to trigger loading
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert - Error message should be visible
    expect(find.text(errorMessage), findsOneWidget);
  });
}
