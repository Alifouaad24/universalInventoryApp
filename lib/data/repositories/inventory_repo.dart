import 'package:ainalfhd_publisher/data/api/dio_client.dart';
import 'package:ainalfhd_publisher/data/models/inventory_response.dart';
import 'package:ainalfhd_publisher/main.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class InventoryRepo {
  Future<Either<String, List<InventoryModel>>> fetchInventory() async {
    try {
      final response = await DioClient().dio.get(
        '/Inventory/GetProcesedItems/28',
        options: Options(headers: {'Authorization': 'Bearer ${token}'}),
      );

      List<InventoryModel> inventory = (response.data as List)
          .map((item) => InventoryModel.fromJson(item))
          .toList();

      return Right(inventory);
    } on DioException catch (e) {
      return Left('Failed to fetch inventory: ${e.toString()}');
    }
  }

  Future<Either<String, InventoryModel>> editPrice(
    int inventoryId,
    String newPrice,
    String title,
  ) async {
    try {
      var response = await DioClient().dio.put(
        '/Inventory/AddPriceTitleToInv/${inventoryId}',
        data: {'price': newPrice, 'title': title},
      );
      var data = response.data;
      var inventory = InventoryModel.fromJson(data);
      return Right(inventory);
    } on DioException catch (e) {
      return Left('Failed to edit price: ${e.toString()}');
    }
  }
}
