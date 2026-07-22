import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/common_widgets/empty_state_widget.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/audit_report_controller.dart';
import 'widgets/category_section_header.dart';
import 'widgets/check_item_tile.dart';
import 'widgets/hardware_guide_card.dart';
import 'widgets/scan_summary_header.dart';

// full audit report screen displaying score summary, collapsible category sections,
// check item details with fix recommendations, and the educational hardware security guide
class AuditReportScreen extends GetView<AuditReportController> {
  const AuditReportScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    // show empty state if no report was passed via navigation arguments
    if (controller.report == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text(AppStrings.auditReportTitle)),
        body: const EmptyStateWidget(message: AppStrings.emptyScanMessage),
      );
    }

    final report = controller.report!;
    final dashboardController = Get.find<DashboardController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.auditReportTitle),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: Get.back,
        ),
        actions: [
          // re-scan icon button in appbar
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.accent),
            tooltip: AppStrings.reScanButtonLabel,
            onPressed: () async {
              Get.back();
              await dashboardController.runScan();
              dashboardController.openReport();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.pagePaddingH.w,
          vertical: AppSizes.sm.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // score + counts summary header
            ScanSummaryHeader(report: report),
            SizedBox(height: AppSizes.lg.h),

            // collapsible category sections — rebuilt when expanded set changes
            Obx(
              () => Column(
                children: report.categories.map((category) {
                  final expanded = controller.isExpanded(category.id);
                  return Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.sm.h),
                    child: Column(
                      children: [
                        // tappable category header with status badge & chevron
                        CategorySectionHeader(
                          category: category,
                          isExpanded: expanded,
                          onTap: () => controller.toggleCategory(category.id),
                        ),
                        // cross-fade between collapsed/expanded check list
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: EdgeInsets.only(top: AppSizes.sm.h),
                            child: Column(
                              children: category.checks
                                  .map(
                                    (check) => CheckItemTile(check: check),
                                  )
                                  .toList(),
                            ),
                          ),
                          crossFadeState: expanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 250),
                          sizeCurve: Curves.easeInOut,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: AppSizes.md.h),

            // educational hardware security guide (always visible)
            const HardwareGuideCard(),
            SizedBox(height: AppSizes.lg.h),

            // re-scan button at bottom of report
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Get.back();
                  await dashboardController.runScan();
                  dashboardController.openReport();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.background,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.md.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  AppStrings.reScanButtonLabel,
                  style: AppTextStyles.headingSmall
                      .copyWith(color: AppColors.background),
                ),
              ),
            ),

            SizedBox(height: AppSizes.xl.h),
          ],
        ),
      ),
    );
  }
}
