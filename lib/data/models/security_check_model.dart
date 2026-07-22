// severity level of a single security check result
enum CheckStatus {
  // no issue detected
  safe,
  // potential issue that should be reviewed
  warning,
  // serious vulnerability that should be fixed immediately
  critical,
  // informational finding — not necessarily risky
  info,
}

// model representing the result of a single device security check
class SecurityCheckModel {
  // unique identifier for this check (used for keying/lookup)
  final String id;

  // human-readable check name shown in the ui
  final String name;

  // description explaining what this check does
  final String description;

  // the risk level determined from native check results
  final CheckStatus status;

  // human-readable detail string derived from native data (shown in report)
  final String detail;

  // negative score impact (0 or negative integer); e.g. -20 for critical issues
  final int scoreImpact;

  // actionable recommendation shown for non-safe checks — null means no action needed
  final String? fixRecommendation;

  const SecurityCheckModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.detail,
    required this.scoreImpact,
    this.fixRecommendation,
  });
}
