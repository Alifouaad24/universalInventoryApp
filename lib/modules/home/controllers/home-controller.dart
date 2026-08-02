import 'dart:convert';

import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/data/models/UsersModel.dart';
import 'package:ainalfhd_publisher/data/repositories/home_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository();
  final StorageLocalService _storageService = Get.find<StorageLocalService>();
  List<UserModel> users = [];
  List<RoleModel> roles = [];
  UserModel? selectedUser;
  bool isAdmin = false;

  @override
  void onInit() {
    super.onInit();
    getUserRoles();
    fetchUsers();
    fetchRoles();
  }

  void getUserRoles() {
    var currentUserRoles = _storageService.readString('roles') ?? '';
    List<String> realRoles = [];
    if (currentUserRoles.isNotEmpty) {
      realRoles = List<String>.from(jsonDecode(currentUserRoles));
    }
    print('Roles: $realRoles');
    isAdmin = realRoles.contains('Admin');
    update();
  }

  Future<void> fetchUsers() async {
    final result = await _homeRepository.getUserData();
    result.fold(
      (error) {
        print('Error fetching users: $error');
      },
      (userList) {
        users = userList;
        update();
      },
    );
  }

  Future<void> fetchRoles() async {
    final result = await _homeRepository.getRoles();
    result.fold(
      (error) {
        print('Error fetching roles: $error');
      },
      (allRoles) {
        // Handle roles if needed
        print('Fetched roles: $allRoles');
        roles = allRoles;
      },
    );
  }

  void updateUserRoles(String userId, List<String> selectedRoles) async {
    final result = await _homeRepository.updateUserRoles(userId, selectedRoles);
    result.fold(
      (error) {
        print('Error updating user roles: $error');
      },
      (success) {
        print('User roles updated successfully');
        fetchUsers(); // Refresh the user list after updating roles
      },
    );
  }
}
