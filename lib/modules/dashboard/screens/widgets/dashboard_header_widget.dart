import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

// dashboard app bar section with app logo icon, name, and tagline
class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key});

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        // shield icon as logo
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(30),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.accent.withAlpha(80)),
          ),
          child: const Icon(
            Icons.security_rounded,
            color: AppColors.accent,
            size: AppSizes.iconXl,
          ),
        ),
        const SizedBox(width: AppSizes.md),
        // app name and tagline stacked vertically
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.appName, style: AppTextStyles.headingLarge),
            Text(AppStrings.appTagline, style: AppTextStyles.bodySmall),
          ],
        ),
      ],
    );
  }
}
