import 'package:gn_mobile_monitoring/domain/model/user.dart';

abstract class AuthenticationRepository {
  Future<User> login(final String identifiant, final String password);
}
