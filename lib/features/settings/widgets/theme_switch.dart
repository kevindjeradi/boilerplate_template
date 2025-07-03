import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:boilerplate_template/shared/widgets/custom_toggle_switch.dart';

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
      leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      title:
          Text(isDarkMode ? localization.darkTheme : localization.lightTheme),
      trailing: CustomToggleSwitch(
        isSecondOption: isDarkMode,
        firstOption: const Icon(Icons.light_mode, size: 24),
        secondOption: const Icon(Icons.dark_mode, size: 24),
        onTap: () {
          ref.read(settingsControllerProvider.notifier).toggleTheme();
        },
      ),
    );
  }
}
