class ProductModel {
  final String id;
  final String name;
  final String description;
  final double regularPrice;
  final double salePrice;
  final int stockQuantity;
  final List<String> images;
  final String category;
  final String brand;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.salePrice,
    required this.stockQuantity,
    required this.images,
    required this.category,
    required this.brand,
  });

  //from json
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        regularPrice: json['regularPrice'].toDouble(),
        salePrice: json['salePrice'].toDouble(),
        stockQuantity: json['stockQuantity'],
        images: List<String>.from(json['images']),
        category: json['category'],
        brand: json['brand'],
      );

  // to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'regularPrice': regularPrice,
        'salePrice': salePrice,
        'stockQuantity': stockQuantity,
        'images': images,
        'category': category,
        'brand': brand,
      };
}
