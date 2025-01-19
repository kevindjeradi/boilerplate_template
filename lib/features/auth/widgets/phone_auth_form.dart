import 'package:boilerplate_template/common/constants/app_sizes.dart';
import 'package:country_code_picker_plus/country_code_picker_plus.dart'; // Correct import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth_form.dart';
import 'custom_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhoneAuthForm extends AuthForm {
  PhoneAuthForm({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  final RxString _selectedCountryCode = '+33'.obs;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  String get title => authController.isLoginMode.value
      ? AppLocalizations.of(Get.context!)!.login
      : AppLocalizations.of(Get.context!)!.register;

  @override
  bool get isLoading => authController.isLoading.value;

  @override
  String get submitButtonText => authController.isCodeSent.value
      ? AppLocalizations.of(Get.context!)!.submitCode
      : AppLocalizations.of(Get.context!)!.verifyPhoneNumber;

  @override
  VoidCallback get onSubmit =>
      authController.isCodeSent.value ? _submitCode : _verifyPhone;

  @override
  List<Widget> buildFormFields() {
    final localization = AppLocalizations.of(Get.context!)!;

    return [
      CustomTextField(
        controller: _phoneController,
        label: localization.phoneNumber,
        hintText: localization.enterYourPhoneNumber,
        keyboardType: TextInputType.number,
        validator: authController.validatePhoneNumber,
        semanticLabel: localization.phoneNumber,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: CountryCodePicker(
              onChanged: (Country country) {
                _selectedCountryCode.value = country.dialCode;
                _printCountryCode(country);
              },
              onInit: (Country? country) {
                if (country != null) {
                  _selectedCountryCode.value = country.dialCode;
                  _printCountryCode(country);
                }
              },
              initialSelection: 'FR',
              favorite: const ['+33', 'FR'],
              showFlag: true,
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
              alignLeft: false,
              mode: CountryCodePickerMode.bottomSheet,
              searchDecoration: InputDecoration(
                hintText: localization.country,
              ),
              flagWidth: 24.0,
              textStyle: const TextStyle(
                fontSize: AppSizes.textMedium,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingSmall,
              ),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
          isDense: true,
        ),
      ),
      const SizedBox(height: AppSizes.marginSmall),
      Obx(() {
        if (authController.isCodeSent.value) {
          return CustomTextField(
            controller: _smsCodeController,
            label: localization.smsCode,
            hintText: localization.enterSmsCode,
            prefixIcon: Icons.message,
            keyboardType: TextInputType.number,
            validator: authController.validateSmsCode,
            semanticLabel: localization.smsCodeField,
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    ];
  }

  void _verifyPhone() {
    if (formKey.currentState!.validate()) {
      final fullPhoneNumber =
          '${_selectedCountryCode.value}${_phoneController.text.trim()}';
      authController.verifyPhoneNumber(fullPhoneNumber);
    }
  }

  void _submitCode() {
    if (formKey.currentState!.validate()) {
      authController.verifySmsCode(_smsCodeController.text.trim());
    }
  }

  void _printCountryCode(Country country) {
    debugPrint('Country Name: ${country.name}');
    debugPrint('Country Code: ${country.code}');
    debugPrint('Dial Code: ${country.dialCode}');
  }
}
