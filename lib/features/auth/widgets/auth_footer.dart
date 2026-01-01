import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';

class AuthFooter extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTextPressed;

  const AuthFooter({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTextPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            text: '$firstText ',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: secondText,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()..onTap = onTextPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
