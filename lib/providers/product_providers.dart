import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/product_model.dart';
import '/repositories/product_repository.dart';
import 'notifiers/product_pagination_notifier.dart';

// Provider to fetch all products once[search products - more memory intensive]
final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  final repo = ProductRepository();
  final snapshot = await repo.fetchAllProducts(); // fetch all
  return snapshot;
});

/// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Pagination notifier provider (new Riverpod style)
final productPaginationProvider =
    AsyncNotifierProvider<ProductPaginationNotifier, List<ProductModel>>(
      ProductPaginationNotifier.new,
    );

// // final product
// final featuredProductsProvider1 = FutureProvider<List<ProductModel>>((
//   ref,
// ) async {
//   final repo = ref.read(productRepositoryProvider);
//   return (await repo.fetchProducts(limit: 12, isFeatured: true))['products']
//       as List<ProductModel>;
// });
//
// // latest Product
// final latestProductsProvider1 = FutureProvider<List<ProductModel>>((ref) async {
//   final repo = ref.read(productRepositoryProvider);
//   return (await repo.fetchProducts(
//         limit: 12,
//         sortBy: 'Latest Items',
//       ))['products']
//       as List<ProductModel>;
// });

final featuredProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return repo.streamProducts(limit: 12, isFeatured: true);
});

final latestProductsProvider = StreamProvider<List<ProductModel>>((ref) {
  final repo = ref.read(productRepositoryProvider);
  return repo.streamProducts(limit: 12, sortBy: 'Latest Items');
});
