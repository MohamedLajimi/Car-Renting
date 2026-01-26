import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class PaginationFooter extends StatelessWidget {
  final String noMoreToLoadText;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const PaginationFooter({
    super.key,
    required this.noMoreToLoadText,
    required this.isLoadingMore,
    required this.hasReachedMax,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (hasReachedMax && !isLoadingMore) {
      return Center(
        child: Text(noMoreToLoadText, style: context.textTheme.bodySmall),
      );
    }
    return const SizedBox.shrink();
  }
}
