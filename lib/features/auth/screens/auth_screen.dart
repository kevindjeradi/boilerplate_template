import 'package:boilerplate_template/common/constants/app_sizes.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/widgets/email_auth_form.dart';
import 'package:boilerplate_template/features/auth/widgets/phone_auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});

  final AuthController _authController = Get.find<AuthController>();

  final List<Widget> _forms = [
    EmailAuthForm(),
    PhoneAuthForm(),
  ];

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(localization.authenticate),
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSizes.marginMedium),
          Obx(() {
            return CupertinoSegmentedControl<int>(
              children: localizedSegments,
              groupValue: _authController.selectedAuthMethod.value,
              onValueChanged: (int index) {
                _authController.setSelectedAuthMethod(index);
              },
              padding: const EdgeInsets.all(AppSizes.paddingSmall),
            );
          }),
          Expanded(
            child: Obx(() {
              return _forms[_authController.selectedAuthMethod.value];
            }),
          ),
          const SizedBox(height: AppSizes.marginMedium),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
            child: Obx(() {
              return _authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : OutlinedButton.icon(
                      onPressed: _authController.signInWithGoogle,
                      icon: Image.asset(
                        'assets/images/google_logo.png',
                        height: AppSizes.iconSizeSmall,
                        width: AppSizes.iconSizeSmall,
                      ),
                      label: Text(localization.signInWithGoogle),
                    );
            }),
          ),
          const SizedBox(height: AppSizes.marginMedium),
        ],
      ),
    );
  }
}
