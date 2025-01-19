import 'package:boilerplate_template/common/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_form.dart';
import 'custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailAuthForm extends AuthForm {
  EmailAuthForm({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  String get title => authController.isLoginMode.value
      ? AppLocalizations.of(Get.context!)!.login
      : AppLocalizations.of(Get.context!)!.register;

  @override
  bool get isLoading => authController.isLoading.value;

  @override
  String get submitButtonText => authController.isLoginMode.value
      ? AppLocalizations.of(Get.context!)!.login
      : AppLocalizations.of(Get.context!)!.register;

  @override
  VoidCallback get onSubmit => _submit;

  @override
  List<Widget> buildFormFields() {
    final localization = AppLocalizations.of(Get.context!)!;

    return [
      CustomTextField(
        controller: _emailController,
        label: localization.email,
        hintText: localization.enterYourEmail,
        prefixIcon: Icons.email,
        validator: authController.validateEmail,
        semanticLabel: localization.emailField,
      ),
      const SizedBox(height: AppSizes.marginSmall),
      CustomTextField(
        controller: _passwordController,
        label: localization.password,
        hintText: localization.enterYourPassword,
        prefixIcon: Icons.lock,
        isObscure: true,
        validator: authController.validatePassword,
        semanticLabel: localization.passwordField,
      ),
      const SizedBox(height: AppSizes.marginSmall),
      TextButton(
        onPressed: _toggleMode,
        child: Text(authController.isLoginMode.value
            ? localization.noAccountRegister
            : localization.alreadyHaveAccountLogin),
      ),
    ];
  }

  void _submit() {
    if (formKey.currentState!.validate()) {
      authController.authenticateWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _toggleMode() {
    authController.toggleLoginMode();
    _passwordController.clear();
  }
}
