import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:boilerplate_template/shared/extensions/exception_extensions.dart';
import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/providers/auth_providers.dart';

class PhoneAuthForm extends ConsumerStatefulWidget {
  const PhoneAuthForm({super.key});

  @override
  ConsumerState<PhoneAuthForm> createState() => _PhoneAuthFormState();
}

class _PhoneAuthFormState extends ConsumerState<PhoneAuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _selectedCountryCode = '+33';
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final authFormState = ref.watch(authFormControllerProvider);
    final validationService = ref.read(authValidationServiceProvider);
    final localization = AppLocalizations.of(context)!;
    final isCodeSent = authFormState.isCodeSent;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localization.phoneAuthTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.marginLarge * 1.5),
              if (_errorMessage != null) ...[
                Text(
                  _errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.marginLarge),
              ],
              if (!isCodeSent) ...[
                // Phone number input
                Row(
                  children: [
                    CountryCodePicker(
                      onChanged: (country) {
                        setState(() {
                          _selectedCountryCode = country.dialCode;
                          _errorMessage = null;
                        });
                      },
                      initialSelection: 'FR',
                      favorite: const ['+33', 'FR'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    SizedBox(width: context.marginSmall),
                    Expanded(
                      child: CustomTextField(
                        controller: _phoneController,
                        label: localization.phoneNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) => validationService
                            .validatePhoneNumber(value, context),
                        onChanged: (_) => setState(() => _errorMessage = null),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // SMS verification input
                CustomTextField(
                  controller: _smsController,
                  label: localization.smsCode,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      validationService.validateSmsCode(value, context),
                  onChanged: (_) => setState(() => _errorMessage = null),
                ),
              ],
            ],
          ),
          SizedBox(height: context.marginLarge * 2),
          FilledButton(
            onPressed: _isLoading
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });

                      final error = !isCodeSent
                          ? await ref
                              .read(authControllerProvider.notifier)
                              .verifyPhoneNumber(
                                  '$_selectedCountryCode${_phoneController.text}')
                          : await ref
                              .read(authControllerProvider.notifier)
                              .verifySmsCode(_smsController.text);

                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                          if (error != null) {
                            _errorMessage = error.toLocalizedMessage(context);
                          }
                        });
                      }
                    }
                  },
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                vertical: context.paddingMedium,
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : Text(!isCodeSent
                    ? localization.sendVerificationCode
                    : localization.verify),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _smsController.dispose();
    super.dispose();
  }
}
