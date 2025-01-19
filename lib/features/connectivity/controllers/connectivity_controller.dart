import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

import 'package:boilerplate_template/common/constants/app_sizes.dart';
import 'package:boilerplate_template/common/theme/app_theme.dart';
import 'package:boilerplate_template/features/connectivity/interfaces/i_connectivity_service.dart';

class ConnectivityController extends GetxController {
  final IConnectivityService _connectivityService;
  Rx<ConnectivityStatus> currentStatus = ConnectivityStatus.online.obs;

  ConnectivityController(this._connectivityService);

  @override
  void onInit() {
    super.onInit();
    _connectivityService.connectivityStatus.listen((status) {
      currentStatus.value = status;
      if (status == ConnectivityStatus.offline) {
        _showOfflineSnackbar();
      }
    });
  }

  void _showOfflineSnackbar() {
    final BuildContext context = Get.context!;
    final localization = AppLocalizations.of(context)!;
    final ThemeData theme =
        Get.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

    if (context.mounted) {
      Get.snackbar(
        localization.offline,
        localization.currentlyOffline,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: theme.colorScheme.error,
        colorText: theme.colorScheme.onError,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(AppSizes.marginSmall),
        borderRadius: AppSizes.borderRadiusMedium,
        titleText: Text(
          localization.offline,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onError,
            fontSize: AppSizes.textLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        messageText: Text(
          localization.currentlyOffline,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onError.withOpacity(0.9),
            fontSize: AppSizes.textMedium,
          ),
        ),
        icon: Icon(
          Icons.wifi_off,
          color: theme.colorScheme.onError,
        ),
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }
}
