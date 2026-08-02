import 'package:ainalfhd_publisher/app/routes/app_routes.dart';
import 'package:ainalfhd_publisher/app/services/local_storage.dart';
import 'package:ainalfhd_publisher/modules/home/controllers/home-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  StorageLocalService storage = Get.find<StorageLocalService>();

  static const _primary = Color(0xFF4F46E5);
  static const _primaryLight = Color(0xFF7C6EF6);
  static const _bg = Color(0xFFF6F7FB);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: _bg,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 190,
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                elevation: 0,
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    onSelected: (value) {
                      if (value == 'logout') {
                        storage.clear();
                        Get.offAllNamed(AppRoutes.login);
                      }
                      if (value == 'userManager') {
                        Get.toNamed(AppRoutes.userManager);
                      }
                    },
                    itemBuilder: (context) => [
                      if (controller.isAdmin)
                        const PopupMenuItem(
                          value: 'userManager',
                          child: Row(
                            children: [
                              Icon(Icons.manage_accounts_outlined, size: 20),
                              SizedBox(width: 10),
                              Text('إدارة المستخدمين'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout_outlined, size: 20, color: Colors.red),
                            SizedBox(width: 10),
                            Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: const Text(
                    'الرئيسية',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_primary, _primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          top: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.dashboard_customize_outlined,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'مرحباً بك في لوحة التحكم',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _DashboardCard(
                      icon: Icons.storefront_outlined,
                      title: 'عرض المخزن',
                      subtitle: 'إدارة المنتجات والمخزون',
                      color: _primary,
                      onTap: () => Get.toNamed(AppRoutes.inventory),
                    ),
                    const SizedBox(height: 14),
                    _DashboardCard(
                      icon: Icons.settings_outlined,
                      title: 'الإعدادات',
                      subtitle: 'قيد التطوير',
                      color: Colors.grey.shade500,
                      onTap: () {
                        Get.snackbar(
                          'Coming Soon',
                          'هذه الميزة قيد التطوير',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.grey.shade800,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      },
                    ),
                    if (controller.isAdmin) ...[
                      const SizedBox(height: 14),
                      _DashboardCard(
                        icon: Icons.manage_accounts_outlined,
                        title: 'إدارة المستخدمين',
                        subtitle: 'الأدوار والصلاحيات',
                        color: _primaryLight,
                        onTap: () => Get.toNamed(AppRoutes.userManager),
                      ),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}