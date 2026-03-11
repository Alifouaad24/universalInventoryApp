import 'package:ainalfhd_publisher/data/models/inventory_response.dart';
import 'package:ainalfhd_publisher/data/repositories/inventory_repo.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class InventoryController extends GetxController {
  InventoryRepo inventoryRepo = InventoryRepo();
  List<InventoryModel> inventory = [];
  bool isloading = false;
  @override
  void onInit() {
    super.onInit();
    getInventory();
  }

  Future<void> getInventory() async {
    isloading = true;
    update();
    final result = await inventoryRepo.fetchInventory();
    result.fold(
      (error) {
        isloading = false;
        update();
      },
      (data) {
        inventory = data;
        isloading = false;
        update();
      },
    );
  }
}
