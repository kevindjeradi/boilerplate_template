import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/settings/controllers/settings_controller.dart';
import 'package:boilerplate_template/shared/widgets/custom_toggle_switch.dart';
import 'package:boilerplate_template/shared/constants/assets.dart';

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

    final isFrench = currentLocale.languageCode == 'fr';

    return ListTile(
      leading: Image.asset(
        isFrench ? Assets.frFlag : Assets.gbFlag,
        width: 26,
        height: 20,
        fit: BoxFit.cover,
      ),
      title: Text(isFrench ? localization.french : localization.english),
      trailing: CustomToggleSwitch(
        isSecondOption: !isFrench,
        firstOption: Image.asset(
          Assets.frFlag,
          width: 22,
          height: 16,
          fit: BoxFit.cover,
        ),
        secondOption: Image.asset(
          Assets.gbFlag,
          width: 22,
          height: 16,
          fit: BoxFit.cover,
        ),
        onTap: () {
          final newLocale = isFrench ? 'en' : 'fr';
          ref.read(settingsControllerProvider.notifier).switchLocale(newLocale);
        },
      ),
    );
  }
}
