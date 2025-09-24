import 'package:flutter/material.dart';

import '/utils/shimmer/shimmer_effect.dart';

class FeaturedCategoryShimmer extends StatelessWidget {
  const FeaturedCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),

        itemCount: 6,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return KShimmerEffect(height: 88, width: 88, radius: 10);
        },
      ),
    );
  }
}
