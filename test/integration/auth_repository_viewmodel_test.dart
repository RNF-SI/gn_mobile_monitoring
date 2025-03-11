import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_is_logged_in_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case_impl.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as loadingState;
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

mixin LocalStorageRepositoryMixin implements LocalStorageRepository {
  @override
  Future<bool> getIsLoggedIn() async => false;

  @override
  Future<void> setIsLoggedIn(bool isLoggedIn) async {}

  @override
  Future<void> setUserId(int userId) async {}

  @override
  Future<void> setUserName(String userName) async {}

  @override
  Future<void> setToken(String token) async {}

  @override
  Future<void> clearUserId() async {}

  @override
  Future<void> clearUserName() async {}

  @override
  Future<void> clearToken() async {}

  @override
  Future<int> getUserId() async => 0;

  @override
  Future<String?> getUserName() async => null;

  @override
  Future<String?> getToken() async => null;

  @override
  Future<void> setTerminalName(String terminalName) async {}

  @override
  Future<String?> getTerminalName() async => null;
}

class MockLocalStorageRepository extends Mock
    with LocalStorageRepositoryMixin {}

class MockNavigationContext extends Mock implements BuildContext {
  @override
  String toString() => 'MockContext';
}

class MockNavigator extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      'MockNavigator';
}

class MockGoRouter extends Mock implements GoRouter {}

class MockWidgetRef extends Mock implements Ref<Object?>, WidgetRef {
  @override
  T read<T>(ProviderListenable<T> provider) => throw UnimplementedError();

  @override
  T watch<T>(ProviderListenable<T> provider) => throw UnimplementedError();
}

class MockModulesRepository extends Mock implements ModulesRepository {}

class MockSitesRepository extends Mock implements SitesRepository {}

class MockFetchModulesUseCase extends Mock implements FetchModulesUseCase {
  @override
  Future<void> execute(String token) async {}
}

class MockFetchSitesUseCase extends Mock implements FetchSitesUseCase {
  @override
  Future<void> execute(String token) async {}
}

class MockFetchSiteGroupsUseCase extends Mock
    implements FetchSiteGroupsUseCase {
  @override
  Future<void> execute(String token) async {}
}

class MockGetModulesUseCase extends Mock implements GetModulesUseCase {
  @override
  Future<List<Module>> execute() async => [];
}

void main() {
  late AuthenticationViewModel authViewModel;
  late MockAuthenticationRepository mockAuthRepo;
  late MockLocalStorageRepository mockLocalStorage;
  late LoginUseCase loginUseCase;
  late SetIsLoggedInFromLocalStorageUseCase setIsLoggedInUseCase;
  late SetUserIdFromLocalStorageUseCase setUserIdUseCase;
  late SetUserNameFromLocalStorageUseCase setUserNameUseCase;
  late SetTokenFromLocalStorageUseCase setTokenUseCase;
  late ClearUserIdFromLocalStorageUseCase clearUserIdUseCase;
  late ClearUserNameFromLocalStorageUseCase clearUserNameUseCase;
  late ClearTokenFromLocalStorageUseCase clearTokenUseCase;
  late GetIsLoggedInFromLocalStorageUseCase getIsLoggedInUseCase;
  late MockWidgetRef mockRef;
  late ProviderContainer container;
  late MockGetModulesUseCase mockGetModulesUseCase;
  late MockFetchModulesUseCase mockFetchModulesUseCase;
  late MockFetchSitesUseCase mockFetchSitesUseCase;
  late MockFetchSiteGroupsUseCase mockFetchSiteGroupsUseCase;

  final testUser = User(
    id: 1,
    name: "Test User",
    email: "test@example.com",
    token: "test_token_123",
  );

  setUp(() {
    mockAuthRepo = MockAuthenticationRepository();
    mockLocalStorage = MockLocalStorageRepository();
    mockRef = MockWidgetRef();
    mockGetModulesUseCase = MockGetModulesUseCase();
    mockFetchModulesUseCase = MockFetchModulesUseCase();
    mockFetchSitesUseCase = MockFetchSitesUseCase();
    mockFetchSiteGroupsUseCase = MockFetchSiteGroupsUseCase();

    loginUseCase = LoginUseCaseImpl(mockAuthRepo);
    setIsLoggedInUseCase =
        SetIsLoggedInFromLocalStorageUseCaseImpl(mockLocalStorage);
    setUserIdUseCase = SetUserIdFromLocalStorageUseCaseImpl(mockLocalStorage);
    setUserNameUseCase =
        SetUserNameFromLocalStorageUseCaseImpl(mockLocalStorage);
    setTokenUseCase = SetTokenFromLocalStorageUseCaseImpl(mockLocalStorage);
    clearUserIdUseCase =
        ClearUserIdFromLocalStorageUseCaseImpl(mockLocalStorage);
    clearUserNameUseCase =
        ClearUserNameFromLocalStorageUseCaseImpl(mockLocalStorage);
    clearTokenUseCase = ClearTokenFromLocalStorageUseCaseImpl(mockLocalStorage);
    getIsLoggedInUseCase =
        GetIsLoggedInFromLocalStorageUseCaseImpl(mockLocalStorage);

    when(() => mockAuthRepo.login(any(), any()))
        .thenAnswer((_) async => testUser);
    when(() => mockLocalStorage.setIsLoggedIn(any())).thenAnswer((_) async {});
    when(() => mockLocalStorage.setUserId(any())).thenAnswer((_) async {});
    when(() => mockLocalStorage.setUserName(any())).thenAnswer((_) async {});
    when(() => mockLocalStorage.setToken(any())).thenAnswer((_) async {});
    when(() => mockLocalStorage.clearUserId()).thenAnswer((_) async {});
    when(() => mockLocalStorage.clearUserName()).thenAnswer((_) async {});
    when(() => mockLocalStorage.clearToken()).thenAnswer((_) async {});
    when(() => mockLocalStorage.getIsLoggedIn()).thenAnswer((_) async => false);
    when(() => mockRef.read(any())).thenReturn(mockGetModulesUseCase);
    when(() => mockRef.refresh(any())).thenReturn(null);

    authViewModel = AuthenticationViewModel(
      loginUseCase,
      setIsLoggedInUseCase,
      setUserIdUseCase,
      setUserNameUseCase,
      setTokenUseCase,
      clearUserIdUseCase,
      clearUserNameUseCase,
      clearTokenUseCase,
      mockFetchModulesUseCase,
      mockFetchSitesUseCase,
      mockFetchSiteGroupsUseCase,
      mockRef,
    );

    container = ProviderContainer(
      overrides: [
        authenticationViewModelProvider.overrideWithValue(authViewModel),
        loginStatusProvider.overrideWith((ref) => LoginStatusInfo.initial),
      ],
    );

    registerFallbackValue(MockNavigationContext());
    registerFallbackValue(MockWidgetRef());
  });

  group('Authentication Repository with ViewModel Integration', () {
    test('Login should correctly integrate from Repository to ViewModel',
        () async {
      // Arrange
      when(() => mockAuthRepo.login('test@example.com', 'password'))
          .thenAnswer((_) async => testUser);

      final mockContext = MockNavigationContext();
      final mockGoRouter = MockGoRouter();

      when(() => GoRouter.of(mockContext)).thenReturn(mockGoRouter);
      when(() => mockGoRouter.go(any())).thenAnswer((_) async {});

      // Act
      await authViewModel.signInWithEmailAndPassword(
        'test@example.com',
        'password',
        mockContext,
        mockRef,
      );

      // Assert
      verify(() => mockAuthRepo.login('test@example.com', 'password'))
          .called(1);
      verify(() => mockLocalStorage.setIsLoggedIn(true)).called(1);
      verify(() => mockLocalStorage.setUserId(testUser.id)).called(1);
      verify(() => mockLocalStorage.setUserName('test@example.com')).called(1);
      verify(() => mockLocalStorage.setToken(testUser.token)).called(1);

      expect(authViewModel.state, isA<loadingState.State<User>>());
      expect(authViewModel.state.isSuccess, isTrue);
      expect(authViewModel.state.data, equals(testUser));
    });

    test('Logout should correctly integrate from Repository to ViewModel',
        () async {
      // Arrange
      final mockContext = MockNavigationContext();
      final mockGoRouter = MockGoRouter();

      when(() => GoRouter.of(mockContext)).thenReturn(mockGoRouter);
      when(() => mockGoRouter.go(any())).thenAnswer((_) async {});

      // Act
      await authViewModel.signOut(mockRef, mockContext);

      // Assert
      verify(() => mockLocalStorage.clearUserId()).called(1);
      verify(() => mockLocalStorage.clearUserName()).called(1);
      verify(() => mockLocalStorage.clearToken()).called(1);
      verify(() => mockLocalStorage.setIsLoggedIn(false)).called(1);
      verify(() => mockGoRouter.go('/login')).called(1);

      expect(authViewModel.state, isA<loadingState.State<User>>());
      expect(authViewModel.state.isInit, isTrue);
    });
  });
}
