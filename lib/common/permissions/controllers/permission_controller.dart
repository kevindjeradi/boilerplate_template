import 'package:boilerplate_template/common/permissions/enums/permission_type.dart';
import 'package:boilerplate_template/common/permissions/interfaces/i_permission_service.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PermissionController {
  final IPermissionService _permissionService;

  PermissionController(this._permissionService);

  Future<bool> handlePermission(PermissionType permissionType) async {
    bool isGranted =
        await _permissionService.isPermissionGranted(permissionType);
    if (!isGranted) {
      isGranted = await _permissionService.requestPermission(permissionType);
      if (!isGranted) {
        await _showPermissionDeniedDialog(permissionType);
      }
    }
    return isGranted;
  }

  Future<void> _showPermissionDeniedDialog(
      PermissionType permissionType) async {
    final localization = AppLocalizations.of(Get.context!)!;
    String permissionName = _getPermissionName(permissionType, localization);

    await Get.defaultDialog(
      title: localization.permissionRequired,
      middleText: localization.permissionDeniedMessage(permissionName),
      textCancel: localization.cancel,
      textConfirm: localization.openSettings,
      onConfirm: () {
        _permissionService.openAppSettings();
        Get.back();
      },
      onCancel: () {},
    );
  }

  String _getPermissionName(
      PermissionType permissionType, AppLocalizations localization) {
    switch (permissionType) {
      case PermissionType.camera:
        return localization.camera;
      case PermissionType.location:
        return localization.location;
      case PermissionType.storage:
        return localization.storage;
      case PermissionType.microphone:
        return localization.microphone;

      default:
        return '';
    }
  }
}
