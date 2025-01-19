import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool isObscure;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? semanticLabel;
  final InputDecoration? decoration;

  const CustomTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.isObscure = false,
    this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.semanticLabel,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? label,
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        validator: validator,
        decoration: decoration ??
            InputDecoration(
              labelText: label,
              hintText: hintText,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            ),
      ),
    );
  }
}
