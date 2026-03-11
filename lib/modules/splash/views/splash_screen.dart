import 'package:ainalfhd_publisher/modules/splash/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController controller = Get.find<SplashController>();
  @override
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 177, 58, 183),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.inventory_2_outlined,
                size: 100,
                color: Colors.white,
              ),
              SizedBox(height: 16),
              Text(
                'Universal Inventory',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    
  }
}
