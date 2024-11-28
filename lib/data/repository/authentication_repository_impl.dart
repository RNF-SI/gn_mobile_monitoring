import 'package:gn_mobile_monitoring/data/datasource/interface/api/authentication_api.dart';
import 'package:gn_mobile_monitoring/data/mapper/user_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';
import 'package:gn_mobile_monitoring/domain/repository/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationApi api;

  const AuthenticationRepositoryImpl(this.api);

  @override
  Future<User> login(final String identifiant, final String password) async {
    try {
      // Get UserEntity from API
      final userEntity = await api.login(identifiant, password);

      // Map UserEntity to User
      return UserMapper.transformToModel(
          userEntity); // Automatically wrapped in Future
    } catch (e) {
      // Handle or log the error accordingly
      print("Error in AuthenticationRepositoryImpl login: $e");
      rethrow;
    }
  }
}
