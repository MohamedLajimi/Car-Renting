import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const OnboardingWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;

    final words = title.split(' ');
    final firstHalf = words.take(2).join(' ');
    final secondHalf = words.skip(2).join(' ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 1.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 40),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: textTheme.headlineMedium,
              children: [
                TextSpan(
                  text: firstHalf,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                TextSpan(
                  text: ' $secondHalf',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
