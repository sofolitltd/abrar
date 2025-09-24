import 'package:abrar/features/products/product_card.dart';
import 'package:abrar/utils/shimmer/products_grid_shimmer.dart';
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
    //Trigger only ONCE when the page is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                icon: const Icon(Iconsax.shopping_bag, size: 18),
              ),

              //
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          spacing: 8,
          children: [
            // -------- Sort menu (unchanged look) --------
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.only(top: 8),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    Text(
                      'Total(${notifier.totalProducts})',
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

            // -------- Product Grid --------
            asyncProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return Container(
                  color: Colors.white,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        width: double.infinity,
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: ProductsGridShimmer()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),

            // -------- Pagination Buttons --------
            ?asyncProducts.isLoading
                ? null
                : Consumer(
                    builder: (context, ref, _) {
                      final n = ref.watch(productPaginationProvider.notifier);
                      final totalPages = n.totalPages;
                      final currentPage = n.currentPage;
                      if (totalPages <= 1) return const SizedBox();

                      return Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 12,
                        ),
                        child: Column(
                          children: [
                            //
                            Row(
                              spacing: 4,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                IconButton(
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                      vertical: -3,
                                      horizontal: -3,
                                    ),
                                    backgroundColor: currentPage > 1
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    foregroundColor: currentPage > 1
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed: currentPage > 1 && !isLoading
                                      ? () async {
                                          await n.prev(); // wait for page data
                                          _scrollToTop();
                                        }
                                      : null,

                                  icon: const Icon(Icons.chevron_left),
                                ),

                                Expanded(
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      //
                                      ...List.generate(totalPages, (i) {
                                        final page = i + 1;
                                        return ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                              vertical: -3,
                                              horizontal: -3,
                                            ),
                                            backgroundColor: page == currentPage
                                                ? Colors.blue
                                                : Colors.grey.shade300,
                                            foregroundColor: page == currentPage
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          onPressed: isLoading
                                              ? null
                                              : () async {
                                                  await n.goTo(page);
                                                  _scrollToTop();
                                                },
                                          child: Text('$page'),
                                        );
                                      }),
                                    ],
                                  ),
                                ),

                                //
                                IconButton(
                                  style: IconButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                      vertical: -3,
                                      horizontal: -3,
                                    ),
                                    backgroundColor: currentPage < totalPages
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                    foregroundColor: currentPage < totalPages
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  onPressed:
                                      currentPage < totalPages && !isLoading
                                      ? () async {
                                          await n.next();
                                          _scrollToTop();
                                        }
                                      : null,
                                  icon: const Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

            SizedBox(),
          ],
        ),
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
