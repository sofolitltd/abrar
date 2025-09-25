import 'package:abrar/features/products/product_card.dart';
import 'package:abrar/utils/shimmer/products_grid_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '/providers/cart_provider.dart';
import '/providers/product_providers.dart';
import '../cart/cart_page.dart';

class ProductsPage extends ConsumerStatefulWidget {
  final String? category;
  final String? subCategory;
  final String? brand;
  final bool? isFeatured;
  final String? sortBy;

  const ProductsPage({
    super.key,
    this.category,
    this.subCategory,
    this.brand,
    this.isFeatured,
    this.sortBy = 'Latest Items',
  });

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //
      ref
          .read(productPaginationProvider.notifier)
          .setFilter(
            category: widget.category,
            subCategory: widget.subCategory,
            brand: widget.brand,
            isFeatured: widget.isFeatured,
            sortBy: widget.sortBy,
          );
    });

    //
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(productPaginationProvider.notifier).fetchNext();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncProducts = ref.watch(productPaginationProvider);
    final notifier = ref.watch(productPaginationProvider.notifier);
    final cartItems = ref.watch(cartProvider);

    final isLoading = asyncProducts.isLoading;

    // Safe title
    final String appBarTitle = widget.category?.isNotEmpty == true
        ? widget.category!
        : widget.subCategory?.isNotEmpty == true
        ? widget.subCategory!
        : widget.brand?.isNotEmpty == true
        ? widget.brand!
        : widget.isFeatured == true
        ? 'Featured Products'
        : (widget.sortBy == 'Latest Items' ? 'Latest Products' : 'Products');

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(appBarTitle),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton.filledTonal(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const CartPage()));
                },
                icon: const Icon(Iconsax.shopping_cart, size: 18),
              ),

              //
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 2,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      '${cartItems.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        spacing: 8,
        children: [
          // -------- Sort menu --------
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            margin: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 12, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //
                  Text(
                    'Total: ${notifier.totalProducts}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(height: 1.6),
                  ),

                  Spacer(),
                  //
                  Text(
                    'Sort by:',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      color: Colors.black12.withValues(alpha: .05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        isDense: true,
                        isExpanded: true,
                        underline: const SizedBox(),
                        value: notifier.sortBy,
                        items:
                            const [
                              'Name',
                              'Latest Items',
                              'Low to High',
                              'High to Low',
                            ].map((menu) {
                              return DropdownMenuItem(
                                value: menu,
                                child: Text(menu),
                              );
                            }).toList(),
                        onChanged: (val) {
                          if (val != null) notifier.setSort(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ------------- products -------------
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: asyncProducts.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                    // ✅ Add +1 item if we still have more to load
                    itemCount: products.length + (notifier.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // ✅ Last item shows a loader
                      if (index >= products.length) {
                        return Center(child: CupertinoActivityIndicator());
                      }

                      final product = products[index];
                      return ProductCard(
                        product: product,
                        width: double.infinity,
                      );
                    },
                  );
                },
                loading: () => const Center(child: ProductsGridShimmer()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
          ),

          SizedBox(),
        ],
      ),
    );
  }

  //
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
