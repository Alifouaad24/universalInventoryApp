import 'package:ainalfhd_publisher/modules/inventory/controllers/inventory_controller.dart';
import 'package:ainalfhd_publisher/modules/inventory/views/showImages.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class ShowInventoryView extends StatefulWidget {
  const ShowInventoryView({super.key});

  @override
  State<ShowInventoryView> createState() => _ShowInventoryViewState();
}

class _ShowInventoryViewState extends State<ShowInventoryView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryController>(
      builder: (controller) {
        if (controller.isloading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.inventory.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('لا توجد بيانات في المخزن.')),
          );
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 204, 171, 204),
          appBar: AppBar(
            title: const Text('المخزن'),
            foregroundColor: Colors.white,
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 241, 43, 195),
          ),
          body: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.inventory.length,
            itemBuilder: (context, index) {
              final item = controller.inventory[index];
              final imageUrl =
                  item.item?.images != null && item.item!.images!.length > 1
                  ? item.item!.images[1].imageUrl
                  : null;

              return GestureDetector(
                onTap: () {
                  final urls =
                      item.item?.images.map((e) => e.imageUrl).toList() ?? [];
                  if (urls.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageGalleryView(images: urls, title: item.description, price: item.sitePrice),
                      ),
                    );
                  }
                },
                child: Card(
                  color: const Color.fromARGB(255, 233, 48, 159),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // صورة المنتج
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: imageUrl != null
                              ? Image.network(
                                  imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white54,
                                    size: 40,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 12),
                        // معلومات المنتج
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.item?.sku ?? 'بدون SKU',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'المقاس: ${item.size?.description ?? "غير محدد"}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الصور: ${item.item?.images.length ?? "غير محدد"}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
