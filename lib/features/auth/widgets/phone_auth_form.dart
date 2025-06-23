import 'package:boilerplate_template/shared/constants/app_sizes.dart';
import 'package:boilerplate_template/shared/exceptions/auth_exceptions.dart';
import 'package:boilerplate_template/shared/extensions/exception_extensions.dart';
import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';
import 'package:boilerplate_template/features/auth/widgets/auth_form.dart';
import 'package:boilerplate_template/features/auth/providers/auth_providers.dart';

class PhoneAuthForm extends AuthForm {
  const PhoneAuthForm({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static final TextEditingController _phoneController = TextEditingController();
  static final TextEditingController _smsController = TextEditingController();
  static String _selectedCountryCode = '+33';

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  String get title => 'Phone Authentication';

  @override
  String get submitButtonText => 'Verify Phone';

  @override
  VoidCallback get onSubmit => () {
        if (_formKey.currentState!.validate()) {
          // Logic handled in buildFormFields
        }
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final authFormState = ref.watch(authFormControllerProvider);
    final validationService = ref.read(authValidationServiceProvider);
    final localization = AppLocalizations.of(context)!;

    final isLoading = authState is AuthLoading;
    final isCodeSent = authState is AuthCodeSent || authFormState.isCodeSent;

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingMedium),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Phone Authentication',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.marginLarge),
            if (!isCodeSent) ...[
              // Phone number input
              Row(
                children: [
                  CountryCodePicker(
                    onChanged: (country) {
                      _selectedCountryCode = country.dialCode;
                    },
                    initialSelection: 'FR',
                    favorite: const ['+33', 'FR'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                  const SizedBox(width: AppSizes.marginSmall),
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneController,
                      label: localization.phoneNumber,
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          validationService.validatePhoneNumber(value, context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.marginLarge),

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .verifyPhoneNumber(
                                    '$_selectedCountryCode${_phoneController.text}');
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
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(localization.sendVerificationCode),
              ),
            ] else ...[
              // SMS verification input
              CustomTextField(
                controller: _smsController,
                label: localization.smsCode,
                keyboardType: TextInputType.number,
                validator: (value) =>
                    validationService.validateSmsCode(value, context),
              ),
              const SizedBox(height: AppSizes.marginLarge),

              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .verifySmsCode(_smsController.text);
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
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(localization.verify),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> buildFormFields(BuildContext context, WidgetRef ref) {
    // Cette méthode n'est pas utilisée car on override build complètement
    return [];
  }
}
