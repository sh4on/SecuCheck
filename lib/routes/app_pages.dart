import 'package:get/get.dart';
import '../modules/audit_report/bindings/audit_report_binding.dart';
import '../modules/audit_report/screens/audit_report_screen.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/screens/dashboard_screen.dart';
import 'app_routes.dart';

// getx page definitions — maps route names to screens and bindings
abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = [
    // dashboard / home screen
    GetPage<dynamic>(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),

    // full audit report detail screen
    GetPage<dynamic>(
      name: AppRoutes.auditReport,
      page: () => const AuditReportScreen(),
      binding: AuditReportBinding(),
    ),
  ];
}
