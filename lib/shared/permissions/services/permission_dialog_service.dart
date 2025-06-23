import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:boilerplate_template/shared/permissions/interfaces/i_permission_service.dart';

class PermissionDialogService {
  final IPermissionService _permissionService;

  PermissionDialogService(this._permissionService);

  Future<void> showPermissionSettingsDialog(
    BuildContext context,
    String message,
  ) async {
    final localization = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.permissionRequired),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(localization.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(localization.openSettings),
              onPressed: () {
                Navigator.of(context).pop();
                _permissionService.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
