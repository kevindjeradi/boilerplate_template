import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:boilerplate_template/features/settings/widgets/language_picker.dart';
import 'package:boilerplate_template/features/settings/widgets/theme_switch.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.settings),
      ),
      body: ListView(
        children: [
          LanguagePicker(localization: localization),
          ThemeSwitch(localization: localization),
        ],
      ),
    );
  }
}
