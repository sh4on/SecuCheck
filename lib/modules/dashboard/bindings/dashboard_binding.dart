import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';

// injects DashboardController when the dashboard route is entered
class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
