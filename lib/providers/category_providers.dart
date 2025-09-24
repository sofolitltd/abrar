import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/category_model.dart';
import '../repositories/category_repository.dart';

/// Repository singleton
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository();
});

/// Featured categories stream for home
final featuredCategoriesStreamProvider =
    StreamProvider.autoDispose<List<CategoryModel>>((ref) {
      final repo = ref.watch(categoryRepositoryProvider);
      return repo.watchFeaturedCategories(limit: 12);
    });

/// parent categories
final parentCategoriesStreamProvider =
    StreamProvider.autoDispose<List<CategoryModel>>((ref) {
      final repo = ref.watch(categoryRepositoryProvider);
      return repo.watchParentCategories();
    });

/// sub categories
final subCategoriesStreamProvider = StreamProvider.family
    .autoDispose<List<CategoryModel>, String>((ref, parentId) {
      final repo = ref.watch(categoryRepositoryProvider);
      return repo.watchSubCategories(parentId);
    });
