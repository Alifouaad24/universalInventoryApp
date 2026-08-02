import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/data/api/dio_client.dart';
import 'package:ainalfhd_publisher/data/models/UsersModel.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomeRepository {
  final Dio _dioClient = DioClient().dio;
  final StorageLocalService _storageService = Get.find<StorageLocalService>();

  Future<Either<String, List<UserModel>>> getUserData() async {
    final token = _storageService.readString('token');
    try {
      final response = await _dioClient.get('/Account/getAllUsers');

      final users = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();

      return Right(users);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, List<RoleModel>>> getRoles() async {
    final token = _storageService.readString('token');
    try {
      final response = await _dioClient.get('/Account/getAllRoles');

      final roles = (response.data as List)
          .map((e) => RoleModel.fromJson(e))
          .toList();

      return Right(roles);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> updateUserRoles(
    String userId,
    List<String> roles,
  ) async {
    final token = _storageService.readString('token');
    try {
      final response = await _dioClient.put(
        '/Account/updateUserRoles/$userId',
        data: {"roles": roles},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left('Failed to update user roles');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
