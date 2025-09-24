import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/providers/cart_provider.dart';
import '/utils/constants/constants.dart';
import '/utils/k_text.dart';
import '../../routes/app_route.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(centerTitle: false, title: const Text('Cart')),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.black12,
                  child: Icon(
                    Iconsax.shopping_bag,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('No product found!'),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 200),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go(AppRoute.shop.path);
                    },
                    icon: const Icon(Iconsax.shop, size: 16),
                    label: const Text('Continue Shopping'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Cart'),
        actions: [
          //todo: for admin app
          // IconButton(
          //   onPressed: () async {
          //     try {
          //       final docRef = FirebaseFirestore.instance.collection(
          //         'deliveryCharges',
          //       );
          //
          //       var id = docRef.doc().id;
          //       DeliveryChargeModel deliveryCharge = DeliveryChargeModel(
          //         id: id,
          //         title: 'Flat Rate',
          //         district: '',
          //         deliveryFee: 100,
          //         minDays: 3,
          //         maxDays: 5,
          //       );
          //       await docRef.doc(id).set(deliveryCharge.toMap());
          //
          //       print('✅ DeliveryCharge uploaded: ${deliveryCharge.title}');
          //     } catch (e) {
          //       print('❌ Failed to upload DeliveryCharge: $e');
          //     }
          //   },
          //   icon: Icon(Icons.add),
          // ),
        ],
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 5),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: cartItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = cartItems[index];

            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: item.imageUrl.isNotEmpty
                            ? NetworkImage(item.imageUrl)
                            : const AssetImage('assets/images/no_image.png')
                                  as ImageProvider,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 72),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: KText(
                                  item.name,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontSize: 18, height: 1.3),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () =>
                                    cartNotifier.removeFromCart(item.id),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  textBaseline: TextBaseline.ideographic,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  children: [
                                    Text(
                                      (item.price * item.quantity)
                                          .toStringAsFixed(0),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '(${item.price.toStringAsFixed(0)} x ${item.quantity})',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        cartNotifier.decreaseQuantity(item.id),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(2),
                                      child: const Icon(Iconsax.minus),
                                    ),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(
                                      minWidth: 32,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.quantity}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        cartNotifier.increaseQuantity(item.id),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.all(2),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        margin: cartItems.isNotEmpty
            ? const EdgeInsets.only(top: 8, bottom: 8)
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (cartItems.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Item: ${cartNotifier.totalQuantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Total Price: $kTkSymbol ${cartNotifier.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) {
                      context.push(
                        AppRoute.login.path,
                        extra: AppRoute.cart.path,
                      );
                    } else {
                      context.push(AppRoute.checkout.path);
                    }
                  },
                  child: const Text('Checkout'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
