import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/login_usecase_impl.dart';

// Mock des dépendances
class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthenticationRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    useCase = LoginUseCaseImpl(mockRepository);
  });

  group('LoginUseCase', () {
    // Données de test
    final testEmail = 'test@example.com';
    final testPassword = 'securePassword123';
    final testUser = User(
      id: 42,
      name: 'Test User',
      email: 'test@example.com',
      token: 'test-token-xyz',
    );

    test('should call repository and return user data', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await useCase.execute(testEmail, testPassword);

      // Assert
      expect(result, equals(testUser));
      verify(() => mockRepository.login(testEmail, testPassword)).called(1);
    });

    test('should pass credentials to repository without modification', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenAnswer((_) async => testUser);
      
      final specialEmail = 'user+special@domain.com';
      final complexPassword = 'P@\$\$w0rd!123';

      // Act
      await useCase.execute(specialEmail, complexPassword);

      // Assert
      verify(() => mockRepository.login(specialEmail, complexPassword)).called(1);
    });

    test('should handle authentication errors from repository', () async {
      // Arrange
      when(() => mockRepository.login(any(), any()))
          .thenThrow(Exception('Authentication failed'));

      // Act & Assert
      expect(
        () => useCase.execute(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
      verify(() => mockRepository.login(testEmail, testPassword)).called(1);
    });
  });
}
