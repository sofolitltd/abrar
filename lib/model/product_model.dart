import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double regularPrice;
  final double salePrice;
  final int stock;
  final List<String> imageUrls;
  final List<String> categories;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.salePrice,
    required this.stock,
    required this.imageUrls,
    required this.categories,
  });

  factory ProductModel.fromJson(QueryDocumentSnapshot json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      regularPrice: json['regularPrice'].toDouble(),
      salePrice: json['salePrice'].toDouble(),
      stock: json['stock'],
      imageUrls: List<String>.from(json['imageUrls']),
      categories: List<String>.from(json['categories']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'regularPrice': regularPrice,
      'salePrice': salePrice,
      'stock': stock,
      'imageUrls': imageUrls,
      'categories': categories,
    };
  }
}
