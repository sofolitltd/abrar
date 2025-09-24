import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryRepository {
  final _db = FirebaseFirestore.instance;

  /// Stream of featured categories (real-time)
  Stream<List<CategoryModel>> watchFeaturedCategories({int limit = 12}) {
    return _db
        .collection('categories')
        .where('isFeatured', isEqualTo: true)
        // .orderBy('name')
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => CategoryModel.fromDoc(doc)).toList(),
        );
  }

  /// Stream of all parent categories
  Stream<List<CategoryModel>> watchParentCategories() {
    return _db
        .collection('categories')
        .where('parentId', isEqualTo: '')
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => CategoryModel.fromDoc(doc)).toList(),
        );
  }

  /// Stream of subcategories of a parent
  Stream<List<CategoryModel>> watchSubCategories(String parentId) {
    return _db
        .collection('categories')
        .where('parentId', isEqualTo: parentId)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => CategoryModel.fromDoc(doc)).toList(),
        );
  }
}
