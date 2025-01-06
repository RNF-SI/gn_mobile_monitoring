import 'package:gn_mobile_monitoring/data/entity/user_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/user.dart';

class UserMapper {
  static User transformToModel(UserEntity entity) {
    return User(
      id: entity.idRole,
      name: entity.nomComplet,
      email: entity.email ?? 'No email provided',
      token: entity.token,
    );
  }
}
