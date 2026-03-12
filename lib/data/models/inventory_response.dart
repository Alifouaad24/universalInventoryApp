class InventoryModel {
  final int inventoryId;
  final int? platformId;
  final int? sizeId;
  final String? description;
  final String? sitePrice;
  final int? itemId;
  final PlatformModel? platform;
  final SizeModel? size;
  final ItemModel? item;

  InventoryModel({
    required this.inventoryId,
    this.platformId,
    this.sizeId,
    this.itemId,
    this.platform,
    this.size,
    this.item,
    this.description,
    this.sitePrice,
  });

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      inventoryId: json['inventory_id'],
      platformId: json['platform_id'],
      sizeId: json['size_id'],
      description: json['product_description'] ?? '',
      sitePrice: json['sitePrice'] ?? '',
      itemId: json['itemId'],
      platform: json['platform'] != null
          ? PlatformModel.fromJson(json['platform'])
          : null,
      size: json['size'] != null ? SizeModel.fromJson(json['size']) : null,
      item: json['item'] != null ? ItemModel.fromJson(json['item']) : null,
    );
  }
}

class PlatformModel {
  final int platformId;
  final String description;
  final String productUrl;

  PlatformModel({
    required this.platformId,
    required this.description,
    required this.productUrl,
  });

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      platformId: json['platform_id'],
      description: json['description'],
      productUrl: json['productUrl'],
    );
  }
}

class SizeModel {
  final int sizeId;
  final String description;

  SizeModel({
    required this.sizeId,
    required this.description,
  });

  factory SizeModel.fromJson(Map<String, dynamic> json) {
    return SizeModel(
      sizeId: json['size_id'],
      description: json['description'],
    );
  }
}

class ItemModel {
  final int itemId;
  final String? sku;
  final List<ItemImageModel> images;

  ItemModel({
    required this.itemId,
    this.sku,
    required this.images,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      itemId: json['itemId'],
      sku: json['sku'],
      images: (json['images'] as List)
          .map((e) => ItemImageModel.fromJson(e))
          .toList(),
    );
  }
}

class ItemImageModel {
  final int itemImageId;
  final String imageUrl;
  final bool isMain;

  ItemImageModel({
    required this.itemImageId,
    required this.imageUrl,
    required this.isMain,
  });

  factory ItemImageModel.fromJson(Map<String, dynamic> json) {
    return ItemImageModel(
      itemImageId: json['itemImageId'],
      imageUrl: json['imageUrl'],
      isMain: json['isMain'],
    );
  }
}