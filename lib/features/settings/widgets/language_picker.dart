import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:boilerplate_template/features/settings/states/settings_state.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);

    // Pattern matching moderne pour obtenir la locale
    final currentLocale = settings.when(
      data: (state) => state.currentLocale,
      loading: () => const Locale('fr'), // défaut pendant le chargement
      error: (_, __) => const Locale('fr'), // défaut en cas d'erreur
    );

    return ListTile(
      title: Text(localization.language),
      subtitle: Text(_getLanguageName(currentLocale)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showLanguageDialog(context, ref, currentLocale),
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'Français';
    }
  }

  void _showLanguageDialog(
      BuildContext context, WidgetRef ref, Locale currentLocale) {
    final localization = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: SettingsState.supportedLocales.map((locale) {
              return RadioListTile<String>(
                title: Text(_getLanguageName(locale)),
                value: locale.languageCode,
                groupValue: currentLocale.languageCode,
                onChanged: (String? value) {
                  if (value != null) {
                    ref
                        .read(settingsControllerProvider.notifier)
                        .switchLocale(value);
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
