import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ContinueWithWidget extends StatelessWidget {
  const ContinueWithWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Divider(
            thickness: 1,
            color: colorScheme.onSurfaceVariant.withAlpha(100),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            context.tr('auth.login.continue_with'),
            style: context.textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: colorScheme.onSurfaceVariant.withAlpha(100),
          ),
        ),
      ],
    );
  }
}
