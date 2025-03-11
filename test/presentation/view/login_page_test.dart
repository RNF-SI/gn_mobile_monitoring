import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart' as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/view/login_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';

class MockAuthenticationViewModel extends Mock implements AuthenticationViewModel {}
class MockBuildContext extends Mock implements BuildContext {}
class MockWidgetRef extends Mock implements WidgetRef {}

void main() {
  late MockAuthenticationViewModel mockAuthViewModel;

  setUp(() {
    mockAuthViewModel = MockAuthenticationViewModel();
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(MockWidgetRef());
  });

  testWidgets('LoginPage should render form fields correctly', (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.initial),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Assert
    expect(find.text('Monitoring'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Identifiant'), findsOneWidget);
    expect(find.text('Mot de Passe'), findsOneWidget);
    expect(find.byType(MaterialButton), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });

  testWidgets('LoginPage should validate identifiant field', (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.initial),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Tap login button without filling fields
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert
    expect(find.text("L'identifiant est nécessaire"), findsOneWidget);
  });

  testWidgets('LoginPage should validate password field', (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.initial),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Fill identifiant field but not password
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert
    expect(find.text('Le mot de passe est nécessaire'), findsOneWidget);
  });

  testWidgets('LoginPage should call signInWithEmailAndPassword when form is valid', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
      any(), any(), any(), any()
    )).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.initial),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Fill form fields
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    
    // Submit form
    await tester.tap(find.byType(MaterialButton));
    await tester.pump();

    // Assert
    verify(() => mockAuthViewModel.signInWithEmailAndPassword(
      'test@example.com', 'password123', any(), any()
    )).called(1);
  });

  testWidgets('LoginPage should display loading indicator during authentication', (WidgetTester tester) async {
    // Arrange
    // Make the sign in function wait to simulate network delay
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
      any(), any(), any(), any()
    )).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
    });

    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.authenticating),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Fill form fields
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    
    // Submit form
    await tester.tap(find.byType(MaterialButton));
    await tester.pump(); // Start loading
    
    // Assert - Loading indicator should be visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('LoginPage should display login status message', (WidgetTester tester) async {
    // Arrange
    when(() => mockAuthViewModel.signInWithEmailAndPassword(
      any(), any(), any(), any()
    )).thenAnswer((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
    });

    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.fetchingModules),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Fill form fields and submit
    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.byType(MaterialButton));
    await tester.pump(); // Start loading
    
    // Assert - should show status message
    expect(find.text('Chargement des modules...'), findsOneWidget);
  });

  testWidgets('LoginPage should display error message', (WidgetTester tester) async {
    // Arrange
    const errorMessage = "Impossible de se connecter au serveur";
    
    final container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(mockAuthViewModel),
        loginStatusProvider.overrideWith((ref) => 
          LoginStatusInfo.error(errorMessage)
        ),
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    );
    
    // Assert - Error message should be visible
    expect(find.text("Erreur d'authentification"), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}