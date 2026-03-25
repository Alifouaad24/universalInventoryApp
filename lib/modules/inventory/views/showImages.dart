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
  final int id;
  final List<String> images;
  final String? title;
  final String? price;

  const ImageGalleryView({
    required this.id,
    required this.images,
    required this.title,
    required this.price,
    super.key,
  });

  void _showEditPriceDialog(BuildContext context) {
    final TextEditingController priceController = TextEditingController(
      text: price,
    );
    final TextEditingController titleController = TextEditingController(
      text: title,
    );

    Get.defaultDialog(
      title: 'تعديل السعر',
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(labelText: 'السعر'),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'العنوان'),
            ),
          ],
        ),
      ),
      textConfirm: 'حفظ',
      textCancel: 'إلغاء',
      onConfirm: () {
        if (priceController.text.isEmpty) {
          Get.snackbar('خطأ', 'أدخل رقم صحيح');
          return;
        }
        if (priceController.text.replaceAll('\$', '').contains(RegExp(r'[^\d.]'))) {
          Get.snackbar('خطأ', 'أدخل رقم صحيح');
          return;
        }
        if (priceController.text.contains('\$')) {
          priceController.text = priceController.text.replaceAll('\$', '');
        }
        Get.find<InventoryController>().editPrice(
          id,
          priceController.text + '\$',
          titleController.text,
        );

        // update price
        Get.back();
      },
    );
  }

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
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit_price') {
                    _showEditPriceDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit_price',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('تعديل السعر'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              if (controller.isloading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              SingleChildScrollView(
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
                        backgroundColor: const Color.fromARGB(
                          255,
                          182,
                          156,
                          176,
                        ),
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
            ],
          ),
        );
      },
    );
  }
}
