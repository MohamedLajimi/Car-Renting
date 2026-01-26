import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:car_renting/core/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageWrapper extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double borderRadius;
  final bool isCover;
  final VoidCallback? onDelete;
  final Widget? overlay;

  const CustomImageWrapper({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 12,
    this.isCover = false,
    this.onDelete,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomNetworkImage(
          imageUrl: url,
          width: width,
          height: height ?? 120,
          borderRadius: borderRadius,
        ),

        if (isCover)
          Positioned(
            top: 8,
            left: 8,
            child: _Badge(text: "COVER", color: context.colorScheme.primary),
          ),

        // Optional Delete Button
        if (onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),

        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
