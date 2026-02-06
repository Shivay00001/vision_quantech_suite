class Product {
  final String id;
  final String name;
  final String sku;
  final String description;
  final double price;
  final int stockQuantity;
  final int minStockThreshold;
  final String organizationId;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.sku,
    required this.description,
    required this.price,
    required this.stockQuantity,
    this.minStockThreshold = 0,
    required this.organizationId,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? 'Unnamed',
      sku: json['sku'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: json['stock_quantity'] ?? 0,
       minStockThreshold: json['min_stock_threshold'] ?? 10,
      organizationId: json['organization_id'],
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sku': sku,
      'description': description,
      'price': price,
      'stock_quantity': stockQuantity,
      'min_stock_threshold': minStockThreshold,
    };
  }

  bool get needsRestock => stockQuantity <= minStockThreshold;
}
