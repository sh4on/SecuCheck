import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/models/security_check_model.dart';

// reusable status badge chip that displays safe / warning / critical / info
class StatusBadgeWidget extends StatelessWidget {
  final CheckStatus status;

  const StatusBadgeWidget({super.key, required this.status});

  // color corresponding to the check status
  Color get _color {
    switch (status) {
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

  // text label for the badge
  String get _label {
    switch (status) {
      case CheckStatus.safe:
        return AppStrings.statusSafe;
      case CheckStatus.warning:
        return AppStrings.statusWarning;
      case CheckStatus.critical:
        return AppStrings.statusCritical;
      case CheckStatus.info:
        return AppStrings.statusInfo;
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        // semi-transparent fill using status color
        color: _color.withAlpha(38),
        borderRadius: BorderRadius.circular(AppSizes.radiusFull),
        border: Border.all(color: _color.withAlpha(100)),
      ),
      child: Text(
        _label,
        style: AppTextStyles.labelMedium.copyWith(color: _color),
      ),
    );
  }
}
