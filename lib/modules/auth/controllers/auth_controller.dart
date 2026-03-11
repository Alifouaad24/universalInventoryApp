import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/data/models/user_responseModel.dart';
import 'package:ainalfhd_publisher/data/repositories/auth_repository.dart';
import 'package:ainalfhd_publisher/main.dart';
import 'package:ainalfhd_publisher/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final StorageLocalService _storageService = Get.find<StorageLocalService>();
  StorageLocalService storageService = Get.find<StorageLocalService>();
final SplashController _splashController = Get.find<SplashController>();
  UserResponse? userResponse;
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  int? selectedBusinessId;

  Future<void> login() async {
    loading = true;
    update();
    final result = await _authRepository.login(
      email: emailCtrl.text.trim(),
      password: passCtrl.text.trim(),
    );

    result.fold(
      (error) {
        Get.snackbar(
          'Login Failed',
          error,
          snackPosition: SnackPosition.BOTTOM,
        );
        loading = false;
        update();
      },
      (user) async {
        loading = false;
        update();
        _storageService.writeString('token', user.token);
        Future.delayed(const Duration(milliseconds: 500), () {});
        token = user.token;
        await _splashController.initializeSettings();
        update();
      },
    );
  }

  void logout() async {
    await _storageService.remove('token');
    await _storageService.remove('business_id');
    token = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
