import 'package:flutter/material.dart';

import '/utils/shimmer/shimmer_effect.dart';

class FeaturedBrandShimmer extends StatelessWidget {
  const FeaturedBrandShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Circle shimmer for image
                KShimmerEffect(height: 64, width: 48, radius: 100),

                const SizedBox(width: 12),

                // Name shimmer
                KShimmerEffect(height: 24, width: 72, radius: 4),

                const SizedBox(width: 12),
              ],
            ),
          );
        },
      ),
    );
  }
}
