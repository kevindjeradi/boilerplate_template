import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemeSwitch extends StatelessWidget {
  final AppLocalizations localization;

  const ThemeSwitch({required this.localization, super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return Obx(() {
      return SwitchListTile(
        secondary: const Icon(Icons.brightness_6),
        title: Text(localization.darkMode),
        value: settingsController.themeMode.value == ThemeMode.dark,
        onChanged: (bool value) {
          settingsController.toggleTheme();
        },
      );
    });
  }
}
