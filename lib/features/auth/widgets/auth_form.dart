import 'package:boilerplate_template/common/constants/app_sizes.dart';
import 'package:boilerplate_template/features/auth/widgets/base_auth_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';

abstract class AuthForm extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  AuthForm({super.key});

  GlobalKey<FormState> get formKey;
  String get title;
  bool get isLoading;
  String get submitButtonText;
  VoidCallback get onSubmit;
  List<Widget> buildFormFields();

  @override
  Widget build(BuildContext context) {
    return Obx(() => BaseAuthForm(
          formKey: formKey,
          title: title,
          isLoading: isLoading,
          submitButtonText: submitButtonText,
          onSubmit: onSubmit,
          children: [
            ...buildFormFields(),
            const SizedBox(height: AppSizes.marginSmall),
            if (authController.errorMessage.isNotEmpty)
              Text(
                authController.errorMessage.value,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: AppSizes.textSmall,
                ),
              ),
          ],
        ));
  }
}
