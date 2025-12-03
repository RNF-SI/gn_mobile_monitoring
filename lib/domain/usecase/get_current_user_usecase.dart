import 'package:gn_mobile_monitoring/domain/model/user_role.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_current_user_usecase.g.dart';

@riverpod
class GetCurrentUserUseCase extends _$GetCurrentUserUseCase {
  @override
  Future<UserRole?> build() async {
    final permissionRepo = ref.read(permissionRepositoryProvider);
    return permissionRepo.getCurrentUser();
  }
}