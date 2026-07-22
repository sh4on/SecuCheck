import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/security_check_model.dart';
import '../../../../data/models/security_report_model.dart';
import '../../../../shared/common_widgets/status_badge_widget.dart';

// card showing a security category's icon, name, issue count, and overall status badge
class CategorySummaryCard extends StatelessWidget {
  final SecurityCategoryModel category;

  const CategorySummaryCard({super.key, required this.category});

  // icon mapped to each category id
  IconData get _icon {
    switch (category.id) {
      case 'cat_os_privileges':
        return Icons.shield_outlined;
      case 'cat_dev_controls':
        return Icons.developer_mode_outlined;
      case 'cat_app_runtime':
        return Icons.apps_outlined;
      case 'cat_network_privacy':
        return Icons.wifi_lock_rounded;
      case 'cat_emulators_virtual':
        return Icons.devices_other_rounded;
      case 'cat_physical_hardware':
        return Icons.phonelink_lock_rounded;
      default:
        return Icons.security_outlined;
    }
  }

  @override
  Widget build(final BuildContext context) {
    // count non-safe checks to show an issue count badge
    final issueCount =
        category.checks.where((c) => c.status != CheckStatus.safe).length;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // category icon in a rounded container
          Container(
            padding: const EdgeInsets.all(AppSizes.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            ),
            child: Icon(
              _icon,
              color: AppColors.accent,
              size: AppSizes.iconLg,
            ),
          ),
          const SizedBox(width: AppSizes.md),
          // category name and issue count
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.title, style: AppTextStyles.headingSmall),
                const SizedBox(height: 2),
                Text(
                  issueCount == 0
                      ? 'All checks passed'
                      : '$issueCount issue${issueCount > 1 ? "s" : ""} found',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          // overall category status badge
          StatusBadgeWidget(status: category.overallStatus),
        ],
      ),
    );
  }
}
