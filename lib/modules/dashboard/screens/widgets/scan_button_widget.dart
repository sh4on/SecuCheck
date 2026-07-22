import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

// animated gradient scan button with loading indicator state
class ScanButtonWidget extends StatelessWidget {
  // triggered when the button is tapped (disabled while isScanning)
  final VoidCallback onTap;

  // when true, shows a spinner instead of the scan icon
  final bool isScanning;

  const ScanButtonWidget({
    super.key,
    required this.onTap,
    required this.isScanning,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: isScanning ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        decoration: BoxDecoration(
          // gradient when idle; flat surface color while scanning
          gradient: isScanning
              ? null
              : const LinearGradient(
                  colors: [AppColors.scoreGradientStart, AppColors.scoreGradientEnd],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: isScanning ? AppColors.surfaceVariant : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // spinner while scanning; radar icon while idle
            if (isScanning)
              const SizedBox(
                width: AppSizes.iconMd,
                height: AppSizes.iconMd,
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              )
            else
              const Icon(
                Icons.radar_rounded,
                color: AppColors.background,
                size: AppSizes.iconLg,
              ),
            const SizedBox(width: AppSizes.sm),
            // label text changes with state
            Text(
              isScanning ? AppStrings.scanningLabel : AppStrings.scanButtonLabel,
              style: AppTextStyles.headingSmall.copyWith(
                color: isScanning ? AppColors.textSecondary : AppColors.background,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
