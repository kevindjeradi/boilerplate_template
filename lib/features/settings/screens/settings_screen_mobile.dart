import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:boilerplate_template/features/settings/widgets/language_picker.dart';
import 'package:boilerplate_template/features/settings/widgets/theme_switch.dart';
import 'package:boilerplate_template/core/router/app_router.dart';
import 'package:boilerplate_template/shared/widgets/sign_out_button.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';

class SettingsScreenMobile extends ConsumerWidget {
  const SettingsScreenMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final isAuthenticated = authState is AuthAuthenticated;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppNavigation.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Auth section en premier
          if (!isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(localization.accessAllFeatures),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                AppNavigation.goToAuth(context);
              },
            ),
            const Divider(),
          ],

          // Settings généraux
          const ThemeSwitch(),
          const Divider(),
          const LanguagePicker(),

          // Sign out si connecté
          if (isAuthenticated) ...[
            const Divider(),
            const SignOutButton(),
          ],
        ],
      ),
    );
  }
}
