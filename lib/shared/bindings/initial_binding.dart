import 'package:get/get.dart';
import '../../data/repositories/security_repository.dart';

// initial app-level binding — registers app-wide singleton dependencies
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // register SecurityRepository as a lazily-created singleton that persists
    // across route changes (fenix: true re-creates it if disposed)
    Get.lazyPut<SecurityRepository>(
      () => SecurityRepository(),
      fenix: true,
    );
  }
}
