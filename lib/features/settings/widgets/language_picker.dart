import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePicker extends StatelessWidget {
  final AppLocalizations localization;

  const LanguagePicker({super.key, required this.localization});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();

    return Obx(() {
      return ListTile(
        leading: const Icon(Icons.language),
        title: Text(localization.language),
        subtitle:
            Text(_getLanguageName(settingsController.currentLocale.value)),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            _showLanguageDialog(context, settingsController, localization);
          },
        ),
      );
    });
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  void _showLanguageDialog(BuildContext context, SettingsController controller,
      AppLocalizations localization) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: controller.supportedLocales.map((Locale locale) {
              return RadioListTile<String>(
                title: Text(_getLanguageName(locale)),
                value: locale.languageCode,
                groupValue: controller.currentLocale.value.languageCode,
                onChanged: (String? value) {
                  if (value != null) {
                    controller.switchLocale(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
