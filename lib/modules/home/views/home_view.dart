import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StorageLocalService storage = Get.find<StorageLocalService>();

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 176, 126, 176),
      appBar: AppBar(
        title: const Text('الرئيسية'),
        actions: [
          IconButton(
            onPressed: () {
              storage.clear();
              Get.offAllNamed(AppRoutes.login);
            },
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 241, 43, 195),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.dashboard_customize_outlined,
              size: 100,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            const SizedBox(height: 24),
            const Text(
              'مرحباً بك في لوحة التحكم',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(AppRoutes.inventory);
                },
                icon: const Icon(Icons.storefront_outlined),
                label: const Text(
                  'عرض المخزن',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 192, 71, 222),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: Colors.deepPurpleAccent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // زر إضافي كمثال
            SizedBox(
              width: 220,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'هذه الميزة قيد التطوير',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.deepPurple.shade700,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.settings_outlined),
                label: const Text(
                  'الإعدادات',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 192, 71, 222),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: const Color.fromARGB(255, 192, 71, 222),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
