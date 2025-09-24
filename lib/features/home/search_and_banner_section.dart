import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '/providers/banner_provider.dart';
import '/utils/shimmer/banner_shimmer.dart';
import '../search/search_page.dart';
import '../widgets/image_carousal.dart';

class SearchAndBannerSection extends ConsumerWidget {
  const SearchAndBannerSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannersAsync = ref.watch(bannersStreamProvider);

    return Column(
      children: [
        // 🔎 Search Box
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchPage()),
          ),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Iconsax.search_favorite,
                    size: 20,
                    color: Colors.black54,
                  ),
                  SizedBox(width: 12),
                  Text('Search product ...', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
        ),

        // 🖼️ Banner Section
        bannersAsync.when(
          data: (banners) {
            if (banners.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Text('No banners found'),
              );
            }
            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: ImageCarousel(images: banners),
            );
          },
          loading: () => const BannerShimmer(),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Error: $e'),
          ),
        ),
      ],
    );
  }
}
