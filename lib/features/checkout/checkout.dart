import 'package:abrar/notification/fcm_sender.dart';
import 'package:abrar/routes/app_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/bkash/bkash.dart';
import '/bkash/models/execute_payment_response.dart';
import '/models/address_model.dart';
import '/models/delivery_charge_model.dart';
import '/models/order_model.dart';
import '/providers/address_provider.dart';
import '/providers/cart_provider.dart';
import '/providers/checkout_provider.dart';
import '/providers/notifiers/delivery_notifier.dart';
import '/utils/constants/constants.dart';

class CheckOut extends ConsumerStatefulWidget {
  const CheckOut({super.key});

  @override
  ConsumerState<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends ConsumerState<CheckOut> {
  final promoController = TextEditingController();
  String paymentMethod = 'Bkash';
  String promo = '';
  String promoError = '';
  bool isPlacingOrder = false;

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final selectedAddress = ref.watch(selectedAddressProvider);
    final deliveryOptions = ref.watch(deliveryProvider);
    final selectedDelivery = ref.watch(selectedDeliveryProvider);
    final promoDiscount = ref.watch(promoNotifierProvider);

    final subtotal = ref.read(cartProvider.notifier).totalPrice;
    final deliveryFee = selectedDelivery?.deliveryFee.toDouble() ?? 0.0;
    final total = subtotal + deliveryFee - promoDiscount;

    // 🔹 Listen to address changes
    ref.listen<AddressModel?>(selectedAddressProvider, (prev, next) {
      if (next != null && deliveryOptions.isNotEmpty) {
        // Set delivery based on new district
        final defaultDelivery = deliveryOptions.firstWhere(
          (d) => d.district.toLowerCase() == next.district.toLowerCase(),
          orElse: () => deliveryOptions.first,
        );
        ref.read(selectedDeliveryProvider.notifier).set(defaultDelivery);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isPlacingOrder ? '' : "Checkout"),
        automaticallyImplyLeading: isPlacingOrder ? false : true,
      ),
      body: isPlacingOrder
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoActivityIndicator(radius: 20),

                    //
                    Text(
                      "Please don't close this page while payment is processing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              children: [
                const SizedBox(height: 8),

                // Address Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 4,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery Address',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                          ),
                          TextButton(
                            //
                            onPressed: () =>
                                context.push(AppRoute.address.path),
                            child: const Text('Change'),
                          ),
                        ],
                      ),

                      // ✅ Address Body
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (context, userSnap) {
                            if (!userSnap.hasData) {
                              return const Center(child: Text(''));
                            }

                            final userData =
                                userSnap.data!.data() as Map<String, dynamic>;
                            final defaultAddressId =
                                userData['defaultAddressId'];

                            // ❌ No defaultAddressId → Show Add Button
                            if (defaultAddressId == null ||
                                defaultAddressId.isEmpty) {
                              //
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text(
                                    'No Address Found. Please add one.',
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () =>
                                        context.push(AppRoute.address.path),
                                    child: const Text('Manage Address'),
                                  ),
                                ],
                              );
                            }

                            // ✅ Default address exists → Load and show
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser?.uid)
                                  .collection('address')
                                  .doc(defaultAddressId)
                                  .snapshots(),
                              builder: (context, addressSnap) {
                                if (!addressSnap.hasData) {
                                  return const Center(child: Text(''));
                                }
                                if (!addressSnap.data!.exists) {
                                  return const Text('Address not found.');
                                }

                                final address = AddressModel.fromMap(
                                  addressSnap.data!.data()
                                      as Map<String, dynamic>,
                                  addressSnap.data!.id,
                                );

                                // notifier riverpod

                                // ✅ Update Riverpod state
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  ref
                                      .read(selectedAddressProvider.notifier)
                                      .setAddress(address);
                                });

                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    if (address.tag != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          address.tag!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Iconsax.location),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                address.name.toUpperCase(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text('Mobile: ${address.mobile}'),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Address: ${address.addressLine}',
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'District: ${address.district}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Delivery charge
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 12,
                    children: [
                      Text(
                        'Delivery Charge',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      //
                      Consumer(
                        builder: (context, ref, child) {
                          final deliveryOptions = ref.watch(deliveryProvider);
                          final selectedDelivery = ref.watch(
                            selectedDeliveryProvider,
                          );
                          final userDistrict = ref
                              .watch(selectedAddressProvider)
                              ?.district;

                          if (deliveryOptions.isEmpty) {
                            return const Text('No delivery options available.');
                          }

                          // 🔹 Determine default selection
                          DeliveryChargeModel? defaultDelivery = deliveryOptions
                              .firstWhere(
                                (option) =>
                                    option.district.toLowerCase() ==
                                    userDistrict?.toLowerCase(),
                                orElse: () => deliveryOptions.firstWhere(
                                  (option) => option.district.isEmpty,
                                  orElse: () => deliveryOptions.first,
                                ),
                              );

                          // If no selection yet, set it automatically
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (selectedDelivery == null) {
                              ref
                                  .read(selectedDeliveryProvider.notifier)
                                  .set(defaultDelivery);
                            }
                          });

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                //
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${selectedDelivery?.title ?? ''} ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      "${selectedDelivery?.deliveryFee.toStringAsFixed(0)} ৳",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 8,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //
                                    Icon(
                                      Icons.local_shipping,
                                      size: 22,
                                      color: Colors.blueAccent,
                                    ),

                                    //
                                    Text(
                                      "Get by: ${selectedDelivery?.getEstimatedDeliveryDates() ?? ''}",
                                      style: TextStyle(height: 1, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Cart Items & Promo Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cart Item',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartItems.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, index) {
                            final cartItem = cartItems[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black12),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(cartItem.imageUrl),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            (cartItem.price * cartItem.quantity)
                                                .toStringAsFixed(0),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '(${cartItem.price.toStringAsFixed(0)} x ${cartItem.quantity})',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: Colors.black54,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Promo Section
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                border: Border.all(color: Colors.black26),
                              ),
                              padding: const EdgeInsets.only(left: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: promoController,
                                      decoration: const InputDecoration(
                                        hintText: 'Have any promo code?',
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: applyPromoCode,
                                    child: const Text('Apply'),
                                  ),
                                ],
                              ),
                            ),
                            // const SizedBox(height: 8),
                            if (promoDiscount > 0)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    ' Promo Code Applied',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      promoController.clear();
                                      ref
                                          .read(promoNotifierProvider.notifier)
                                          .clear();
                                      setState(() => promoError = '');
                                    },
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                            if (promoError.isNotEmpty)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    promoError,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      visualDensity: VisualDensity(
                                        vertical: -4,
                                      ),
                                    ),
                                    onPressed: () {
                                      promoController.clear();
                                      ref
                                          .read(promoNotifierProvider.notifier)
                                          .clear();
                                      setState(() => promoError = '');
                                    },
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Order Summary
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            // Subtotal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Items Subtotal',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  subtotal.toStringAsFixed(0),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            if (promoDiscount > 0)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Promo Discount',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    '-${promoDiscount.toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                  ),
                                ],
                              ),
                            //
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery Charge',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                Text(
                                  deliveryFee.toStringAsFixed(0),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                            const Divider(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  total.toStringAsFixed(0),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
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

                const SizedBox(height: 8),

                // Payment Method
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () =>
                                  setState(() => paymentMethod = 'Bkash'),
                              contentPadding: const EdgeInsets.only(
                                right: 16,
                                left: 4,
                              ),
                              horizontalTitleGap: 0,
                              trailing: const Icon(Iconsax.clipboard),
                              title: const Text('Bkash'),
                              leading: Radio<String>(
                                value: 'Bkash',
                                groupValue: paymentMethod,
                                onChanged: (value) =>
                                    setState(() => paymentMethod = value!),
                              ),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              onTap: () =>
                                  setState(() => paymentMethod = 'Cash'),
                              contentPadding: const EdgeInsets.only(
                                right: 16,
                                left: 4,
                              ),
                              horizontalTitleGap: 0,
                              trailing: const Icon(Iconsax.activity),
                              title: const Text('Cash on Delivery'),
                              leading: Radio<String>(
                                value: 'Cash',
                                groupValue: paymentMethod,
                                onChanged: (value) =>
                                    setState(() => paymentMethod = value!),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                //
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: isPlacingOrder
                        ? null
                        : () async {
                            if (selectedAddress == null) {
                              Fluttertoast.showToast(
                                msg: "Please select a delivery address.",
                              );
                              return;
                            }

                            setState(() => isPlacingOrder = true);

                            if (paymentMethod == 'Bkash') {
                              await triggerBkashPayment(total);
                            } else {
                              await placeOrder();
                            }

                            setState(() => isPlacingOrder = false);
                          },
                    child: isPlacingOrder
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Confirm Order'),
                  ),
                ),
              ],
            ),
    );
  }

  //
  void applyPromoCode() async {
    final promoCode = promoController.text.trim().toLowerCase();
    if (promoCode.isEmpty) return;

    final promoSnapshot = await FirebaseFirestore.instance
        .collection('promo')
        .doc(promoCode)
        .get();

    if (promoSnapshot.exists) {
      promo = promoSnapshot.id;
      final data = promoSnapshot.data()!;
      final discount = (data['discount'] ?? 0).toDouble();
      ref.read(promoNotifierProvider.notifier).setDiscount(discount);

      setState(() {
        promoError = '';
        FocusScope.of(context).unfocus();
        promoController.clear();
      });
    } else {
      ref.read(promoNotifierProvider.notifier).clear();
      setState(() {
        promoError = 'Invalid promo code';
        FocusScope.of(context).unfocus();
      });
    }
  }

  //
  Future<void> triggerBkashPayment(double totalAmount) async {
    Fluttertoast.showToast(
      msg:
          "Processing your order...\nRedirecting to the payment gateway. Please wait.",
    );

    //
    ExecutePaymentResponse? paymentResponse = await Bkash.payment(
      context: context,
      production: kProduction,
      amount: totalAmount.toStringAsFixed(0),
    );

    //
    if (paymentResponse != null &&
        paymentResponse.transactionStatus == "Completed") {
      await placeOrder();

      //
      context.go(AppRoute.orderPlaced.path);
    } else {
      Fluttertoast.showToast(
        msg:
            "Payment failed. Status: ${paymentResponse?.statusCode}, ${paymentResponse?.statusMessage}",
      );
    }
  }

  //
  Future<int> getNextOrderId() async {
    final counterRef = FirebaseFirestore.instance
        .collection('settings')
        .doc('orderIdCounter');

    DocumentSnapshot doc = await counterRef.get();
    int currentOrderId = 1;

    if (doc.exists) {
      currentOrderId = doc['nextOrderId'];
    }

    await counterRef.update({'nextOrderId': currentOrderId + 1});
    return currentOrderId;
  }

  //
  Future<void> placeOrder() async {
    try {
      final cartItems = ref.read(cartProvider);
      final selectedAddress = ref.read(selectedAddressProvider);
      final delivery = ref.read(selectedDeliveryProvider);
      final promoDiscount = ref.read(promoNotifierProvider);

      int orderId = await getNextOrderId();

      List<OrderItem> items = cartItems
          .map(
            (cartItem) => OrderItem(
              productId: cartItem.id,
              title: cartItem.name,
              price: cartItem.price,
              quantity: cartItem.quantity,
              image: cartItem.imageUrl,
            ),
          )
          .toList();

      final order = OrderModel(
        orderId: orderId,
        userId: FirebaseAuth.instance.currentUser!.uid,
        items: items,
        totalPrice: ref.read(cartProvider.notifier).totalPrice,
        deliveryFee: delivery?.deliveryFee.toDouble() ?? 0.0,
        promoCode: promo,
        promoDiscount: promoDiscount,
        address: selectedAddress!.toMap(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        orderStatus: OrderStatus.pending.name,
        paymentMethod: paymentMethod,
        paymentStatus: paymentMethod == 'Bkash'
            ? PaymentStatus.paid.name
            : PaymentStatus.unpaid.name,
      );

      await FirebaseFirestore.instance
          .collection('orders')
          .doc()
          .set(order.toMap());

      // update stock
      // if (paymentMethod == 'Bkash') {
      for (var item in cartItems) {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(item.id)
            .update({'stock': FieldValue.increment(-item.quantity)});
      }
      // }

      //send notification to admin
      FCMSender.sendToTopic(
        topic: 'admin',
        title: 'New Order',
        body: 'New order placed.  ${order.paymentMethod}',
        data: {},
      );

      // Clear cart
      ref.read(cartProvider.notifier).clearCart();
      context.go(AppRoute.orderPlaced.path);
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong: $e");
    }
  }
}
