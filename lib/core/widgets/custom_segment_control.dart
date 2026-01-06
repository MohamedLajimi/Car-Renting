import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSegmentedControl extends StatelessWidget {
  final int selectedIndex;
  final String labelOne;
  final String labelTwo;
  final ValueChanged<int> onChanged;

  const CustomSegmentedControl({
    super.key,
    required this.selectedIndex,
    required this.labelOne,
    required this.labelTwo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CupertinoSlidingSegmentedControl<int>(
        groupValue: selectedIndex,
        backgroundColor: colorScheme.surfaceContainerHighest,
        thumbColor: colorScheme.primary,
        children: {
          0: _buildSegment(
            labelOne,
            selectedIndex == 0,
            textTheme,
            colorScheme,
          ),
          1: _buildSegment(
            labelTwo,
            selectedIndex == 1,
            textTheme,
            colorScheme,
          ),
        },
        onValueChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
      ),
    );
  }

  Widget _buildSegment(
    String text,
    bool isSelected,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        text,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
