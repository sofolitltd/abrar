import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/brand_providers.dart';
import 'widgets/featured_brands_section.dart';

class AllBrandsPage extends ConsumerWidget {
  const AllBrandsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBrands = ref.watch(allBrandsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Brands')),
      body: Container(
        margin: EdgeInsets.only(top: 8, bottom: 8),
        color: Colors.white,
        child: asyncBrands.when(
          data: (brands) {
            if (brands.isEmpty) {
              return const Center(child: Text('No brands found'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: brands.length,
              itemBuilder: (_, i) => BrandItem(brand: brands[i]),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}
