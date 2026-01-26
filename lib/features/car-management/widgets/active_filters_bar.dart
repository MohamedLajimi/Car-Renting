import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_chip.dart';
import 'package:car_renting/features/car-management/models/car_filter_params.dart';
import 'package:flutter/material.dart';

class ActiveFiltersBar extends StatelessWidget {
  final CarFilterParams filters;
  final Function(String filterKey) onRemoveFilter;
  final VoidCallback onClearAll;

  const ActiveFiltersBar({
    super.key,
    required this.filters,
    required this.onRemoveFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (!filters.hasFilters) {
      return const SizedBox.shrink();
    }

    final activeFilters = filters.getActiveFilters();

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: activeFilters.length,
      itemBuilder: (context, index) {
        final filter = activeFilters[index];
        return CustomChip.flat(
          label: filter.value,
          foreground: context.colorScheme.onSurface,
          background: context.colorScheme.primary,
          onRemove: () => onRemoveFilter(filter.key),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 8),
    );
  }
}
