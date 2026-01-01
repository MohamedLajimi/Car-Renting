import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class RemoveIconButton extends StatelessWidget {
  final VoidCallback onRemove;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const RemoveIconButton({
    super.key,
    required this.onRemove,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: .circular(8)),
        backgroundColor:
            backgroundColor ?? context.colorScheme.surfaceContainerHighest,
        foregroundColor:
            foregroundColor ?? context.colorScheme.onSurfaceVariant,
      ),
      onPressed: onRemove,
      icon: Icon(Icons.close, size: 20),
    );
  }
}
