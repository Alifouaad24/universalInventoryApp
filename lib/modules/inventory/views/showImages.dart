import 'dart:io';
import 'package:ainalfhd_publisher/modules/inventory/controllers/inventory_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGalleryView extends StatelessWidget {
  final List<String> images;
  final String? title;
  final String? price;

  const ImageGalleryView({
    required this.images,
    this.title,
    this.price,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('المنتج'),
            centerTitle: true,
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 241, 43, 195),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final url = images[index];
                      return GestureDetector(
                        onLongPress: () async {
                          await controller.saveImageToGallery(url);
                        },
                        child: InteractiveViewer(
                          child: Center(
                            child: Image.network(
                              url,
                              fit: BoxFit.contain,
                              loadingBuilder: (context, child, progress) =>
                                  progress == null
                                  ? child
                                  : const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    for (var url in images) {
                      await controller.saveImageToGallery(url);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 182, 156, 176),
                  ),
                  child: controller.isSaveImagesLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('حفظ جميع الصور'),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Row(
                        textDirection: TextDirection.rtl,
                        children: const [
                          Icon(Icons.description, color: Colors.pink),
                          SizedBox(width: 6),
                          Text(
                            "الوصف",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        textDirection: TextDirection.rtl,
                        title ?? "غير محدد",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 💰 السعر
                      Row(
                        textDirection: TextDirection.rtl,
                        children: const [
                          SizedBox(width: 6),
                          Text(
                            "السعر",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        textDirection: TextDirection.rtl,
                        price ?? "غير محدد",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
