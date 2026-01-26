import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_chip.dart';
import 'package:car_renting/core/widgets/custom_network_image.dart';
import 'package:car_renting/features/car-management/models/car_model.dart';
import 'package:flutter/material.dart';

class RenterCarCard extends StatelessWidget {
  final CarModel car;
  final VoidCallback? onTap;

  const RenterCarCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CustomNetworkImage(
                    imageUrl: car.images.isNotEmpty ? car.images.first : null,
                    height: 180,
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: CustomChip.flat(
                    label: car.status.displayName,
                    icon: car.status.icon,
                    background: car.status.color,
                    foreground: context.colorScheme.onSurface,
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 12,
                  child: CustomChip.flat(
                    label: car.rate.toString(),
                    background: context.colorScheme.surfaceContainerLowest,
                    foreground: context.colorScheme.onSurface,
                    icon: Icons.star_outline,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${car.brand} ${car.model} (${car.year})",
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${car.pricePerDay} ${car.currency.symbol}',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    spacing: 4,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: context.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                      Text(
                        car.location.city,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 4,
                    runSpacing: 8,
                    children: car.features
                        .sublist(
                          0,
                          car.features.length > 6 ? 6 : car.features.length,
                        )
                        .map(
                          (feat) => CustomChip.soft(
                            label: feat.displayName,
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
