import 'package:car_renting/core/extensions/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  final double? height;
  final double? borderRadius;

  const CustomLinearProgressIndicator({
    super.key,
    this.height = 4,
    this.borderRadius,
  });

  @override
  State<CustomLinearProgressIndicator> createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState
    extends State<CustomLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 4),
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colorScheme.primary.withAlpha(80),
                    colorScheme.primary.withAlpha(200),
                    colorScheme.primary,
                    colorScheme.primary.withAlpha(200),
                    colorScheme.primary.withAlpha(80),
                  ],
                  stops: [
                    0.0,
                    _controller.value * 0.3,
                    _controller.value * 0.5,
                    _controller.value * 0.7,
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
