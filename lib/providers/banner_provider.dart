import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/banner_model.dart';
import '../repositories/banner_repository.dart';

/// Repository provider (singleton)
final bannerRepositoryProvider = Provider<BannerRepository>((ref) {
  return BannerRepository();
});

/// Stream provider of banners
final bannersStreamProvider = StreamProvider<List<BannerModel>>((ref) {
  return ref.watch(bannerRepositoryProvider).watchBanners();
});
