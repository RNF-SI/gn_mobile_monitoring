import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/user_mapper.dart';
import 'package:gn_mobile_monitoring/data/repository/authentication_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';

// Mock des dépendances
class MockAuthenticationApi extends Mock implements AuthenticationApi {}

void main() {
  late AuthenticationRepository repository;
  late MockAuthenticationApi mockAuthApi;

  setUp(() {
    mockAuthApi = MockAuthenticationApi();
    repository = AuthenticationRepositoryImpl(mockAuthApi);
  });

  group('AuthenticationRepository', () {
    // Données de test
    final testUsername = 'test@example.com';
    final testPassword = 'testPassword123';
    
    final testUserEntity = UserEntity(
      active: true,
      dateInsert: '2023-01-01',
      dateUpdate: '2023-01-01',
      email: 'test@example.com',
      groupe: false,
      idOrganisme: 1,
      idRole: 42,
      identifiant: 'testuser',
      maxLevelProfil: 5,
      nomComplet: 'Test User',
      nomRole: 'Tester',
      prenomRole: 'Test',
      token: 'test-token-xyz',
    );
    
    final expectedUser = User(
      id: 42,
      name: 'Test User',
      email: 'test@example.com',
      token: 'test-token-xyz',
    );

    test('login should return a User when authentication succeeds', () async {
      // Arrange
      when(() => mockAuthApi.login(testUsername, testPassword))
          .thenAnswer((_) async => testUserEntity);

      // Act
      final result = await repository.login(testUsername, testPassword);

      // Assert
      expect(result, equals(expectedUser));
      verify(() => mockAuthApi.login(testUsername, testPassword)).called(1);
    });

    test('login should throw exception when authentication API fails', () async {
      // Arrange
      when(() => mockAuthApi.login(any(), any()))
          .thenThrow(Exception('Authentication failed'));

      // Act & Assert
      expect(
        () => repository.login(testUsername, testPassword),
        throwsA(isA<Exception>()),
      );
      verify(() => mockAuthApi.login(testUsername, testPassword)).called(1);
    });
    
    test('login should map UserEntity to User correctly', () async {
      // Arrange
      final customUserEntity = UserEntity(
        active: true,
        dateInsert: '2023-01-01',
        dateUpdate: '2023-01-01',
        email: null, // Test null email handling
        groupe: false,
        idOrganisme: 1,
        idRole: 100,
        identifiant: 'user100',
        maxLevelProfil: 3,
        nomComplet: 'Custom User',
        nomRole: 'Custom',
        prenomRole: 'User',
        token: 'custom-token',
      );
      
      final expectedCustomUser = User(
        id: 100,
        name: 'Custom User',
        email: 'No email provided', // Should use fallback email
        token: 'custom-token',
      );
      
      when(() => mockAuthApi.login(any(), any()))
          .thenAnswer((_) async => customUserEntity);

      // Act
      final result = await repository.login('custom', 'password');

      // Assert
      expect(result, equals(expectedCustomUser));
      verify(() => mockAuthApi.login('custom', 'password')).called(1);
    });
  });
}
