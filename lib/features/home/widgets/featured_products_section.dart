import 'package:abrar/routes/router_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/models/product_model.dart';
import '/providers/product_providers.dart';
import '/utils/shimmer/products_list_shimmer.dart';
import '../../../routes/app_route.dart';
import '../../products/product_card.dart';

/// ---------------- FEATURED PRODUCTS SECTION ----------------
class FeaturedProductsSection extends ConsumerWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(featuredProductsProvider);

    return ProductHorizontalSection(
      title: 'Featured Products',
      subtitle: 'Check and get your favorite products',
      asyncProducts: asyncProducts,
      seeMoreRoute: () {
        //
        context.push(
          AppRoute.products.path,
          extra: ProductsPageParams(isFeatured: true, sortBy: 'Latest Items'),
        );
      },
    );
  }
}

/// ---------------- LATEST PRODUCTS SECTION ----------------
class LatestProductsSection extends ConsumerWidget {
  const LatestProductsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(latestProductsProvider);

    return ProductHorizontalSection(
      title: 'Latest Products',
      subtitle: 'Newest items just for you',
      asyncProducts: asyncProducts,
      seeMoreRoute: () {
        //
        context.push(
          AppRoute.products.path,
          extra: ProductsPageParams(isFeatured: false, sortBy: 'Latest Items'),
        );
      },
    );
  }
}

/// ---------------- REUSABLE HORIZONTAL PRODUCT SECTION ----------------
class ProductHorizontalSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final AsyncValue<List<ProductModel>> asyncProducts;
  final VoidCallback seeMoreRoute;

  const ProductHorizontalSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.asyncProducts,
    required this.seeMoreRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: seeMoreRoute,
                  child: const Text('See More'),
                ),
              ],
            ),
          ),

          // Product list
          SizedBox(
            height: 300,
            child: asyncProducts.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return ListView.separated(
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                );
              },
              loading: () => const Center(child: ProductsListShimmer()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}
