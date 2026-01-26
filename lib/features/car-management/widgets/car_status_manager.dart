import 'package:car_renting/core/enums/car_status_enum.dart';
import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CarStatusManager extends StatelessWidget {
  final CarStatus status;
  final String? rejectionReason;
  final VoidCallback onToggleVisibility;

  const CarStatusManager({
    super.key,
    required this.status,
    this.rejectionReason,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    if (status == CarStatus.verified || status == CarStatus.hidden) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.theme.dividerColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(
                      'car_management.status_manager.visibility_title',
                    ),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    status == CarStatus.verified
                        ? context.tr(
                            'car_management.status_manager.public_hint',
                          )
                        : context.tr(
                            'car_management.status_manager.hidden_hint',
                          ),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: status == CarStatus.verified,
              onChanged: (_) => onToggleVisibility(),
              activeTrackColor: context.colorScheme.primary,
              thumbColor: WidgetStatePropertyAll(context.colorScheme.onSurface),
              inactiveTrackColor: context.colorScheme.surfaceContainer,
              trackOutlineColor: WidgetStatePropertyAll(
                context.theme.dividerColor,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(status.icon, color: status.color, size: 20),
              const SizedBox(width: 8),
              Text(
                status.displayName,
                style: context.textTheme.titleSmall?.copyWith(
                  color: status.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (status == CarStatus.rejected && rejectionReason != null) ...[
            const SizedBox(height: 8),
            Text(
              "${context.tr('car_management.status_manager.reason')}: $rejectionReason",
              style: context.textTheme.bodySmall?.copyWith(color: status.color),
            ),
          ],
          if (status == CarStatus.pending) ...[
            const SizedBox(height: 8),
            Text(
              context.tr('car_management.status_manager.pending_desc'),
              style: context.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
