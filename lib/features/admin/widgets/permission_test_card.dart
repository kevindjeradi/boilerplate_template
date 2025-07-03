import 'package:flutter/material.dart';
import 'package:boilerplate_template/shared/permissions/controllers/permission_controller.dart';
import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';

class PermissionTestCard extends StatelessWidget {
  const PermissionTestCard({
    super.key,
    required this.permissionStatus,
    required this.onRequestPermission,
  });

  final PermissionStatus permissionStatus;
  final VoidCallback onRequestPermission;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: context.marginSmall,
          children: [
            const Text(
              'Permission Testing:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: onRequestPermission,
              child: const Text('Request Camera Permission'),
            ),
            Row(
              spacing: context.marginSmall,
              children: [
                Icon(
                  _getPermissionIcon(permissionStatus),
                  color: _getPermissionColor(permissionStatus),
                ),
                Expanded(
                  child: Text(_getPermissionText(permissionStatus)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPermissionIcon(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => Icons.check_circle,
      PermissionStatus.denied => Icons.cancel,
      PermissionStatus.permanentlyDenied => Icons.block,
      PermissionStatus.requesting => Icons.hourglass_empty,
      PermissionStatus.initial => Icons.help_outline,
    };
  }

  Color _getPermissionColor(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => Colors.green,
      PermissionStatus.denied => Colors.orange,
      PermissionStatus.permanentlyDenied => Colors.red,
      PermissionStatus.requesting => Colors.blue,
      PermissionStatus.initial => Colors.grey,
    };
  }

  String _getPermissionText(PermissionStatus status) {
    return switch (status) {
      PermissionStatus.granted => 'Permission granted',
      PermissionStatus.denied => 'Permission denied',
      PermissionStatus.permanentlyDenied => 'Permission permanently denied',
      PermissionStatus.requesting => 'Requesting permission...',
      PermissionStatus.initial => 'No permission requests yet',
    };
  }
}
