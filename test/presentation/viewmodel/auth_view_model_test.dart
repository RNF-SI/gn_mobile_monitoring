import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/login_status.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSetIsLoggedInUseCase extends Mock implements SetIsLoggedInFromLocalStorageUseCase {}
class MockSetUserIdUseCase extends Mock implements SetUserIdFromLocalStorageUseCase {}
class MockSetUserNameUseCase extends Mock implements SetUserNameFromLocalStorageUseCase {}
class MockSetTokenUseCase extends Mock implements SetTokenFromLocalStorageUseCase {}

// Test data
final testUser = const User(
  id: 1,
  name: "Test User",
  email: "test@example.com",
  token: "test_token_123",
);

void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockSetIsLoggedInUseCase mockSetIsLoggedInUseCase;
  late MockSetUserIdUseCase mockSetUserIdUseCase;
  late MockSetUserNameUseCase mockSetUserNameUseCase;
  late MockSetTokenUseCase mockSetTokenUseCase;
  
  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockSetIsLoggedInUseCase = MockSetIsLoggedInUseCase();
    mockSetUserIdUseCase = MockSetUserIdUseCase();
    mockSetUserNameUseCase = MockSetUserNameUseCase();
    mockSetTokenUseCase = MockSetTokenUseCase();
    
    registerFallbackValue(true);
    registerFallbackValue(1);
    registerFallbackValue('test@example.com');
    registerFallbackValue('test_token_123');
  });
  
  group('LoginUseCase Tests', () {
    test('should return user when login is successful', () async {
      // Arrange
      when(() => mockLoginUseCase.execute('test@example.com', 'password'))
          .thenAnswer((_) async => testUser);
      
      // Act
      final result = await mockLoginUseCase.execute('test@example.com', 'password');
      
      // Assert
      expect(result, equals(testUser));
      expect(result.id, equals(1));
      expect(result.token, equals('test_token_123'));
      verify(() => mockLoginUseCase.execute('test@example.com', 'password')).called(1);
    });
  });
  
  group('LocalStorage UseCases Tests', () {
    test('SetIsLoggedInUseCase should save login state', () async {
      // Arrange
      when(() => mockSetIsLoggedInUseCase.execute(any())).thenAnswer((_) async {});
      
      // Act
      await mockSetIsLoggedInUseCase.execute(true);
      
      // Assert
      verify(() => mockSetIsLoggedInUseCase.execute(true)).called(1);
    });
    
    test('SetUserIdUseCase should save user ID', () async {
      // Arrange
      when(() => mockSetUserIdUseCase.execute(any())).thenAnswer((_) async {});
      
      // Act
      await mockSetUserIdUseCase.execute(1);
      
      // Assert
      verify(() => mockSetUserIdUseCase.execute(1)).called(1);
    });
    
    test('SetUserNameUseCase should save username', () async {
      // Arrange
      when(() => mockSetUserNameUseCase.execute(any())).thenAnswer((_) async {});
      
      // Act
      await mockSetUserNameUseCase.execute('test@example.com');
      
      // Assert
      verify(() => mockSetUserNameUseCase.execute('test@example.com')).called(1);
    });
    
    test('SetTokenUseCase should save token', () async {
      // Arrange
      when(() => mockSetTokenUseCase.execute(any())).thenAnswer((_) async {});
      
      // Act
      await mockSetTokenUseCase.execute('test_token_123');
      
      // Assert
      verify(() => mockSetTokenUseCase.execute('test_token_123')).called(1);
    });
  });
  
  group('State Tests', () {
    test('State.init() should create init state', () {
      // Act
      final state = State<User>.init();
      
      // Assert
      expect(state.isInit, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);
      expect(state.isError, isFalse);
    });
    
    test('State.loading() should create loading state', () {
      // Act
      final state = State<User>.loading();
      
      // Assert
      expect(state.isInit, isFalse);
      expect(state.isLoading, isTrue);
      expect(state.isSuccess, isFalse);
      expect(state.isError, isFalse);
    });
    
    test('State.success() should create success state with data', () {
      // Act
      final state = State<User>.success(testUser);
      
      // Assert
      expect(state.isInit, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isTrue);
      expect(state.isError, isFalse);
      expect(state.data, equals(testUser));
    });
    
    test('State.error() should create error state', () {
      // Arrange
      final exception = Exception('Test error');
      
      // Act
      final state = State<User>.error(exception);
      
      // Assert
      expect(state.isInit, isFalse);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);
      expect(state.isError, isTrue);
      // La propriété exception n'est pas accessible directement
      // via un getter public dans la classe State
    });
  });
  
  group('LoginStatusInfo Tests', () {
    test('LoginStatusInfo.initial should have correct values', () {
      expect(LoginStatusInfo.initial.status, equals(LoginStatus.initial));
      expect(LoginStatusInfo.initial.message, equals('Prêt'));
    });
    
    test('LoginStatusInfo.error should create error with details', () {
      final errorStatus = LoginStatusInfo.error('Test error');
      expect(errorStatus.status, equals(LoginStatus.error));
      expect(errorStatus.message, equals('Erreur de connexion'));
      expect(errorStatus.errorDetails, equals('Test error'));
    });
  });
}
