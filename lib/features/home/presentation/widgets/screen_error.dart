import 'package:getincoffee/core/resources/font_manager.dart';
import 'package:getincoffee/core/theme/light_theme.dart';
import 'package:flutter/material.dart';

class ScreenError extends StatelessWidget {
  const ScreenError({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: LightThemeColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeights.bold,
                color: LightThemeColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection or try again later.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeights.regular,
                color: LightThemeColors.black.withValues(alpha: .7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightThemeColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
