import 'dart:io';

import 'package:ainalfhd_publisher/data/models/inventory_response.dart';
import 'package:ainalfhd_publisher/data/repositories/inventory_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';

class InventoryController extends GetxController {
  InventoryRepo inventoryRepo = InventoryRepo();
  List<InventoryModel> inventory = [];
  List<InventoryModel> constInventory = [];
  List<String> disinctSizes = [];
  bool isloading = false;
  bool isSaveImagesLoading = false;
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
        constInventory = List.from(data);
        disinctSizes = inventory
            .map((e) => e.size?.description)
            .where((description) => description != null)
            .cast<String>()
            .toSet()
            .toList();
        isloading = false;
        update();
      },
    );
  }

  void filterBySize(String size) {
    if (size == "All") {
      inventory = List.from(constInventory);
    } else {
      inventory = constInventory
          .where((item) => item.size?.description.trim() == size.trim())
          .toList();
    }

    update();
  }

  Future<void> saveImageToGallery(String imageUrl) async {
    isSaveImagesLoading = true;
    update();
    try {
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();

        final filePath =
            "${tempDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.png";

        final file = File(filePath);
        await file.writeAsBytes(response.data);

        await GallerySaver.saveImage(file.path);
        Fluttertoast.showToast(
          msg: "تم حفظ الصورة في المعرض",
          backgroundColor: Colors.green,
        );
        print("تم حفظ الصورة في المعرض");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "خطأ: $e", backgroundColor: Colors.red);
      print("خطأ: $e");
    } finally {
      isSaveImagesLoading = false;
      update();
    }
  }
}
