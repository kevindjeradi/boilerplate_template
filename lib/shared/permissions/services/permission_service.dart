import 'package:boilerplate_template/shared/permissions/enums/permission_type.dart';
import 'package:boilerplate_template/shared/permissions/interfaces/i_permission_service.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

class PermissionService implements IPermissionService {
  @override
  Future<bool> requestPermission(PermissionType permissionType) async {
    final permission = _mapPermission(permissionType);
    final status = await permission.request();
    return status.isGranted;
  }

  @override
  Future<bool> isPermissionGranted(PermissionType permissionType) async {
    final permission = _mapPermission(permissionType);
    final status = await permission.status;
    return status.isGranted;
  }

  @override
  Future<bool> isPermissionPermanentlyDenied(
      PermissionType permissionType) async {
    final permission = _mapPermission(permissionType);
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  @override
  Future<void> openAppSettings() async {
    await permission_handler.openAppSettings();
  }

  permission_handler.Permission _mapPermission(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.camera:
        return permission_handler.Permission.camera;
      case PermissionType.location:
        return permission_handler.Permission.location;
      case PermissionType.storage:
        return permission_handler.Permission.storage;
      case PermissionType.microphone:
        return permission_handler.Permission.microphone;
    }
  }
}
