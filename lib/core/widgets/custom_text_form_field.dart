import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType? inputType;
  final bool isObscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onTapSuffixIcon;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.inputType=TextInputType.text,
    this.isObscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$hintText is required";
        }
        return validator?.call(value);
      },
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: context.colorScheme.onSurface)
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(onPressed: onTapSuffixIcon, icon: Icon(suffixIcon))
            : null,
      ),
    );
  }
}
