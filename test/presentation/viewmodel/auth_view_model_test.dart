import 'package:flutter/material.dart' hide State;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart' as app_state;
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks pour les dépendances
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSetIsLoggedInFromLocalStorageUseCase extends Mock implements SetIsLoggedInFromLocalStorageUseCase {}
class MockSetUserIdFromLocalStorageUseCase extends Mock implements SetUserIdFromLocalStorageUseCase {}
class MockSetUserNameFromLocalStorageUseCase extends Mock implements SetUserNameFromLocalStorageUseCase {}
class MockSetTokenFromLocalStorageUseCase extends Mock implements SetTokenFromLocalStorageUseCase {}
class MockClearUserIdFromLocalStorageUseCase extends Mock implements ClearUserIdFromLocalStorageUseCase {}
class MockClearUserNameFromLocalStorageUseCase extends Mock implements ClearUserNameFromLocalStorageUseCase {}
class MockClearTokenFromLocalStorageUseCase extends Mock implements ClearTokenFromLocalStorageUseCase {}
class MockFetchModulesUseCase extends Mock implements FetchModulesUseCase {}
class MockFetchSitesUseCase extends Mock implements FetchSitesUseCase {}
class MockFetchSiteGroupsUseCase extends Mock implements FetchSiteGroupsUseCase {}
class MockGetModulesUseCase extends Mock implements GetModulesUseCase {}
class MockRef extends Mock implements Ref<Object?> {}

// Classe de test
void main() {
  late AuthenticationViewModel viewModel;
  
  // Mocks pour les use cases
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
  
  // User data
  final testUser = User(
    id: 1,
    name: "Test User",
    email: "test@example.com",
    token: "test_token_123",
  );

  setUp(() {
    // Initialisation des mocks
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
    mockRef = MockRef();
    
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
  });
  
  group('AuthenticationViewModel', () {
    test('should initialize with init state', () {
      // Assert
      expect(viewModel.state, isA<app_state.State<User>>());
      expect(viewModel.state.isInit, isTrue);
    });
  });
}
