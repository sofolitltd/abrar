import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/providers/cart_provider.dart';
import '/utils/constants/constants.dart';
import '/utils/k_text.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../../routes/app_route.dart';
import '../cart/cart_page.dart';
import '../widgets/image_section.dart';

class ProductsDetails extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductsDetails({super.key, required this.product});

  @override
  ConsumerState<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends ConsumerState<ProductsDetails> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    // Initialize quantity if product already in cart
    final cartItems = ref.read(cartProvider);
    final existing = cartItems.firstWhere(
      (e) => e.id == widget.product.id,
      orElse: () => CartItemModel(
        id: '',
        name: '',
        price: 0,
        imageUrl: '',
        quantity: 1,
        stock: widget.product.stock,
      ),
    );

    if (existing.id != '') {
      quantity = existing.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final cartItems = ref.watch(cartProvider);

    final inCart = cartItems.any((e) => e.id == widget.product.id);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: KText(widget.product.name, style: const TextStyle(fontSize: 17)),
        actions: [
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
                icon: const Icon(Iconsax.shopping_bag, size: 16),
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
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 8,
          children: [
            //
            ImageSection(images: widget.product.images),

            //
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //
                  KText(
                    widget.product.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price & Stock
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.black12.withValues(alpha: .05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Special Price',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$kTkSymbol ${widget.product.salePrice.toStringAsFixed(0)}',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      fontSize: 20,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12.withValues(alpha: .05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Regular:',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall!.copyWith(height: 1),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '$kTkSymbol ${widget.product.regularPrice.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                          color: Colors.black87,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black12.withValues(alpha: .05),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(
                                    'Status:',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(height: 1.1),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.product.stock != 0
                                        ? 'In Stock (${widget.product.stock})'
                                        : 'Out of Stock',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                          color: widget.product.stock != 0
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // quantity, Add to Cart & Buy Now
                  if (widget.product.stock != 0) ...[
                    // Quantity Selector
                    Column(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                  if (inCart) {
                                    cartNotifier.setQuantity(
                                      widget.product.id,
                                      quantity,
                                    );
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Iconsax.minus),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(minWidth: 48),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                '$quantity',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (quantity < widget.product.stock) {
                                  setState(() => quantity++);
                                  if (inCart) {
                                    cartNotifier.setQuantity(
                                      widget.product.id,
                                      quantity,
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Reached maximum stock'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Iconsax.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              cartNotifier.addToCart(
                                CartItemModel(
                                  id: widget.product.id,
                                  name: widget.product.name,
                                  price: widget.product.salePrice,
                                  imageUrl: widget.product.images.isNotEmpty
                                      ? widget.product.images[0]
                                      : '',
                                  quantity: quantity,
                                  stock: widget.product.stock,
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Added to cart'),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1),
                                ),
                              );

                              // reset quantity
                              setState(() => quantity = 1);
                            },
                            icon: const Icon(Iconsax.shopping_bag),
                            label: Text(inCart ? 'Add More' : 'Add to Cart'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                            ),
                            onPressed: () {
                              if (!inCart) {
                                cartNotifier.addToCart(
                                  CartItemModel(
                                    id: widget.product.id,
                                    name: widget.product.name,
                                    price: widget.product.salePrice,
                                    imageUrl: widget.product.images.isNotEmpty
                                        ? widget.product.images[0]
                                        : '',
                                    quantity: quantity,
                                    stock: widget.product.stock,
                                  ),
                                );
                              }

                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                // Navigate to login -> checkout
                                context.push(
                                  AppRoute.login.path,
                                  extra: AppRoute.cart.path,
                                );
                              } else {
                                // Navigate to checkout
                                context.push(AppRoute.checkout.path);
                              }
                            },
                            child: const Text('Buy Now'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),

            //
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Description
                  Text(
                    'Product Description',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  KText(
                    widget.product.description.isEmpty
                        ? '${widget.product.name}, Special Price: ${widget.product.salePrice.toStringAsFixed(0)}, Regular Price: ${widget.product.regularPrice.toStringAsFixed(0)}'
                        : widget.product.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium!.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            //
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
