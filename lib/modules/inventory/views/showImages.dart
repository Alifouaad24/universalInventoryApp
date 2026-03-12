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
                                : const Center(child: CircularProgressIndicator()),
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
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('حفظ جميع الصور'),
              ),
              const Divider(),
              Text(
                'الوصف: ${title ?? " غير محدد"}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          
              Text(
                'السعر: ${price ?? " غير محدد"}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
      }
    );
  }
}
