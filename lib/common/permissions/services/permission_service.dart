import 'package:boilerplate_template/common/permissions/enums/permission_type.dart';
import 'package:boilerplate_template/common/permissions/interfaces/i_permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  Permission _mapPermission(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.microphone:
        return Permission.microphone;
      default:
        throw UnimplementedError('Permission not implemented');
    }
  }
}
