import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/banner_model.dart';

class BannerRepository {
  final _db = FirebaseFirestore.instance;

  /// Stream of banners ordered by index
  Stream<List<BannerModel>> watchBanners() {
    return _db
        .collection('banners')
        .orderBy('index')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => BannerModel.fromJson(doc)).toList(),
        );
  }
}
