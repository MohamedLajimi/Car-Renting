import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final IconData? icon;
  final bool showDot;
  final VoidCallback? onRemove;

  const CustomChip._({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    this.icon,
    this.showDot = false,
    this.onRemove,
  });

  factory CustomChip.soft({
    Key? key,
    required String label,
    required Color color,
    double alpha = 0.1,
    IconData? icon,
    bool showDot = false,
    VoidCallback? onRemove,
  }) {
    return CustomChip._(
      key: key,
      label: label,
      backgroundColor: color.withValues(alpha: alpha),
      foregroundColor: color,
      borderColor: color.withValues(alpha: 0.2),
      icon: icon,
      showDot: showDot,
      onRemove: onRemove,
    );
  }

  factory CustomChip.flat({
    Key? key,
    required String label,
    required Color background,
    required Color foreground,
    Color? border,
    IconData? icon,
    bool showDot = false,
    VoidCallback? onRemove,
  }) {
    return CustomChip._(
      key: key,
      label: label,
      backgroundColor: background,
      foregroundColor: foreground,
      borderColor: border ?? Colors.transparent,
      icon: icon,
      showDot: showDot,
      onRemove: onRemove,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: foregroundColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 14, color: foregroundColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          if (onRemove != null) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              child: Icon(Icons.close, size: 16, color: foregroundColor),
            ),
          ],
        ],
      ),
    );
  }
}
