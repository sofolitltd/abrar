import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductRepository {
  final _db = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchAllProducts() async {
    final snapshot = await _db.collection('products').get();
    return snapshot.docs.map((e) => ProductModel.fromQuerySnapshot(e)).toList();
  }

  Future<Map<String, dynamic>> fetchProducts({
    int limit = 16,
    DocumentSnapshot? startAfter,
    String sortBy = 'createdDate',
    bool descending = true,
    String? category,
    String? subCategory,
    String? brand,
    bool? isFeatured,
  }) async {
    Query query = _db.collection('products');

    // Apply filters
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }
    if (subCategory != null) {
      query = query.where('subCategory', isEqualTo: subCategory);
    }
    if (brand != null) query = query.where('brand', isEqualTo: brand);

    if (isFeatured != null) {
      query = query.where('isFeatured', isEqualTo: isFeatured);
    }

    // Sorting
    switch (sortBy) {
      case 'Name':
        query = query.orderBy('name', descending: descending);
        break;
      case 'Low to High':
        query = query.orderBy('salePrice', descending: false);
        break;
      case 'High to Low':
        query = query.orderBy('salePrice', descending: true);
        break;
      case 'Latest Items':
        query = query.orderBy('createdDate', descending: true);
        break;

      default:
        query = query.orderBy('createdDate', descending: true);
    }

    query = query.limit(limit);
    if (startAfter != null) query = query.startAfterDocument(startAfter);

    final snapshot = await query.get();
    final products = snapshot.docs
        .map((doc) => ProductModel.fromQuerySnapshot(doc))
        .toList();
    final lastDoc = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

    return {'products': products, 'lastDoc': lastDoc};
  }

  /// Get total number of products
  Future<int> getTotalProducts({
    String? category,
    String? subCategory,
    String? brand,
    bool? isFeatured,
  }) async {
    Query query = _db.collection('products');
    if (category != null) query = query.where('category', isEqualTo: category);
    if (subCategory != null) {
      query = query.where('subCategory', isEqualTo: subCategory);
    }
    if (brand != null) query = query.where('brand', isEqualTo: brand);
    if (isFeatured != null) {
      query = query.where('isFeatured', isEqualTo: isFeatured);
    }

    final countSnap = await query.count().get();
    return countSnap.count ?? 0;
  }
}
