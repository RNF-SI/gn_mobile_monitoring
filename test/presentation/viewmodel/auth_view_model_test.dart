import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/api_exception.dart';
import 'package:gn_mobile_monitoring/core/errors/exceptions/network_exception.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockSetIsLoggedInFromLocalStorageUseCase extends Mock
    implements SetIsLoggedInFromLocalStorageUseCase {}

class MockSetUserIdFromLocalStorageUseCase extends Mock
    implements SetUserIdFromLocalStorageUseCase {}

class MockSetUserNameFromLocalStorageUseCase extends Mock
    implements SetUserNameFromLocalStorageUseCase {}

class MockSetTokenFromLocalStorageUseCase extends Mock
    implements SetTokenFromLocalStorageUseCase {}

class MockClearUserIdFromLocalStorageUseCase extends Mock
    implements ClearUserIdFromLocalStorageUseCase {}

class MockClearUserNameFromLocalStorageUseCase extends Mock
    implements ClearUserNameFromLocalStorageUseCase {}

class MockClearTokenFromLocalStorageUseCase extends Mock
    implements ClearTokenFromLocalStorageUseCase {}

class MockFetchModulesUseCase extends Mock implements FetchModulesUseCase {}

class MockFetchSitesUseCase extends Mock implements FetchSitesUseCase {}

class MockFetchSiteGroupsUseCase extends Mock
    implements FetchSiteGroupsUseCase {}

class MockGetModulesUseCase extends Mock implements GetModulesUseCase {}

class MockIncrementalSyncModulesUseCase extends Mock
    implements IncrementalSyncModulesUseCase {}

class MockIncrementalSyncSitesUseCase extends Mock
    implements IncrementalSyncSitesUseCase {}

class MockIncrementalSyncSiteGroupsUseCase extends Mock
    implements IncrementalSyncSiteGroupsUseCase {}

class MockNavigationContext extends Mock implements BuildContext {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockContext';
}

class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockNavigatorState';
}

class MockGoRouter extends Mock implements GoRouter {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockGoRouter';
}

class MockRef extends Mock implements Ref<Object?> {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockRef';
}

class MockWidgetRef extends Mock implements WidgetRef {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockWidgetRef';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthenticationViewModel viewModel;
  late MockLoginUseCase mockLoginUseCase;
  late MockSetIsLoggedInFromLocalStorageUseCase mockSetIsLoggedInUseCase;
  late MockSetUserIdFromLocalStorageUseCase mockSetUserIdUseCase;
  late MockSetUserNameFromLocalStorageUseCase mockSetUserNameUseCase;
  late MockSetTokenFromLocalStorageUseCase mockSetTokenUseCase;
  late MockClearUserIdFromLocalStorageUseCase mockClearUserIdUseCase;
  late MockClearUserNameFromLocalStorageUseCase mockClearUserNameUseCase;
  late MockClearTokenFromLocalStorageUseCase mockClearTokenUseCase;
  late MockFetchModulesUseCase mockFetchModulesUseCase;
  late MockFetchSitesUseCase mockFetchSitesUseCase;
  late MockFetchSiteGroupsUseCase mockFetchSiteGroupsUseCase;
  late MockGetModulesUseCase mockGetModulesUseCase;
  late MockRef mockRef;
  late MockWidgetRef mockWidgetRef;
  late ProviderContainer container;
  late MockIncrementalSyncModulesUseCase mockIncrementalSyncModulesUseCase;
  late MockIncrementalSyncSitesUseCase mockIncrementalSyncSitesUseCase;
  late MockIncrementalSyncSiteGroupsUseCase
      mockIncrementalSyncSiteGroupsUseCase;

  // Test user
  final testUser = User(
    id: 1,
    name: "Test User",
    email: "test@example.com",
    token: "test_token_123",
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSetIsLoggedInUseCase = MockSetIsLoggedInFromLocalStorageUseCase();
    mockSetUserIdUseCase = MockSetUserIdFromLocalStorageUseCase();
    mockSetUserNameUseCase = MockSetUserNameFromLocalStorageUseCase();
    mockSetTokenUseCase = MockSetTokenFromLocalStorageUseCase();
    mockClearUserIdUseCase = MockClearUserIdFromLocalStorageUseCase();
    mockClearUserNameUseCase = MockClearUserNameFromLocalStorageUseCase();
    mockClearTokenUseCase = MockClearTokenFromLocalStorageUseCase();
    mockFetchModulesUseCase = MockFetchModulesUseCase();
    mockFetchSitesUseCase = MockFetchSitesUseCase();
    mockFetchSiteGroupsUseCase = MockFetchSiteGroupsUseCase();
    mockGetModulesUseCase = MockGetModulesUseCase();
    mockIncrementalSyncModulesUseCase = MockIncrementalSyncModulesUseCase();
    mockIncrementalSyncSitesUseCase = MockIncrementalSyncSitesUseCase();
    mockIncrementalSyncSiteGroupsUseCase =
        MockIncrementalSyncSiteGroupsUseCase();
    mockRef = MockRef();
    mockWidgetRef = MockWidgetRef();

    // Configure Ref mock pour retourner les use cases lorsqu'ils sont appelés via ref.read
    when(() => mockRef.read(incrementalSyncModulesUseCaseProvider))
        .thenReturn(mockIncrementalSyncModulesUseCase);
    when(() => mockRef.read(incrementalSyncSitesUseCaseProvider))
        .thenReturn(mockIncrementalSyncSitesUseCase);
    when(() => mockRef.read(incrementalSyncSiteGroupsUseCaseProvider))
        .thenReturn(mockIncrementalSyncSiteGroupsUseCase);
    when(() => mockRef.read(getModulesUseCaseProvider))
        .thenReturn(mockGetModulesUseCase);

    // Création du ViewModel
    viewModel = AuthenticationViewModel(
      mockLoginUseCase,
      mockSetIsLoggedInUseCase,
      mockSetUserIdUseCase,
      mockSetUserNameUseCase,
      mockSetTokenUseCase,
      mockClearUserIdUseCase,
      mockClearUserNameUseCase,
      mockClearTokenUseCase,
      mockFetchModulesUseCase,
      mockFetchSitesUseCase,
      mockFetchSiteGroupsUseCase,
      mockRef,
    );

    // Configure les mocks pour les tests
    when(() => mockSetIsLoggedInUseCase.execute(any()))
        .thenAnswer((_) async {});
    when(() => mockSetUserIdUseCase.execute(any())).thenAnswer((_) async {});
    when(() => mockSetUserNameUseCase.execute(any())).thenAnswer((_) async {});
    when(() => mockSetTokenUseCase.execute(any())).thenAnswer((_) async {});
    when(() => mockClearUserIdUseCase.execute()).thenAnswer((_) async {});
    when(() => mockClearUserNameUseCase.execute()).thenAnswer((_) async {});
    when(() => mockClearTokenUseCase.execute()).thenAnswer((_) async {});
    when(() => mockFetchModulesUseCase.execute(any())).thenAnswer((_) async {});
    when(() => mockFetchSitesUseCase.execute(any())).thenAnswer((_) async {});
    when(() => mockFetchSiteGroupsUseCase.execute(any()))
        .thenAnswer((_) async {});
    when(() => mockIncrementalSyncModulesUseCase.execute(any()))
        .thenAnswer((_) async {});
    when(() => mockIncrementalSyncSitesUseCase.execute(any()))
        .thenAnswer((_) async {});
    when(() => mockIncrementalSyncSiteGroupsUseCase.execute(any()))
        .thenAnswer((_) async {});

    // Container pour les tests
    container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(viewModel),
      ],
    );

    registerFallbackValue('test_token');
    registerFallbackValue(MockNavigationContext());
    registerFallbackValue(MockRef());
  });

  group('AuthenticationViewModel - Initialization', () {
    test('should initialize with init state', () {
      expect(viewModel.state, isA<State<User>>());
      expect(viewModel.state.isInit, isTrue);
    });

    test('loginStatusProvider should initialize with initial status', () {
      final loginStatus = container.read(loginStatusProvider);
      expect(loginStatus, equals(LoginStatusInfo.initial));
    });
  });

  group('AuthenticationViewModel - Login Success Flow', () {
    test('should update state and store user data when login succeeds',
        () async {
      // Arrange
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenAnswer((_) async => testUser);
      when(() => mockGetModulesUseCase.execute()).thenAnswer((_) async => []);

      final mockContext = MockNavigationContext();
      final mockGoRouter = MockGoRouter();

      // Setup GoRouter mock
      when(() => GoRouter.of(mockContext)).thenReturn(mockGoRouter);
      when(() => mockGoRouter.go(any())).thenAnswer((_) async {});
      when(() => mockRef.refresh(any())).thenReturn(null);

      // Act
      await viewModel.signInWithEmailAndPassword(
        'test@example.com',
        'password',
        mockContext,
        mockWidgetRef,
      );

      // Assert
      verify(() => mockLoginUseCase.execute('test@example.com', 'password'))
          .called(1);
      verify(() => mockSetIsLoggedInUseCase.execute(true)).called(1);
      verify(() => mockSetUserIdUseCase.execute(testUser.id)).called(1);
      verify(() => mockSetUserNameUseCase.execute('test@example.com'))
          .called(1);
      verify(() => mockSetTokenUseCase.execute(testUser.token)).called(1);

      // Vérifier que l'état final est bien success avec les données de l'utilisateur
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.state.data, equals(testUser));
    });
  });

  group('AuthenticationViewModel - Login Status Updates', () {
    test(
        'should update login status through different stages during login with empty database',
        () async {
      // Arrange
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenAnswer((_) async => testUser);
      when(() => mockGetModulesUseCase.execute())
          .thenAnswer((_) async => []); // Empty database triggers full sync

      final mockContext = MockNavigationContext();
      final mockGoRouter = MockGoRouter();

      // Setup GoRouter mock
      when(() => GoRouter.of(mockContext)).thenReturn(mockGoRouter);
      when(() => mockGoRouter.go(any())).thenAnswer((_) async {});
      when(() => mockRef.refresh(any())).thenReturn(null);

      // Observer les changements de status
      final statusLog = <LoginStatusInfo>[];
      container.listen(
        loginStatusProvider,
        (_, newState) => statusLog.add(newState),
        fireImmediately: true,
      );

      // Act
      await viewModel.signInWithEmailAndPassword(
        'test@example.com',
        'password',
        mockContext,
        mockWidgetRef,
      );

      // Assert
      expect(statusLog, contains(LoginStatusInfo.initial));
      expect(statusLog, contains(LoginStatusInfo.authenticating));
      expect(statusLog, contains(LoginStatusInfo.savingUserData));
      expect(statusLog, contains(LoginStatusInfo.fetchingModules));
      expect(statusLog, contains(LoginStatusInfo.fetchingSites));
      expect(statusLog, contains(LoginStatusInfo.fetchingSiteGroups));
      expect(statusLog, contains(LoginStatusInfo.complete));

      // Vérifier l'ordre des statuts
      expect(statusLog.indexOf(LoginStatusInfo.initial),
          lessThan(statusLog.indexOf(LoginStatusInfo.authenticating)));
      expect(statusLog.indexOf(LoginStatusInfo.authenticating),
          lessThan(statusLog.indexOf(LoginStatusInfo.savingUserData)));
      expect(statusLog.indexOf(LoginStatusInfo.savingUserData),
          lessThan(statusLog.indexOf(LoginStatusInfo.fetchingModules)));
      expect(statusLog.indexOf(LoginStatusInfo.fetchingModules),
          lessThan(statusLog.indexOf(LoginStatusInfo.fetchingSites)));
      expect(statusLog.indexOf(LoginStatusInfo.fetchingSites),
          lessThan(statusLog.indexOf(LoginStatusInfo.fetchingSiteGroups)));
      expect(statusLog.indexOf(LoginStatusInfo.fetchingSiteGroups),
          lessThan(statusLog.indexOf(LoginStatusInfo.complete)));
    });
  });

  group('AuthenticationViewModel - Error Handling', () {
    test('should handle network exceptions during login attempt', () async {
      // Arrange
      final networkException = NetworkException('No internet connection');
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenThrow(networkException);

      final mockContext = MockNavigationContext();

      // Act
      await viewModel.signInWithEmailAndPassword(
        'test@example.com',
        'password',
        mockContext,
        mockWidgetRef,
      );

      // Assert
      final loginStatus = container.read(loginStatusProvider);
      expect(loginStatus, isA<LoginStatusInfo>());
      expect(loginStatus.status, equals(LoginStatus.error));

      // Vérifier que l'état est en erreur
      expect(viewModel.state.isError, isTrue);
    });

    test('should handle API exceptions during login attempt', () async {
      // Arrange
      final apiException = ApiException('Invalid credentials', statusCode: 401);
      when(() => mockLoginUseCase.execute(any(), any()))
          .thenThrow(apiException);

      final mockContext = MockNavigationContext();

      // Act
      await viewModel.signInWithEmailAndPassword(
        'test@example.com',
        'password',
        mockContext,
        mockWidgetRef,
      );

      // Assert
      final loginStatus = container.read(loginStatusProvider);
      expect(loginStatus, isA<LoginStatusInfo>());
      expect(loginStatus.status, equals(LoginStatus.error));

      // Vérifier que l'état est en erreur
      expect(viewModel.state.isError, isTrue);
    });
  });

  group('AuthenticationViewModel - Logout', () {
    test('should clear user data on signOut', () async {
      // Arrange
      // Set initial state to success with test user
      viewModel = AuthenticationViewModel(
        mockLoginUseCase,
        mockSetIsLoggedInUseCase,
        mockSetUserIdUseCase,
        mockSetUserNameUseCase,
        mockSetTokenUseCase,
        mockClearUserIdUseCase,
        mockClearUserNameUseCase,
        mockClearTokenUseCase,
        mockFetchModulesUseCase,
        mockFetchSitesUseCase,
        mockFetchSiteGroupsUseCase,
        mockRef,
      )..state = State<User>.success(testUser);

      final mockContext = MockNavigationContext();
      final mockGoRouter = MockGoRouter();

      // Setup GoRouter mock
      when(() => GoRouter.of(mockContext)).thenReturn(mockGoRouter);
      when(() => mockGoRouter.go(any())).thenAnswer((_) async {});
      when(() => mockRef.refresh(any())).thenReturn(null);

      // Act
      await viewModel.signOut(mockWidgetRef, mockContext);

      // Assert
      verify(() => mockClearUserIdUseCase.execute()).called(1);
      verify(() => mockClearUserNameUseCase.execute()).called(1);
      verify(() => mockClearTokenUseCase.execute()).called(1);
      verify(() => mockSetIsLoggedInUseCase.execute(false)).called(1);
      verify(() => mockGoRouter.go('/login')).called(1);
    });
  });
}
