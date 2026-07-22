import 'package:get/get.dart';
import '../../../data/models/security_report_model.dart';
import '../../../data/repositories/security_repository.dart';
import '../../../routes/app_routes.dart';

// controller for the dashboard screen — manages scan lifecycle and score animation
class DashboardController extends GetxController {
  // rx status drives the loading / error / success ui state
  final Rx<RxStatus> status = Rx<RxStatus>(RxStatus.empty());

  // holds the latest completed security report
  final Rx<SecurityReportModel?> report = Rx<SecurityReportModel?>(null);

  // animated score value that counts up from 0 after a scan completes
  final RxInt animatedScore = 0.obs;

  // true once the user has run at least one scan
  final RxBool hasScanned = false.obs;

  // pull the repository from getx's dependency container
  SecurityRepository get _repo => Get.find<SecurityRepository>();

  // run the full device security scan and update ui state accordingly
  Future<void> runScan() async {
    // prevent concurrent scans
    if (status.value.isLoading) return;

    status.value = RxStatus.loading();

    try {
      final result = await _repo.runFullScan();
      report.value = result;
      hasScanned.value = true;
      status.value = RxStatus.success();

      // kick off the score counter animation after results arrive
      _animateScore(result.score);
    } catch (e) {
      status.value = RxStatus.error(e.toString());
    }
  }

  // animate the score counter from 0 up to the target value
  void _animateScore(final int target) {
    animatedScore.value = 0;
    // run the loop asynchronously so it doesn't block the ui thread
    Future<void>(() async {
      for (int i = 0; i <= target; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 12));
        animatedScore.value = i;
      }
    });
  }

  // navigate to the full audit report screen, passing the report as an argument
  void openReport() {
    if (report.value != null) {
      Get.toNamed<void>(AppRoutes.auditReport, arguments: report.value);
    }
  }
}
