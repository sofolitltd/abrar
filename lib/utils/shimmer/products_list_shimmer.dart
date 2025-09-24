import 'package:flutter/material.dart';

import '/utils/shimmer/shimmer_effect.dart';

class ProductsListShimmer extends StatelessWidget {
  const ProductsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 295,
      child: ListView.separated(
        separatorBuilder: (_, __) => SizedBox(width: 16),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          //
          return Container(
            width: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              children: [
                // image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blueAccent.shade100.withValues(alpha: .5),
                    ),
                    child: const KShimmerEffect(
                      height: 300,
                      width: 300,
                      radius: 8,
                    ),
                  ),
                ),

                // name
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      KShimmerEffect(height: 42, width: 300, radius: 6),

                      SizedBox(height: 8),

                      // price, add to cart
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.ideographic,
                        children: [
                          //
                          KShimmerEffect(height: 28, width: 64, radius: 8),

                          //
                          KShimmerEffect(height: 28, width: 28, radius: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
