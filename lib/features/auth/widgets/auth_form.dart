import 'package:boilerplate_template/shared/constants/app_sizes.dart';
import 'package:boilerplate_template/features/auth/widgets/base_auth_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:boilerplate_template/features/auth/controllers/auth_controller.dart';
import 'package:boilerplate_template/features/auth/states/auth_state.dart';

abstract class AuthForm extends ConsumerWidget {
  const AuthForm({super.key});

  GlobalKey<FormState> get formKey;
  String get title;
  String get submitButtonText;
  VoidCallback get onSubmit;
  List<Widget> buildFormFields(BuildContext context, WidgetRef ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    final isLoading = authState is AuthLoading;

    // Pour les erreurs, on peut les gérer via SnackBar ou d'autres moyens
    // Ici on garde juste un message vide car les erreurs sont gérées via exceptions

    return BaseAuthForm(
      formKey: formKey,
      title: title,
      isLoading: isLoading,
      submitButtonText: submitButtonText,
      onSubmit: onSubmit,
      children: [
        ...buildFormFields(context, ref),
        const SizedBox(height: AppSizes.marginSmall),
      ],
    );
  }
}
