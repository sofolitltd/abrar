import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/brand_model.dart';
import '../repositories/brand_repository.dart';

final brandRepoProvider = Provider((_) => BrandRepository());

/// Featured brands stream
final featuredBrandsProvider = StreamProvider<List<BrandModel>>((ref) {
  return ref.watch(brandRepoProvider).featuredBrands(limit: 8);
});

/// All brands stream
final allBrandsProvider = StreamProvider<List<BrandModel>>((ref) {
  return ref.watch(brandRepoProvider).allBrands();
});
