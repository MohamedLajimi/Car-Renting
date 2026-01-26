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
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.inputType = TextInputType.text,
    this.isObscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTapSuffixIcon,
    this.validator,
    this.onChanged,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscureText,
      keyboardType: inputType,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,

      style: context.textTheme.bodyMedium,

      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        onEditingComplete?.call();
      },

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "Field is required";
        }
        return validator?.call(value);
      },

      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: context.colorScheme.onSurfaceVariant,
                size: 18,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onTapSuffixIcon,
                icon: Icon(suffixIcon, color: context.colorScheme.primary),
              )
            : null,
      ),
    );
  }
}
