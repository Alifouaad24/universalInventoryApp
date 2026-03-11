import 'package:get/get.dart';
import 'package:ainalfhd_publisher/modules/inventory/controllers/inventory_controller.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InventoryController());
  }
}