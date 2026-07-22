import 'security_check_model.dart';

// model representing a named group of related security checks (a category)
class SecurityCategoryModel {
  // unique identifier used for expand/collapse state keying
  final String id;

  // category display title shown in the ui
  final String title;

  // all checks belonging to this category
  final List<SecurityCheckModel> checks;

  const SecurityCategoryModel({
    required this.id,
    required this.title,
    required this.checks,
  });

  // aggregate category status: the worst individual check status wins
  CheckStatus get overallStatus {
    if (checks.any((c) => c.status == CheckStatus.critical)) {
      return CheckStatus.critical;
    }
    if (checks.any((c) => c.status == CheckStatus.warning)) {
      return CheckStatus.warning;
    }
    if (checks.any((c) => c.status == CheckStatus.info)) {
      return CheckStatus.info;
    }
    return CheckStatus.safe;
  }
}

// model representing the full audit report produced by a device scan
class SecurityReportModel {
  // all category groups with their checks
  final List<SecurityCategoryModel> categories;

  // computed security score clamped to [0, 100]
  final int score;

  // timestamp of when the scan was run
  final DateTime scanTime;

  const SecurityReportModel({
    required this.categories,
    required this.score,
    required this.scanTime,
  });

  // total number of non-safe checks across all categories
  int get issueCount => categories
      .expand((c) => c.checks)
      .where((c) => c.status != CheckStatus.safe)
      .length;

  // total number of safe checks across all categories
  int get safeCount => categories
      .expand((c) => c.checks)
      .where((c) => c.status == CheckStatus.safe)
      .length;

  // total number of checks across all categories
  int get totalCount => categories.expand((c) => c.checks).length;
}
