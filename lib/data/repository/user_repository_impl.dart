import '../../domain/model/user.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/usecase/get_token_from_local_storage_usecase.dart';
import '../../domain/usecase/get_user_id_from_local_storage_use_case.dart';
import '../../domain/usecase/get_user_name_from_local_storage_use_case.dart';
import '../../domain/usecase/clear_token_from_local_storage_use_case.dart';
import '../../domain/usecase/clear_user_id_from_local_storage_use_case.dart';
import '../../domain/usecase/clear_user_name_from_local_storage_use_case.dart';

class UserRepositoryImpl implements UserRepository {
  final GetUserIdFromLocalStorageUseCase getUserIdUseCase;
  final GetUserNameFromLocalStorageUseCase getUserNameUseCase;
  final GetTokenFromLocalStorageUseCase getTokenUseCase;
  final ClearUserIdFromLocalStorageUseCase clearUserIdUseCase;
  final ClearUserNameFromLocalStorageUseCase clearUserNameUseCase;
  final ClearTokenFromLocalStorageUseCase clearTokenUseCase;

  UserRepositoryImpl({
    required this.getUserIdUseCase,
    required this.getUserNameUseCase,
    required this.getTokenUseCase,
    required this.clearUserIdUseCase,
    required this.clearUserNameUseCase,
    required this.clearTokenUseCase,
  });

  @override
  Future<User?> getCurrentUser() async {
    final id = await getUserIdUseCase.execute();
    final name = await getUserNameUseCase.execute();
    final token = await getTokenUseCase.execute();

    if (name != null && token != null) {
      return User(
        id: id,
        name: name,
        email: '', // Email is not stored in local storage in this app
        token: token,
        organismeId: null, // TODO: Store and retrieve organismeId if needed
      );
    }

    return null;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  @override
  Future<void> clearUserData() async {
    await clearUserIdUseCase.execute();
    await clearUserNameUseCase.execute();
    await clearTokenUseCase.execute();
  }
}