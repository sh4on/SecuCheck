import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

// educational hardware security guide section with three manual risk items
class HardwareGuideCard extends StatelessWidget {
  const HardwareGuideCard({super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // section title row with book icon
        Row(
          children: [
            const Icon(
              Icons.menu_book_rounded,
              color: AppColors.info,
              size: AppSizes.iconLg,
            ),
            const SizedBox(width: AppSizes.sm),
            Text(
              AppStrings.catHardwareGuide,
              style: AppTextStyles.headingMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        // info note explaining these are manual checks
        Container(
          padding: const EdgeInsets.all(AppSizes.sm),
          decoration: BoxDecoration(
            color: AppColors.info.withAlpha(26),
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
            border: Border.all(color: AppColors.info.withAlpha(77)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.info,
                size: AppSizes.iconSm,
              ),
              const SizedBox(width: AppSizes.xs),
              Expanded(
                child: Text(
                  AppStrings.hwInfoNote,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.md),
        // juice jacking risk
        const _HardwareRiskItem(
          title: AppStrings.hwJuiceJackingTitle,
          description: AppStrings.hwJuiceJackingDesc,
          icon: Icons.usb_rounded,
        ),
        // jtag/uart risk
        const _HardwareRiskItem(
          title: AppStrings.hwJtagTitle,
          description: AppStrings.hwJtagDesc,
          icon: Icons.memory_rounded,
        ),
        // rogue cell tower risk
        const _HardwareRiskItem(
          title: AppStrings.hwRogueCellTitle,
          description: AppStrings.hwRogueCellDesc,
          icon: Icons.cell_tower_rounded,
        ),
      ],
    );
  }
}

// individual hardware risk item card with icon, title, and description
class _HardwareRiskItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _HardwareRiskItem({
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      padding: const EdgeInsets.all(AppSizes.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusLg),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icon and title row
          Row(
            children: [
              Icon(icon, color: AppColors.warning, size: AppSizes.iconMd),
              const SizedBox(width: AppSizes.sm),
              Text(title, style: AppTextStyles.headingSmall),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          // risk description
          Text(description, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
