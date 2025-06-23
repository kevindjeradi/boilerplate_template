import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:boilerplate_template/shared/user/interfaces/i_user_service.dart';
import 'package:boilerplate_template/shared/user/services/user_service.dart';
import 'package:boilerplate_template/shared/permissions/interfaces/i_permission_service.dart';
import 'package:boilerplate_template/shared/permissions/services/permission_service.dart';
import 'package:boilerplate_template/shared/permissions/services/permission_dialog_service.dart';

part 'shared_providers.g.dart';

// ==================== SHARED PROVIDERS ====================

@Riverpod(keepAlive: true)
IUserService userService(Ref ref) {
  return UserService();
}

@Riverpod(keepAlive: true)
IPermissionService permissionService(Ref ref) {
  return PermissionService();
}

@Riverpod(keepAlive: true)
PermissionDialogService permissionDialogService(Ref ref) {
  final permissionService = ref.read(permissionServiceProvider);
  return PermissionDialogService(permissionService);
}
