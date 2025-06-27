import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:boilerplate_template/features/settings/widgets/language_picker.dart';
import 'package:boilerplate_template/features/settings/widgets/theme_switch.dart';
import 'package:boilerplate_template/core/router/app_router.dart';

class SettingsScreenDesktop extends ConsumerWidget {
  const SettingsScreenDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.pop(context),
        ),
      ),
      body: ListView(
        children: const [
          ThemeSwitch(),
          Divider(),
          LanguagePicker(),
          Divider(),
          // Add more settings widgets here as needed
        ],
      ),
    );
  }
}
