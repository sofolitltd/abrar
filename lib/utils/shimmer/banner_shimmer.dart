import 'package:flutter/material.dart';

import '/utils/shimmer/shimmer_effect.dart';

class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),

          //
          KShimmerEffect(height: 200, width: double.maxFinite, radius: 16),

          //
          SizedBox(height: 8),

          //
          KShimmerEffect(height: 14, width: 100, radius: 16),

          SizedBox(height: 4),
        ],
      ),
    );
  }
}
