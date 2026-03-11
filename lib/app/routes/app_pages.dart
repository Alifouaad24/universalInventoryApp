import 'package:ainalfhd_publisher/app/bindings/auth_binding.dart';
import 'package:ainalfhd_publisher/app/bindings/home_binding.dart';
import 'package:ainalfhd_publisher/app/bindings/inventory_binding.dart';
import 'package:ainalfhd_publisher/app/bindings/splash_binding.dart';
import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/modules/auth/views/login_view.dart';
import 'package:ainalfhd_publisher/modules/inventory/views/show_inventory_view.dart';
import 'package:ainalfhd_publisher/modules/splash/views/splash_screen.dart';
import 'package:ainalfhd_publisher/modules/home/views/home_view.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding()  
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.inventory,
      page: () => const ShowInventoryView(),
      binding: InventoryBinding(),
    ),
  ];
}