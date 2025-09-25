import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/providers/category_providers.dart';
import '/routes/app_route.dart';
import '/utils/shimmer/featured_category_shimmer.dart';
import '../../../providers/product_providers.dart';

class FeaturedCategoriesSection extends ConsumerWidget {
  const FeaturedCategoriesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredCategoriesStreamProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Text(
                  'Featured Categories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                //
                TextButton(
                  onPressed: () {
                    context.push(AppRoute.categories.path);
                  },
                  child: const Text('See All'),
                ),
              ],
            ),
          ),

          // Data
          featuredAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No categories found'),
                );
              }

              return SizedBox(
                height: 88,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        // Check if this category is a parent or subcategory
                        final bool isParent = category.parentId.isEmpty;

                        //
                        final notifier = ProviderScope.containerOf(
                          context,
                        ).read(productPaginationProvider.notifier);
                        notifier.setFilter(
                          category: isParent ? category.name : null,
                          subCategory: isParent ? null : category.name,
                          brand: null,
                          isFeatured: null,
                          sortBy: null,
                        );

                        //
                        context.push(
                          AppRoute.products.path,
                          extra: ProductsPageParams(
                            category: isParent ? category.name : null,
                            subCategory: isParent ? null : category.name,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          // Image
                          Container(
                            height: 88,
                            width: 88,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: category.imageUrl.isNotEmpty
                                    ? CachedNetworkImageProvider(
                                        category.imageUrl,
                                      )
                                    : const AssetImage(
                                            'assets/images/no_image.png',
                                          )
                                          as ImageProvider,
                              ),
                            ),
                          ),

                          // Overlay + Name
                          Container(
                            height: 88,
                            width: 88,
                            padding: EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black38.withValues(alpha: .3),
                            ),
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                height: 1.2,
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
            loading: () => const FeaturedCategoryShimmer(),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $e'),
            ),
          ),
        ],
      ),
    );
  }
}
