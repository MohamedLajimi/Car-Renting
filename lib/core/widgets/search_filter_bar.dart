import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final String searchHint;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onFilterTap;
  final bool hasFilters;

  const SearchFilterBar({
    super.key,
    required this.searchHint,
    required this.controller,
    required this.onSearch,
    required this.onFilterTap,
    required this.hasFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: CustomTextFormField(
              hintText: searchHint,
              controller: controller,
              prefixIcon: CupertinoIcons.search,
              onChanged: onSearch,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: onFilterTap,
              icon: Badge(
                backgroundColor: hasFilters
                    ? context.colorScheme.error
                    : Colors.transparent,
                child: Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
