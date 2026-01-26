import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_indicator.dart';
import 'package:flutter/material.dart';

class CarFormHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int sectionIndex;
  const CarFormHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.sectionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: context.colorScheme.primary, size: 24),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: context.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomIndicator(itemCount: 3, currentIndex: sectionIndex),
        const SizedBox(height: 16),
      ],
    );
  }
}
