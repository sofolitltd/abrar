// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '/providers/product_providers.dart';
// import '/repositories/product_repository.dart';
// import '../../../../models/product_model.dart';
//
// class ProductPaginationNotifier extends AsyncNotifier<List<ProductModel>> {
//   final int limit = 16;
//   final List<DocumentSnapshot> _lastDocs = [];
//   int _currentPage = 0;
//   int totalPages = 0;
//   int totalProducts = 0;
//
//   String _sortBy = 'Latest Items';
//   bool _descending = true;
//
//   String? _category;
//   String? _subCategory;
//   String? _brand;
//   bool? _isFeatured;
//
//   ProductRepository get repo => ref.read(productRepositoryProvider);
//   int get currentPage => _currentPage;
//   String get sortBy => _sortBy;
//
//   @override
//   Future<List<ProductModel>> build() async {
//     // Total products with current filter
//     totalProducts = await repo.getTotalProducts(
//       category: _category,
//       subCategory: _subCategory,
//       brand: _brand,
//       isFeatured: _isFeatured,
//     );
//     totalPages = (totalProducts / limit).ceil();
//     return fetchPage(1);
//   }
//
//   Future<List<ProductModel>> fetchPage(int page) async {
//     try {
//       state = const AsyncLoading(); // show loader while fetching
//
//       // Indicate loading
//       if (state.asData?.value == null) {
//         state = const AsyncValue.loading();
//       } else {
//         state = AsyncValue.data(state.asData!.value);
//       }
//
//       DocumentSnapshot? startAfter;
//       if (page > 1 && _lastDocs.length >= page - 1) {
//         startAfter = _lastDocs[page - 2];
//       }
//
//       final result = await repo.fetchProducts(
//         limit: limit,
//         startAfter: startAfter,
//         sortBy: _sortBy,
//         descending: _descending,
//         category: _category,
//         subCategory: _subCategory,
//         brand: _brand,
//         isFeatured: _isFeatured,
//       );
//
//       final products = result['products'] as List<ProductModel>;
//       final lastDoc = result['lastDoc'] as DocumentSnapshot?;
//
//       if (lastDoc != null && _lastDocs.length < page) _lastDocs.add(lastDoc);
//
//       _currentPage = page;
//       state = AsyncValue.data(products);
//       return products;
//     } catch (e, st) {
//       state = AsyncValue.error(e, st);
//       return [];
//     }
//   }
//
//   // Navigation
//   Future<void> next() async => fetchPage(_currentPage + 1);
//   Future<void> prev() async =>
//       _currentPage > 1 ? fetchPage(_currentPage - 1) : null;
//   Future<void> goTo(int page) async => fetchPage(page);
//
//   // Set sort and refresh
//   Future<void> setSort(String value) async {
//     _sortBy = value;
//     _descending = (value == 'High to Low' || value == 'Latest Items');
//     _lastDocs.clear();
//     await fetchPage(1);
//   }
//
//   // Set filters and refresh
//   Future<void> setFilter({
//     String? category,
//     String? subCategory,
//     String? brand,
//     bool? isFeatured,
//     String? sortBy,
//   }) async {
//     _category = category;
//     _subCategory = subCategory;
//     _brand = brand;
//     _isFeatured = isFeatured;
//     _sortBy = sortBy ?? 'createdDate';
//     _descending = (_sortBy == 'High to Low' || _sortBy == 'Latest Items');
//
//     _lastDocs.clear();
//
//     // Clear old data first
//     totalProducts = 0;
//     state = const AsyncLoading();
//
//     // Recalculate total pages based on new filter
//     totalProducts = await repo.getTotalProducts(
//       category: _category,
//       subCategory: _subCategory,
//       brand: _brand,
//       isFeatured: _isFeatured,
//     );
//     totalPages = (totalProducts / limit).ceil();
//
//     await fetchPage(1);
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/models/product_model.dart';
import '/providers/product_providers.dart';
import '/repositories/product_repository.dart';

class ProductPaginationNotifier extends AsyncNotifier<List<ProductModel>> {
  final int limit = 12;

  final List<ProductModel> _allProducts = [];
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  int _totalProducts = 0;

  String _sortBy = 'Latest Items';
  bool _descending = true;

  String? _category;
  String? _subCategory;
  String? _brand;
  bool? _isFeatured;

  ProductRepository get repo => ref.read(productRepositoryProvider);

  String get sortBy => _sortBy;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;
  int get totalProducts => _totalProducts;

  @override
  Future<List<ProductModel>> build() async {
    return _loadInitial();
  }

  Future<List<ProductModel>> _loadInitial() async {
    // Reset everything
    _allProducts.clear();
    _lastDoc = null;
    _hasMore = true;
    _isLoadingMore = false;
    state = const AsyncValue.loading();

    // Fetch total count first
    _totalProducts = await repo.getTotalProducts(
      category: _category,
      subCategory: _subCategory,
      brand: _brand,
      isFeatured: _isFeatured,
    );

    return _fetch();
  }

  Future<List<ProductModel>> _fetch() async {
    if (!_hasMore || _isLoadingMore) return _allProducts;

    _isLoadingMore = true;

    try {
      final result = await repo.fetchProducts(
        limit: limit,
        startAfter: _lastDoc,
        sortBy: _sortBy,
        descending: _descending,
        category: _category,
        subCategory: _subCategory,
        brand: _brand,
        isFeatured: _isFeatured,
      );

      final products = result['products'] as List<ProductModel>;
      final lastDoc = result['lastDoc'] as DocumentSnapshot?;

      if (products.isEmpty) {
        _hasMore = false;
      } else {
        _allProducts.addAll(products);
        _lastDoc = lastDoc;
      }

      state = AsyncValue.data(List<ProductModel>.from(_allProducts));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }

    _isLoadingMore = false;
    return _allProducts;
  }

  Future<void> fetchNext() async {
    await _fetch();
  }

  Future<void> setSort(String value) async {
    _sortBy = value;
    _descending = (value == 'High to Low' || value == 'Latest Items');
    await _loadInitial();
  }

  Future<void> setFilter({
    String? category,
    String? subCategory,
    String? brand,
    bool? isFeatured,
    String? sortBy,
  }) async {
    _category = category;
    _subCategory = subCategory;
    _brand = brand;
    _isFeatured = isFeatured;
    if (sortBy != null) _sortBy = sortBy;
    _descending = (_sortBy == 'High to Low' || _sortBy == 'Latest Items');

    _totalProducts = 0;
    await _loadInitial();
  }
}
