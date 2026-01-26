import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final bool? isEnabled;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isEnabled == true && !isLoading) ? onPressed : null,
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(double.infinity, 55),
        backgroundColor: isEnabled ?? true
            ? backgroundColor
            : context.colorScheme.surfaceContainer,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
    );
  }
}
