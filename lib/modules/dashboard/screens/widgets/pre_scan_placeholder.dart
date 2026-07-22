import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

// placeholder content shown before the first scan is performed
class PreScanPlaceholder extends StatelessWidget {
  const PreScanPlaceholder({super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // pulsing radar icon as the pre-scan visual
        Icon(
          Icons.radar_rounded,
          size: 80,
          color: AppColors.accent.withAlpha(80),
        ),
        const SizedBox(height: AppSizes.md),
        Text(
          AppStrings.preScanHint,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
