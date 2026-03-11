import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/data/models/user_responseModel.dart';
import 'package:ainalfhd_publisher/data/repositories/auth_repository.dart';
import 'package:ainalfhd_publisher/main.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class SplashController extends GetxController {
  AuthRepository authRepository = AuthRepository();
  StorageLocalService storageService = Get.find<StorageLocalService>();
  UserResponse? userResponse;
  int? selectedBusinessId;

  @override
  void onInit() async {
    super.onInit();
    initializeSettings();
  }

  void selectBusiness(Business business) {
    selectedBusinessId = business.businessId;
    storageService.writeInt('business_id', business.businessId);
    update();
  }

  Business? get selectedBusiness {
    if (userResponse == null || selectedBusinessId == null) return null;

    return userResponse!.businesses.firstWhere(
      (b) => b.businessId == selectedBusinessId,
      orElse: () {
        storageService.writeInt(
          'business_id',
          userResponse!.businesses.first.businessId,
        );
        return userResponse!.businesses.first;
      },
    );
  }

 Future<void> initializeSettings() async {
  if (token == null) {
    Future.microtask(() => Get.offAllNamed(AppRoutes.login));
    return;
  }

  final result = await authRepository.GetMyData();

  result.fold(
    (error) {
      Future.microtask(() => Get.offAllNamed(AppRoutes.login));
    },
    (data) {
      userResponse = data;
      selectedBusinessId = storageService.readInt('business_id');

      if (selectedBusinessId == null &&
          userResponse != null &&
          userResponse!.businesses.isNotEmpty) {
        storageService.writeInt(
          'business_id',
          userResponse!.businesses.first.businessId,
        );
      }

      update();
      Future.microtask(() => Get.offAllNamed(AppRoutes.home));
    },
  );
}

  @override
  void onClose() {
    super.onClose();
  }
}
