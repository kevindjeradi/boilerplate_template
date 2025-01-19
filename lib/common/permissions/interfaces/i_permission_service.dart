import '../enums/permission_type.dart';

abstract class IPermissionService {
  Future<bool> requestPermission(PermissionType permission);

  Future<bool> isPermissionGranted(PermissionType permission);

  Future<void> openAppSettings();
}
