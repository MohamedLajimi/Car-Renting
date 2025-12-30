import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$hintText is required";
        }
        return validator?.call(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: context.colorScheme.onSurface) : null,
      ),
    );
  }
}