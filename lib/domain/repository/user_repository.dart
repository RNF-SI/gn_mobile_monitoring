import '../model/user.dart';

abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<bool> isUserLoggedIn();
  Future<void> clearUserData();
}