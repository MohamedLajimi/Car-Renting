import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomSelectionGrid<T> extends StatelessWidget {
  final String title;
  final List<T> items;
  final T selectedItem;
  final String Function(T) labelBuilder;
  final IconData? Function(T)? iconBuilder;
  final void Function(T) onSelected;
  final int crossAxisCount;

  const CustomSelectionGrid({
    super.key,
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    this.iconBuilder,
    required this.onSelected,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = item == selectedItem;
            final icon = iconBuilder?.call(item);

            return ChoiceChip(
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              label: Container(
                padding: const .all(8),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    if (icon != null) ...[
                      Icon(
                        icon,
                        size: 18,
                        color: isSelected
                            ? context.colorScheme.primary
                            : context.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(labelBuilder(item)),
                  ],
                ),
              ),
              selected: isSelected,
              onSelected: (_) => onSelected(item),
              selectedColor: context.colorScheme.primary.withValues(alpha: 0.3),
              showCheckmark: false,
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? context.colorScheme.primary
                    : context.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          },
        ),
      ],
    );
  }
}
