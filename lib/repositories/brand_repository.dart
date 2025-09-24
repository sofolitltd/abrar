import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/brand_model.dart';

class BrandRepository {
  final _col = FirebaseFirestore.instance.collection('brands');

  /// Featured brands for home page
  Stream<List<BrandModel>> featuredBrands({int limit = 8}) {
    return _col
        .where('isFeatured', isEqualTo: true)
        .orderBy('name')
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map((d) => BrandModel.fromJson(d)).toList());
  }

  /// All brands
  Stream<List<BrandModel>> allBrands() {
    return _col
        .orderBy('name')
        .snapshots()
        .map((snap) => snap.docs.map((d) => BrandModel.fromJson(d)).toList());
  }
}
