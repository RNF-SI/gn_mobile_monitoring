import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';

abstract class AuthenticationApi {
  Future<UserEntity> login(String email, String password);
}
