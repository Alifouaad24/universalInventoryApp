import 'dart:convert';

import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/data/models/user_responseModel.dart';
import 'package:ainalfhd_publisher/data/repositories/auth_repository.dart';
import 'package:ainalfhd_publisher/main.dart';
import 'package:ainalfhd_publisher/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        await _storageService.writeString('token', user.token);
        await decodeToken(user.token);
        Future.delayed(const Duration(milliseconds: 500), () {});
        token = user.token;
        await _splashController.initializeSettings();
        update();
      },
    );
  }

  Future<void> decodeToken(String token) async {
    final parts = token.split('.');

    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final normalizedPayload = base64Url.normalize(payload);
    final decodedBytes = base64Url.decode(normalizedPayload);

    final decodedString = utf8.decode(decodedBytes);

    final Map<String, dynamic> data = jsonDecode(decodedString);

    final rolesKey =
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role';

    final roles = data[rolesKey];

    await _storageService.writeString('roles', jsonEncode(roles));
  }

  void logout() async {
    await _storageService.remove('token');
    await _storageService.remove('business_id');
    token = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
