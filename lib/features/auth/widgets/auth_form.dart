import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:flutter/material.dart';

class BaseAuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String title;
  final bool isLoading;
  final String submitButtonText;
  final VoidCallback onSubmit;
  final List<Widget> children;

  const BaseAuthForm({
    super.key,
    required this.formKey,
    required this.title,
    required this.isLoading,
    required this.submitButtonText,
    required this.onSubmit,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.marginLarge),
          ...children,
          SizedBox(height: context.marginSmall),
          ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            child: isLoading
                ? const CircularProgressIndicator()
                : Text(submitButtonText),
          ),
        ],
      ),
    );
  }
}
