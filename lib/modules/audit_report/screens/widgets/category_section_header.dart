import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/security_report_model.dart';
import '../../../../shared/common_widgets/status_badge_widget.dart';

// collapsible section header for each security category in the audit report
class CategorySectionHeader extends StatelessWidget {
  final SecurityCategoryModel category;

  // whether the section body is currently visible
  final bool isExpanded;

  // called when the user taps to toggle the section
  final VoidCallback onTap;

  const CategorySectionHeader({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            // category title
            Expanded(
              child: Text(
                category.title,
                style: AppTextStyles.headingMedium,
              ),
            ),
            // overall category status badge
            StatusBadgeWidget(status: category.overallStatus),
            const SizedBox(width: AppSizes.sm),
            // animated chevron rotates 180° when expanded
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeInOut,
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary,
                size: AppSizes.iconLg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
