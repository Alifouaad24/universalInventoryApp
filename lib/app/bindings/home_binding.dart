import 'package:ainalfhd_publisher/modules/home/controllers/home-controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}