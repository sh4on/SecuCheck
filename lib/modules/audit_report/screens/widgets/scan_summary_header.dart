import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../data/models/security_report_model.dart';

// summary header card displayed at the top of the audit report screen,
// showing the numeric score, issues found count, and safe checks count
class ScanSummaryHeader extends StatelessWidget {
  final SecurityReportModel report;

  const ScanSummaryHeader({super.key, required this.report});

  // pick score color by threshold
  Color get _scoreColor {
    if (report.score >= 80) return AppColors.safe;
    if (report.score >= 50) return AppColors.warning;
    return AppColors.critical;
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          // large numeric score
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${report.score}',
                style: AppTextStyles.displayLarge.copyWith(color: _scoreColor),
              ),
              Text(
                AppStrings.securityScoreLabel,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
          const SizedBox(width: AppSizes.lg),
          // vertical divider between score and stats
          Container(width: 1, height: 56, color: AppColors.divider),
          const SizedBox(width: AppSizes.lg),
          // safe and issue counts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryStatRow(
                icon: Icons.check_circle_outline_rounded,
                color: AppColors.safe,
                label: '${report.safeCount} ${AppStrings.checksPassedLabel}',
              ),
              const SizedBox(height: AppSizes.xs),
              _SummaryStatRow(
                icon: Icons.warning_amber_rounded,
                color: AppColors.critical,
                label: '${report.issueCount} ${AppStrings.checksFailedLabel}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// small stat row with an icon and label — used inside the summary header
class _SummaryStatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _SummaryStatRow({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSizes.iconMd),
        const SizedBox(width: AppSizes.xs),
        Text(label, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
