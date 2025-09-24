import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

import '/providers/cart_provider.dart';
import '../../notification/notification_chip.dart';
import '../cart/cart_page.dart';
import 'search_and_banner_section.dart';
import 'widgets/featured_brands_section.dart';
import 'widgets/featured_categories_section.dart';
import 'widgets/featured_products_section.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    var userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text.rich(
          TextSpan(
            text: 'Abrar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
              fontSize: 24,
            ),
            children: [
              TextSpan(
                text: ' Shop',
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  color: Colors.black,
                  fontSize: 23,
                ),
              ),
            ],
          ),
        ),
        actions: [
          //
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

          const SizedBox(width: 2),

          //
          if (userId.isNotEmpty) NotificationIconButton(userId: userId),

          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: const [
            // 🔎 Search + banner
            SearchAndBannerSection(),
            // 🏷️ Featured categories
            FeaturedCategoriesSection(),
            // ⭐ Featured products
            FeaturedProductsSection(),
            // 🆕 Latest products
            LatestProductsSection(),
            // 🏢 Featured brands
            FeaturedBrandSection(),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
