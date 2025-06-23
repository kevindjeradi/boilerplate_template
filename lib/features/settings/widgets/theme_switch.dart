import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';

class ThemeSwitch extends ConsumerWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);

    // Pattern matching moderne pour obtenir le thème
    final themeMode = settings.when(
      data: (state) => state.themeMode,
      loading: () => ThemeMode.dark, // défaut pendant le chargement
      error: (_, __) => ThemeMode.dark, // défaut en cas d'erreur
    );

    final isDarkMode = themeMode == ThemeMode.dark;

    return ListTile(
      title: Text(localization.darkMode),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (bool value) {
          ref.read(settingsControllerProvider.notifier).toggleTheme();
        },
      ),
    );
  }
}
