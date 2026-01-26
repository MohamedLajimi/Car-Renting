import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomMultiChipSelector<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final List<T> selectedItems;
  final String Function(T) labelBuilder;
  final IconData? Function(T)? iconBuilder;
  final void Function(T) onToggle;

  const CustomMultiChipSelector({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItems,
    required this.labelBuilder,
    required this.onToggle,
    this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            final icon = iconBuilder?.call(item);

            return FilterChip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              label: Row(
                mainAxisAlignment: .center,
                mainAxisSize: .min,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 18,
                      color: isSelected
                          ? context.colorScheme.onSurface
                          : context.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(labelBuilder(item)),
                ],
              ),
              selected: isSelected,
              onSelected: (_) => onToggle(item),
              selectedColor: context.colorScheme.primary,
              showCheckmark: false,
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                color: isSelected ? context.colorScheme.onSurface : null,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
