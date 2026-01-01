import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, error }

class SnackBarUtils {
  static void show(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final icon = type == SnackBarType.error
        ? Icons.error_outline
        : Icons.check_circle_outline;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const .all(16),
        duration: const Duration(seconds: 4),
        persist: false,
        content: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: context.colorScheme.onSurfaceVariant,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}
