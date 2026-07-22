import 'package:flutter_test/flutter_test.dart';
import 'package:secucheck/data/models/security_check_model.dart';
import 'package:secucheck/data/models/security_report_model.dart';

void main() {
  group('SecurityCategoryModel tests', () {
    test('overallStatus returns safe when all checks are safe', () {
      const category = SecurityCategoryModel(
        id: 'cat_test',
        title: 'Test Category',
        checks: [
          SecurityCheckModel(
            id: 'check1',
            name: 'Check 1',
            description: 'Desc',
            status: CheckStatus.safe,
            detail: 'Safe',
            scoreImpact: 0,
          ),
          SecurityCheckModel(
            id: 'check2',
            name: 'Check 2',
            description: 'Desc',
            status: CheckStatus.safe,
            detail: 'Safe',
            scoreImpact: 0,
          ),
        ],
      );

      expect(category.overallStatus, equals(CheckStatus.safe));
    });

    test('overallStatus returns critical if any check is critical', () {
      const category = SecurityCategoryModel(
        id: 'cat_test',
        title: 'Test Category',
        checks: [
          SecurityCheckModel(
            id: 'check1',
            name: 'Check 1',
            description: 'Desc',
            status: CheckStatus.safe,
            detail: 'Safe',
            scoreImpact: 0,
          ),
          SecurityCheckModel(
            id: 'check2',
            name: 'Check 2',
            description: 'Desc',
            status: CheckStatus.critical,
            detail: 'Critical issue',
            scoreImpact: -20,
          ),
          SecurityCheckModel(
            id: 'check3',
            name: 'Check 3',
            description: 'Desc',
            status: CheckStatus.warning,
            detail: 'Warning issue',
            scoreImpact: -10,
          ),
        ],
      );

      expect(category.overallStatus, equals(CheckStatus.critical));
    });

    test('overallStatus returns warning if highest severity is warning', () {
      const category = SecurityCategoryModel(
        id: 'cat_test',
        title: 'Test Category',
        checks: [
          SecurityCheckModel(
            id: 'check1',
            name: 'Check 1',
            description: 'Desc',
            status: CheckStatus.safe,
            detail: 'Safe',
            scoreImpact: 0,
          ),
          SecurityCheckModel(
            id: 'check2',
            name: 'Check 2',
            description: 'Desc',
            status: CheckStatus.warning,
            detail: 'Warning issue',
            scoreImpact: -10,
          ),
        ],
      );

      expect(category.overallStatus, equals(CheckStatus.warning));
    });
  });

  group('SecurityReportModel tests', () {
    test('computes issueCount and safeCount correctly across categories', () {
      final report = SecurityReportModel(
        categories: [
          const SecurityCategoryModel(
            id: 'cat1',
            title: 'Category 1',
            checks: [
              SecurityCheckModel(
                id: 'c1',
                name: 'C1',
                description: 'D',
                status: CheckStatus.safe,
                detail: 'OK',
                scoreImpact: 0,
              ),
              SecurityCheckModel(
                id: 'c2',
                name: 'C2',
                description: 'D',
                status: CheckStatus.critical,
                detail: 'Fail',
                scoreImpact: -20,
              ),
            ],
          ),
          const SecurityCategoryModel(
            id: 'cat2',
            title: 'Category 2',
            checks: [
              SecurityCheckModel(
                id: 'c3',
                name: 'C3',
                description: 'D',
                status: CheckStatus.safe,
                detail: 'OK',
                scoreImpact: 0,
              ),
              SecurityCheckModel(
                id: 'c4',
                name: 'C4',
                description: 'D',
                status: CheckStatus.warning,
                detail: 'Warn',
                scoreImpact: -10,
              ),
            ],
          ),
        ],
        score: 70,
        scanTime: DateTime.now(),
      );

      expect(report.totalCount, equals(4));
      expect(report.safeCount, equals(2));
      expect(report.issueCount, equals(2));
    });

    test('score clamping keeps score between 0 and 100', () {
      final reportHigh = SecurityReportModel(
        categories: [],
        score: 120.clamp(0, 100),
        scanTime: DateTime.now(),
      );

      final reportLow = SecurityReportModel(
        categories: [],
        score: (-30).clamp(0, 100),
        scanTime: DateTime.now(),
      );

      expect(reportHigh.score, equals(100));
      expect(reportLow.score, equals(0));
    });
  });
}
