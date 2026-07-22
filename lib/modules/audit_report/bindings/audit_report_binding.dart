import 'package:get/get.dart';
import '../controllers/audit_report_controller.dart';

// injects AuditReportController when the report route is entered
class AuditReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuditReportController>(() => AuditReportController());
  }
}
