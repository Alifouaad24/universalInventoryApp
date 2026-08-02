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
  static const _primary = Color(0xFF4F46E5);
  static const _primaryLight = Color(0xFF7C6EF6);
  static const _bg = Color(0xFFF6F7FB);

  String _selectedSize = 'All';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryController>(
      builder: (controller) {
        if (controller.isloading) {
          return Scaffold(
            backgroundColor: _bg,
            body: const Center(
              child: CircularProgressIndicator(color: _primary),
            ),
          );
        }

        if (controller.inventory.isEmpty) {
          return Scaffold(
            backgroundColor: _bg,
            appBar: AppBar(
              title: const Text('المخزن'),
              centerTitle: true,
              backgroundColor: _primary,
              foregroundColor: const Color.fromARGB(255, 14, 12, 12),
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.inventory_2_outlined,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بيانات في المخزن',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            title: const Text(
              'المخزن',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Column(
            children: [
              if (controller.disinctSizes.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  color: _primary,
                  child: SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.disinctSizes.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final sizes = ['All', ...controller.disinctSizes];
                        final size = sizes[index];
                        final isSelected = _selectedSize == size;

                        return ChoiceChip(
                          label: Text(size),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => _selectedSize = size);
                            controller.filterBySize(size);
                          },
                          backgroundColor: Colors.white.withOpacity(0.15),
                          selectedColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? const Color.fromARGB(255, 228, 15, 15) : const Color.fromARGB(255, 1, 1, 1),
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          showCheckmark: false,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        );
                      },
                    ),
                  ),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.inventory.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = controller.inventory[index];
                    final imageUrl = item.item?.images != null &&
                            item.item!.images!.length > 1
                        ? item.item!.images[1].imageUrl
                        : null;
                    final imagesCount = item.item?.images.length ?? 0;

                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          final urls = item.item?.images
                                  .map((e) => e.imageUrl)
                                  .toList() ??
                              [];
                          if (urls.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ImageGalleryView(
                                  id: item.inventoryId,
                                  images: urls,
                                  title: item.description,
                                  price: item.sitePrice,
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        width: 92,
                                        height: 92,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, progress) {
                                          if (progress == null) return child;
                                          return Container(
                                            width: 92,
                                            height: 92,
                                            color: _bg,
                                            child: const Center(
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  color: _primary,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 92,
                                          height: 92,
                                          color: _bg,
                                          child: Icon(Icons.broken_image_outlined,
                                              color: Colors.grey.shade400),
                                        ),
                                      )
                                    : Container(
                                        width: 92,
                                        height: 92,
                                        color: _bg,
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey.shade400,
                                          size: 32,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.item?.sku ?? 'بدون SKU',
                                      style: const TextStyle(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1F2937),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    _InfoRow(
                                      icon: Icons.straighten_outlined,
                                      label:
                                          'المقاس: ${item.size?.description ?? "غير محدد"}',
                                    ),
                                    const SizedBox(height: 6),
                                    _InfoRow(
                                      icon: Icons.photo_library_outlined,
                                      label: 'الصور: $imagesCount',
                                    ),
                                    if (item.sitePrice != null) ...[
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _primaryLight.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '${item.sitePrice}',
                                          style: const TextStyle(
                                            color: _primary,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  size: 14, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}