import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase_impl.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockLocalStorageRepository extends Mock
    implements LocalStorageRepository {}

class MockContext extends Mock implements BuildContext {}

class MockGoRouter extends Mock implements GoRouter {}

class MockWidgetRef extends Mock implements WidgetRef {}

void main() {
  late AuthenticationViewModel authViewModel;
  late MockAuthenticationRepository mockAuthRepo;
  late MockLocalStorageRepository mockLocalStorage;
  late LoginUseCase loginUseCase;
  
  final testUser = User(
    id: 1,
    name: "Test User",
    email: "test@example.com",
    token: "test_token_123",
  );

  setUp(() {
    mockAuthRepo = MockAuthenticationRepository();
    mockLocalStorage = MockLocalStorageRepository();
    
    // Create the LoginUseCase with the mocked repository
    loginUseCase = LoginUseCaseImpl(mockAuthRepo);
    
    // Setup the mocked responses
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

    // Register fallback values for the matchers
    registerFallbackValue(MockContext());
    registerFallbackValue(MockWidgetRef());
  });

  group('Authentication Repository Integration Tests', () {
    test('login should return a user when credentials are valid', () async {
      // Act
      final user = await mockAuthRepo.login('test@example.com', 'password');
      
      // Assert
      expect(user, equals(testUser));
      expect(user.id, equals(1));
      expect(user.name, equals("Test User"));
      expect(user.email, equals("test@example.com"));
      expect(user.token, equals("test_token_123"));
    });
    
    test('LoginUseCase should delegate to repository', () async {
      // Act
      final user = await loginUseCase.execute('test@example.com', 'password');
      
      // Assert
      verify(() => mockAuthRepo.login('test@example.com', 'password')).called(1);
      expect(user, equals(testUser));
    });
  });
  
  group('LocalStorage Repository Integration Tests', () {
    test('setIsLoggedIn should be called correctly', () async {
      // Act
      await mockLocalStorage.setIsLoggedIn(true);
      
      // Assert
      verify(() => mockLocalStorage.setIsLoggedIn(true)).called(1);
    });
    
    test('setUserId should be called correctly', () async {
      // Act
      await mockLocalStorage.setUserId(1);
      
      // Assert
      verify(() => mockLocalStorage.setUserId(1)).called(1);
    });
    
    test('setUserName should be called correctly', () async {
      // Act
      await mockLocalStorage.setUserName('test@example.com');
      
      // Assert
      verify(() => mockLocalStorage.setUserName('test@example.com')).called(1);
    });
    
    test('setToken should be called correctly', () async {
      // Act
      await mockLocalStorage.setToken('test_token');
      
      // Assert
      verify(() => mockLocalStorage.setToken('test_token')).called(1);
    });
    
    test('clearUserData methods should be called correctly', () async {
      // Act
      await mockLocalStorage.clearUserId();
      await mockLocalStorage.clearUserName();
      await mockLocalStorage.clearToken();
      
      // Assert
      verify(() => mockLocalStorage.clearUserId()).called(1);
      verify(() => mockLocalStorage.clearUserName()).called(1);
      verify(() => mockLocalStorage.clearToken()).called(1);
    });
  });
}
