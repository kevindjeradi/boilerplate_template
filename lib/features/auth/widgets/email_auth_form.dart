import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:boilerplate_template/features/auth/widgets/custom_text_field.dart';
import 'package:boilerplate_template/features/auth/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';

class EmailAuthForm extends ConsumerStatefulWidget {
  const EmailAuthForm({super.key});

  @override
  ConsumerState<EmailAuthForm> createState() => _EmailAuthFormState();
}

class _EmailAuthFormState extends ConsumerState<EmailAuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authFormState = ref.watch(authFormControllerProvider);
    final validationService = ref.read(authValidationServiceProvider);
    final localization = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_errorMessage != null) ...[
            Text(
              _errorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.marginMedium),
          ],
          CustomTextField(
            controller: _emailController,
            label: localization.email,
            hintText: localization.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                validationService.validateEmail(value, context),
          ),
          SizedBox(height: context.marginMedium),
          CustomTextField(
            controller: _passwordController,
            label: localization.password,
            hintText: localization.enterYourPassword,
            isObscure: true,
            validator: (value) => validationService.validatePassword(
                value, context, authFormState.isLoginMode),
          ),
          SizedBox(height: context.marginMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(authFormState.isLoginMode
                  ? localization.noAccountRegister
                  : localization.alreadyHaveAccountLogin),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        setState(() => _errorMessage = null);
                        ref
                            .read(authFormControllerProvider.notifier)
                            .toggleLoginMode();
                      },
                child: Text(authFormState.isLoginMode
                    ? localization.register
                    : localization.login),
              ),
            ],
          ),
          SizedBox(height: context.marginMedium),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });

                      final error = await ref
                          .read(authControllerProvider.notifier)
                          .authenticateWithEmail(
                            _emailController.text,
                            _passwordController.text,
                            authFormState.isLoginMode,
                          );

                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                          if (error != null) {
                            _errorMessage = error.message;
                          }
                        });
                      }
                    }
                  },
            child: _isLoading
                ? const CircularProgressIndicator()
                : Text(authFormState.isLoginMode
                    ? localization.login
                    : localization.register),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
