import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // The fixedSize ensures the button feels substantial on mobile
        fixedSize: const Size(double.infinity, 55),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: .new(0xffffffff),
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
    );
  }
}
