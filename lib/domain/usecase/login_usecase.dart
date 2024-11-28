import 'package:gn_mobile_monitoring/domain/model/user.dart';

abstract class LoginUseCase {
  Future<User> execute(
    final String email,
    final String password,
  );
}
