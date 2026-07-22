import 'package:get/get.dart';
import '../../../data/models/security_report_model.dart';

// controller for the audit report screen — receives and exposes the report model
// and manages which category sections are expanded/collapsed
class AuditReportController extends GetxController {
  // the report passed via navigation arguments from the dashboard
  SecurityReportModel? report;

  // set of category ids that are currently expanded (all expanded by default)
  final RxSet<String> expandedCategories = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // receive the SecurityReportModel from navigation arguments
    if (Get.arguments is SecurityReportModel) {
      report = Get.arguments as SecurityReportModel;
      // expand all category sections by default when the report is loaded
      for (final cat in report!.categories) {
        expandedCategories.add(cat.id);
      }
    }
  }

  // toggle a category section between expanded and collapsed
  void toggleCategory(final String categoryId) {
    if (expandedCategories.contains(categoryId)) {
      expandedCategories.remove(categoryId);
    } else {
      expandedCategories.add(categoryId);
    }
  }

  // returns true if the given category id is currently expanded
  bool isExpanded(final String categoryId) =>
      expandedCategories.contains(categoryId);
}
