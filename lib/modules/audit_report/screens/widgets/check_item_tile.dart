import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/security_check_model.dart';
import '../../../../shared/common_widgets/status_badge_widget.dart';

// displays a single security check result as a detailed card tile
class CheckItemTile extends StatelessWidget {
  final SecurityCheckModel check;

  const CheckItemTile({super.key, required this.check});

  // icon representing the check's severity
  IconData get _statusIcon {
    switch (check.status) {
      case CheckStatus.safe:
        return Icons.check_circle_outline_rounded;
      case CheckStatus.warning:
        return Icons.warning_amber_rounded;
      case CheckStatus.critical:
        return Icons.dangerous_rounded;
      case CheckStatus.info:
        return Icons.info_outline_rounded;
    }
  }

  // border highlight color based on severity
  Color get _statusColor {
    switch (check.status) {
      case CheckStatus.safe:
        return AppColors.safe;
      case CheckStatus.warning:
        return AppColors.warning;
      case CheckStatus.critical:
        return AppColors.critical;
      case CheckStatus.info:
        return AppColors.info;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        // subtle border: colored for issues, muted for safe checks
        border: Border.all(
          color: check.status != CheckStatus.safe
              ? _statusColor.withAlpha(77)
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // check name row with status icon and badge
          Row(
            children: [
              Icon(_statusIcon, color: _statusColor, size: AppSizes.iconMd),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: Text(check.name, style: AppTextStyles.headingSmall),
              ),
              StatusBadgeWidget(status: check.status),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          // description explaining what was checked
          Text(check.description, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppSizes.xs),
          // native result detail shown in a mono-style container
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.sm,
              vertical: AppSizes.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            ),
            child: Text(
              check.detail,
              style: AppTextStyles.bodySmall.copyWith(color: _statusColor),
            ),
          ),

          // fix recommendation section — only rendered when a fix is available (non-safe)
          if (check.fixRecommendation != null) ...[
            const SizedBox(height: AppSizes.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSizes.sm),
              decoration: BoxDecoration(
                // tinted background using the status color at low opacity
                color: _statusColor.withAlpha(15),
                borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                border: Border.all(color: _statusColor.withAlpha(50)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // wrench icon signals this is an actionable fix
                  Icon(
                    Icons.build_outlined,
                    color: _statusColor,
                    size: AppSizes.iconSm,
                  ),
                  const SizedBox(width: AppSizes.xs),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "how to fix" bold label
                        Text(
                          'How to Fix',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: _statusColor,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // step-by-step actionable recommendation
                        Text(
                          check.fixRecommendation!,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
