import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';

// full-screen error state with an icon, message, and retry button
class ErrorStateWidget extends StatelessWidget {
  // callback to retry the failed operation
  final VoidCallback onRetry;

  // optional custom message; falls back to the default error string
  final String? message;

  const ErrorStateWidget({
    super.key,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(final BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // error icon
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.critical,
              size: 56,
            ),
            const SizedBox(height: AppSizes.md),
            // error message
            Text(
              message ?? AppStrings.errorMessage,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.lg),
            // retry button
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg,
                  vertical: AppSizes.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(AppStrings.retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
