import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:boilerplate_template/shared/services/app_logger.dart';
import 'package:boilerplate_template/shared/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/shared/user/models/user_model.dart';
import 'package:boilerplate_template/shared/providers/shared_providers.dart';
import 'package:boilerplate_template/shared/exceptions/user_exceptions.dart';

part 'user_controller.g.dart';

// Controller moderne avec Riverpod 3.0 - État simple UserModel nullable
@Riverpod(keepAlive: true)
class UserController extends _$UserController {
  late final IUserService _userService;

  @override
  UserModel? build() {
    AppLogger.info('Initializing UserController');

    _userService = ref.read(userServiceProvider);

    return null;
  }

  // Méthodes simplifiées avec try/catch
  Future<void> fetchCurrentUser(String uid) async {
    if (!_canPerformOperation()) return;

    AppLogger.info('Fetching user with uid: $uid');

    try {
      UserModel? user = await _userService.getUser(uid);

      if (_canPerformOperation()) {
        if (user != null) {
          AppLogger.info('User fetched successfully: ${user.email}');
          state = user;
        } else {
          AppLogger.warning('User not found for uid: $uid');
          state = null;
          throw UserException.notFound();
        }
      }
    } catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Failed to fetch user', e);
        state = null;
        if (e is UserException) {
          rethrow;
        } else {
          throw UserException.fetchFailed();
        }
      }
    }
  }

  Future<void> updateUser(UserModel user) async {
    if (!_canPerformOperation()) return;

    AppLogger.info('Updating user: ${user.email}');

    try {
      await _userService.updateUser(user);

      if (_canPerformOperation()) {
        AppLogger.info('User updated successfully');
        state = user;
      }
    } catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Failed to update user', e);
        throw UserException.updateFailed();
      }
    }
  }

  Future<void> deleteUser(String uid) async {
    if (!_canPerformOperation()) return;

    AppLogger.info('Deleting user with uid: $uid');

    try {
      await _userService.deleteUser(uid);

      if (_canPerformOperation()) {
        AppLogger.info('User deleted successfully');
        state = null;
      }
    } catch (e) {
      if (_canPerformOperation()) {
        AppLogger.error('Failed to delete user', e);
        throw UserException.deleteFailed();
      }
    }
  }

  void clearUser() {
    AppLogger.info('Clearing user state');
    state = null;
  }

  void resetState() {
    state = null;
  }

  // Guard pour vérifier si on peut encore effectuer des opérations
  bool _canPerformOperation() {
    return ref.exists(userControllerProvider);
  }
}

// Helper providers simplifiés
@riverpod
UserModel? currentUser(Ref ref) {
  return ref.watch(userControllerProvider);
}

@riverpod
bool hasUser(Ref ref) {
  return ref.watch(userControllerProvider) != null;
}
