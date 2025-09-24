import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/models/order_model.dart';
import '/routes/app_route.dart';
import '/utils/to_capitalized.dart';

class Orders extends StatelessWidget {
  const Orders({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Orders"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Pending"),
              Tab(text: "Processing"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrdersList(status: 'all'),
            OrdersList(status: 'pending'),
            OrdersList(status: 'processing'),
            OrdersList(status: 'completed'),
          ],
        ),
      ),
    );
  }
}

//
class OrdersList extends StatelessWidget {
  final String status;

  const OrdersList({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: status == 'all'
          ? FirebaseFirestore.instance
                .collection('/orders')
                .where('userId', isEqualTo: userId)
                .orderBy('createdAt', descending: true)
                .snapshots()
          : FirebaseFirestore.instance
                .collection('/orders')
                .where('userId', isEqualTo: userId)
                .where('orderStatus', isEqualTo: status)
                .orderBy('createdAt', descending: true)
                .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading orders."));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return const Center(child: Text("No orders found."));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (_, __) => SizedBox(height: 8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            OrderModel order = OrderModel.fromMap(data);

            return Card(
              child: ListTile(
                title: Text("Order #${order.orderId}"),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        Text("${order.items.length} item(s) "),
                        Text("|  ${order.totalPrice.toStringAsFixed(0)} ৳"),

                        Text(
                          "|  ${DateFormat("dd/MM/yyyy, hh:mm a").format(order.createdAt.toDate())}",
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    //
                    Row(
                      spacing: 10,
                      children: [
                        //
                        Container(
                          decoration: BoxDecoration(
                            color: order.paymentStatus == "paid"
                                ? Colors.green
                                : Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            order.paymentStatus.toCapitalized(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        //
                        Container(
                          decoration: BoxDecoration(
                            color: order.paymentMethod == 'Bkash'
                                ? Colors.pinkAccent
                                : Colors.teal,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            order.paymentMethod,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    //
                    SizedBox(height: 4),
                  ],
                ),
                onTap: () {
                  // Navigate to order details
                  context.push(
                    AppRoute.orderDetails.path,
                    extra: OrderModel.fromMap(data),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
