import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/models/brand_model.dart';
import '/providers/brand_providers.dart';
import '/routes/app_route.dart';
import '../../../routes/router_config.dart';

class FeaturedBrandSection extends ConsumerWidget {
  const FeaturedBrandSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBrands = ref.watch(featuredBrandsProvider);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Brands',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoute.brands.path),
                  child: const Text('See More'),
                ),
              ],
            ),
          ),
          asyncBrands.when(
            data: (brands) {
              if (brands.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No brands found'),
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: brands.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (_, i) => BrandItem(brand: brands[i]),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
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

class BrandItem extends StatelessWidget {
  final BrandModel brand;
  const BrandItem({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          AppRoute.products.path,
          extra: ProductsPageParams(brand: brand.name),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60, // slightly bigger than image for border
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey, // border color
                width: .5, // border thickness
              ),
            ),
            child: ClipOval(
              child: Image.network(
                brand.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Text(
                      brand.name.isNotEmpty ? brand.name.toUpperCase() : '?',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            brand.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
