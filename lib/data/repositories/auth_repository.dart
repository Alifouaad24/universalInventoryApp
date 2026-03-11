import 'package:ainalfhd_publisher/data/api/dio_client.dart';
import 'package:ainalfhd_publisher/data/models/LoginResponse.dart';
import 'package:ainalfhd_publisher/data/models/user_responseModel.dart';
import 'package:ainalfhd_publisher/main.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dioClient = DioClient().dio;

  Future<Either<String, LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.post(
        '/Account/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      final loginResponse = LoginResponse.fromJson(response.data);
      return Right(loginResponse);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserResponse>> GetMyData() async {
    try {
      final response = await _dioClient.get(
        '/Account/GetMyData',
        options: Options(headers: {'Authorization': 'Bearer ${token}'}),
      );

      final data = response.data;
      final userResponse = UserResponse.fromJson(data);
      return Right(userResponse);
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        return Left(data['message']?.toString() ?? 'Request failed');
      }

      if (data is String) {
        return Left(data);
      }

      return Left('Network or server error');
    }
  }
}