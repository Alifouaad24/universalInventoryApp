import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGalleryView extends StatelessWidget {
  final List<String> images;
  const ImageGalleryView({required this.images, super.key});

  Future<void> saveImageToGallery(String imageUrl) async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(msg: "الصلاحية مرفوضة");
          return;
        }
      }
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory? directory;
        if (Platform.isAndroid) {
          directory = Directory('/storage/emulated/0/Pictures/AinAlFhd');
        } else {
          directory = await getApplicationDocumentsDirectory();
        }

        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        String fileName =
            "product_${DateTime.now().millisecondsSinceEpoch}.png";
        File file = File("${directory.path}/$fileName");
        await file.writeAsBytes(response.data);

        Fluttertoast.showToast(
          msg: "تم حفظ الصورة بنجاح",
          toastLength: Toast.LENGTH_LONG,
        );
      } else {
        Fluttertoast.showToast(msg: "فشل تحميل الصورة");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "حدث خطأ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صور المنتج'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 241, 43, 195),
      ),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final url = images[index];
          return GestureDetector(
            onLongPress: () async {
              await saveImageToGallery(url);
            },
            child: InteractiveViewer(
              child: Center(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
