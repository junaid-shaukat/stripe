import '/core/app_export.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PermissionService(), fenix: true);
  }
}
