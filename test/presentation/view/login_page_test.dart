import 'dart:async';
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

    // Assert - find form fields and button
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.byType(MaterialButton), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    
    // Check for labels in the TextFormFields using simpler assertions
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de Passe'), findsOneWidget);
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
    final completer = Completer<void>();
    
    when(() =>
        mockAuthViewModel.signInWithEmailAndPassword(
            any(), any(), any(), any())).thenAnswer((_) => completer.future);

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

    // Complete the future to avoid pending timers
    completer.complete();
    await tester.pump();
  });

  testWidgets('LoginPage should display login status message',
      (WidgetTester tester) async {
    // Arrange - Create a completer to control the async flow
    final completer = Completer<void>();
    
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
        any(), any(), any(), any())).thenAnswer((_) => completer.future);

    await pumpLoginPage(tester, LoginStatusInfo.fetchingModules);

    // Fill form fields and submit to trigger loading
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(MaterialButton));
    
    // Wait for loading state to appear
    await tester.pump(); // Process initial tap
    
    // Loading indicator should be shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Now status message should be visible
    expect(find.text(LoginStatusInfo.fetchingModules.message), findsOneWidget);
    
    // Complete the future to avoid pending timers
    completer.complete();
    await tester.pump();
  });

  testWidgets('LoginPage should display error message',
      (WidgetTester tester) async {
    // Arrange
    const errorMessage = "Impossible de se connecter au serveur";
    final completer = Completer<void>();
    
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
        any(), any(), any(), any())).thenAnswer((_) => completer.future);

    await pumpLoginPage(tester, LoginStatusInfo.error(errorMessage));

    // Fill form fields and submit to trigger loading
    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(MaterialButton));
    
    // Wait for loading state to appear
    await tester.pump(); // Process initial tap
    
    // Loading indicator should be shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    
    // Error message should be visible
    expect(find.text(errorMessage), findsOneWidget);
    
    // Complete the future to avoid pending timers
    completer.complete();
    await tester.pump();
  });
}
