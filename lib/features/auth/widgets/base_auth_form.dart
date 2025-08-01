import 'package:boilerplate_template/shared/constants/responsive_sizes.dart';
import 'package:flutter/material.dart';

class BaseAuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final String title;
  final VoidCallback onSubmit;
  final bool isLoading;
  final String submitButtonText;

  const BaseAuthForm({
    required this.formKey,
    required this.children,
    required this.title,
    required this.onSubmit,
    required this.isLoading,
    required this.submitButtonText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.paddingMedium),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              SizedBox(height: context.marginMedium),
              ...children,
              SizedBox(height: context.marginMedium),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: onSubmit,
                      child: Text(submitButtonText),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
