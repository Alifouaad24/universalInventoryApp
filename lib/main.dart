import 'package:ainalfhd_publisher/app/routes/app_pages.dart';
import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/data/api/dio_client.dart';
import 'package:ainalfhd_publisher/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

String ? token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  StorageLocalService storageService = Get.put(StorageLocalService());
  token = storageService.readString('token');
  Get.put(DioClient());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AinAlFhd Publisher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
    );
  }
}

