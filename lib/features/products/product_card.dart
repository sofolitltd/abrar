import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/models/cart_model.dart';
import '/providers/cart_provider.dart';
import '/utils/constants/constants.dart';
import '/utils/k_text.dart';
import '../../models/product_model.dart';
import '../../routes/app_route.dart';

class ProductCard extends ConsumerWidget {
  final ProductModel product;
  final double width;
  const ProductCard({super.key, required this.product, this.width = 170});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider); // 👈 watch cart state
    final cartNotifier = ref.read(cartProvider.notifier);

    final bool isInCart = cartState.any((item) => item.id == product.id);

    return GestureDetector(
      onTap: () {
        // go route
        context.push(AppRoute.productDetails.path, extra: product);
      },
      child: Stack(
        children: [
          //
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withValues(alpha: 0.05),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Product image
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: const Border(
                        bottom: BorderSide(color: Colors.black12),
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      color: Colors.grey.shade100,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: product.images.isNotEmpty
                            ? CachedNetworkImageProvider(product.images[0])
                            : const AssetImage('assets/images/no_image.png')
                                  as ImageProvider,
                      ),
                    ),
                  ),
                ),

                // Product info
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                        child: KText(
                          product.name,
                          maxLines: 2,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(height: 1.3),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '$kTkSymbol${product.salePrice.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$kTkSymbol${product.regularPrice.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🛒 Cart icon button
          if (product.stock != 0)
            Positioned(
              bottom: 12,
              right: 10,
              child: InkWell(
                onTap: () {
                  final cartItem = CartItemModel(
                    id: product.id,
                    name: product.name,
                    price: product.salePrice,
                    imageUrl: product.images.isNotEmpty
                        ? product.images[0]
                        : '',
                    quantity: 1,
                    stock: product.stock,
                  );

                  // toggle item in cart
                  if (isInCart) {
                    cartNotifier.removeFromCart(product.id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Item removed from cart'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    cartNotifier.addToCart(cartItem);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Item added to cart'),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isInCart ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isInCart ? Colors.transparent : Colors.black38,
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    isInCart ? Iconsax.shopping_bag5 : Iconsax.shopping_bag,
                    size: 18,
                    color: isInCart ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
