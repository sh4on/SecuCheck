import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/common_widgets/error_state_widget.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/category_summary_card.dart';
import 'widgets/dashboard_header_widget.dart';
import 'widgets/pre_scan_placeholder.dart';
import 'widgets/scan_button_widget.dart';
import 'widgets/score_ring_widget.dart';

// main dashboard screen — shows the security score ring, category summary cards,
// and the scan/report action buttons
class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final isLoading = controller.status.value.isLoading;
          final isError = controller.status.value.isError;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // header: app name + logo
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.pagePaddingH.w,
                    AppSizes.lg.h,
                    AppSizes.pagePaddingH.w,
                    0,
                  ),
                  child: const DashboardHeaderWidget(),
                ),
              ),

              // score ring (only visible after a successful scan)
              if (controller.hasScanned.value && !isError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.xl.h),
                    child: Center(
                      child: ScoreRingWidget(
                        score: controller.report.value?.score ?? 0,
                        animatedScore: controller.animatedScore.value,
                      ),
                    ),
                  ),
                ),

              // pre-scan placeholder (shown only before first scan, when not loading)
              if (!controller.hasScanned.value && !isLoading && !isError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.xxl.h),
                    child: const PreScanPlaceholder(),
                  ),
                ),

              // loading spinner between score ring and category cards
              if (isLoading && !controller.hasScanned.value)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.xxl.h),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                ),

              // error state — full remaining height
              if (isError)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorStateWidget(onRetry: controller.runScan),
                ),

              // category summary cards (shown only after successful scan)
              if (controller.hasScanned.value && !isError)
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppSizes.pagePaddingH.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (final context, final index) {
                        final category = controller.report.value!.categories[index];
                        return CategorySummaryCard(category: category);
                      },
                      childCount: controller.report.value?.categories.length ?? 0,
                    ),
                  ),
                ),

              // "view full report" outlined button (after scan)
              if (controller.hasScanned.value && !isError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSizes.pagePaddingH.w,
                      AppSizes.sm.h,
                      AppSizes.pagePaddingH.w,
                      0,
                    ),
                    child: OutlinedButton(
                      onPressed: controller.openReport,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                        padding: EdgeInsets.symmetric(vertical: AppSizes.md.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                        ),
                      ),
                      child: Text(
                        AppStrings.viewFullReport,
                        style: AppTextStyles.headingSmall
                            .copyWith(color: AppColors.accent),
                      ),
                    ),
                  ),
                ),

              // scan button — always visible at the bottom
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSizes.pagePaddingH.w,
                    AppSizes.md.h,
                    AppSizes.pagePaddingH.w,
                    AppSizes.xl.h,
                  ),
                  child: ScanButtonWidget(
                    onTap: controller.runScan,
                    isScanning: isLoading,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
