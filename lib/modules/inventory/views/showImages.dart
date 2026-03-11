import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageGalleryView extends StatelessWidget {
  final List<String> images;
  const ImageGalleryView({required this.images, super.key});

  Future<void> saveImageToGallery(String imageUrl) async {
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
      Fluttertoast.showToast(msg: "تم حفظ الصورة في المعرض", backgroundColor: Colors.green);
      print("تم حفظ الصورة في المعرض");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "خطأ: $e", backgroundColor: Colors.red);  
    print("خطأ: $e");
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
