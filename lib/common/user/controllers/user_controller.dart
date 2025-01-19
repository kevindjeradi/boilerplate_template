import 'package:get/get.dart';
import 'package:boilerplate_template/common/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/common/user/models/user_model.dart';

class UserController extends GetxController {
  final IUserService _userService;

  UserController(this._userService);

  Rxn<UserModel> currentUser = Rxn<UserModel>();
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Future<void> fetchCurrentUser(String uid) async {
    isLoading.value = true;
    try {
      UserModel? user = await _userService.getUser(uid);
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = 'Failed to fetch user';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUser(UserModel user) async {
    isLoading.value = true;
    try {
      await _userService.updateUser(user);
      currentUser.value = user;
    } catch (e) {
      errorMessage.value = 'Failed to update user';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String uid) async {
    isLoading.value = true;
    try {
      await _userService.deleteUser(uid);
      currentUser.value = null;
    } catch (e) {
      errorMessage.value = 'Failed to delete user';
    } finally {
      isLoading.value = false;
    }
  }
}
