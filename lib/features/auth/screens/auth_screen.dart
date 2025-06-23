import 'package:boilerplate_template/shared/constants/app_sizes.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/widgets/email_auth_form.dart';
import 'package:boilerplate_template/features/auth/widgets/phone_auth_form.dart';
import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';
import 'package:boilerplate_template/shared/extensions/exception_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:boilerplate_template/core/router/app_router.dart';

class AuthScreen extends ConsumerWidget {
  AuthScreen({super.key});

  final List<Widget> _forms = [
    EmailAuthForm(),
    const PhoneAuthForm(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context)!;
    final authState = ref.watch(authControllerProvider);
    final authFormState = ref.watch(authFormControllerProvider);

    // Listen to auth state changes for navigation - Navigation simple
    ref.listen(authControllerProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        AppNavigation.goToHome(context);
      }
    });

    final Map<int, Widget> localizedSegments = {
      0: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
        child: Text(localization.email),
      ),
      1: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingSmall),
        child: Text(localization.phone),
      ),
    };

    final isLoading = authState is AuthLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.authenticate),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSizes.marginMedium),
          CupertinoSegmentedControl<int>(
            children: localizedSegments,
            groupValue: authFormState.selectedAuthMethod,
            onValueChanged: (int index) {
              ref
                  .read(authFormControllerProvider.notifier)
                  .setSelectedAuthMethod(index);
            },
            padding: const EdgeInsets.all(AppSizes.paddingSmall),
          ),
          Expanded(
            child: _forms[authFormState.selectedAuthMethod],
          ),
          const SizedBox(height: AppSizes.marginMedium),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            child: isLoading
                ? const CircularProgressIndicator()
                : OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle();
                      } on AuthException catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toLocalizedMessage(context)),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    icon: Image.asset(
                      'assets/images/google_logo.png',
                      height: AppSizes.iconSizeSmall,
                      width: AppSizes.iconSizeSmall,
                    ),
                    label: Text(localization.signInWithGoogle),
                  ),
          ),
          const SizedBox(height: AppSizes.marginMedium),
        ],
      ),
    );
  }
}
