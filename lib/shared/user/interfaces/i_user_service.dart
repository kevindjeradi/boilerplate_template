import '../models/user_model.dart';

abstract class IUserService {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String uid);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String uid);
}
