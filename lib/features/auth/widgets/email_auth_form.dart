import 'package:boilerplate_template/shared/constants/app_sizes.dart';
import 'package:boilerplate_template/features/auth/widgets/auth_form.dart';
import 'package:boilerplate_template/features/auth/widgets/custom_text_field.dart';
import 'package:boilerplate_template/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';

class EmailAuthForm extends AuthForm {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailAuthForm({super.key});

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  String get title => 'Email Authentication';

  @override
  String get submitButtonText => 'Sign In';

  @override
  VoidCallback get onSubmit => () {
        // Cette méthode sera appelée par le parent
      };

  @override
  List<Widget> buildFormFields(BuildContext context, WidgetRef ref) {
    final authFormState = ref.watch(authFormControllerProvider);
    final validationService = ref.read(authValidationServiceProvider);
    final localization = AppLocalizations.of(context)!;

    return [
      CustomTextField(
        controller: _emailController,
        label: localization.email,
        hintText: localization.enterYourEmail,
        keyboardType: TextInputType.emailAddress,
        validator: (value) => validationService.validateEmail(value, context),
      ),
      const SizedBox(height: AppSizes.marginMedium),
      CustomTextField(
        controller: _passwordController,
        label: localization.password,
        hintText: localization.enterYourPassword,
        isObscure: true,
        validator: (value) => validationService.validatePassword(
            value, context, authFormState.isLoginMode),
      ),
      const SizedBox(height: AppSizes.marginMedium),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(authFormState.isLoginMode
              ? localization.noAccountRegister
              : localization.alreadyHaveAccountLogin),
          TextButton(
            onPressed: () {
              ref.read(authFormControllerProvider.notifier).toggleLoginMode();
            },
            child: Text(authFormState.isLoginMode
                ? localization.register
                : localization.login),
          ),
        ],
      ),
    ];
  }

  void handleSubmit(BuildContext context, WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final authFormState = ref.read(authFormControllerProvider);
      ref.read(authControllerProvider.notifier).authenticateWithEmail(
            _emailController.text,
            _passwordController.text,
            authFormState.isLoginMode,
          );
    }
  }
}
