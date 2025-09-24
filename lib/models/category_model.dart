import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final String imageUrl;
  final String parentId;
  final bool isFeatured;
  final Timestamp createdDate;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.parentId,
    required this.isFeatured,
    required this.createdDate,
  });

  factory CategoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      slug: data['slug'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      parentId: data['parentId'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      createdDate: data['createdDate'] ?? Timestamp.now(),
    );
  }
}
