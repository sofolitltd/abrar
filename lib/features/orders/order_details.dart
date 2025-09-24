import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/order_model.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  String formatDate(Timestamp timestamp) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order #${order.orderId ?? "N/A"}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // STATUS + DATE
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(
                "Status: ${order.orderStatus[0].toUpperCase()}${order.orderStatus.substring(1)}",
              ),
              subtitle: Text("Placed on: ${formatDate(order.createdAt)}"),
            ),
          ),
          const SizedBox(height: 12),

          // AMOUNTS
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Items Total"),
                      Text("৳${order.totalPrice.toStringAsFixed(0)}"),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Delivery Fee"),
                      Text("৳${order.deliveryFee.toStringAsFixed(2)}"),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "৳${(order.totalPrice + order.deliveryFee).toStringAsFixed(0)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ITEMS
          const Text(
            "Items",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...order.items.map(
            (item) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(item.title),
                subtitle: Text("৳${item.price} x ${item.quantity}"),
                trailing: Text(
                  "৳${(item.price * item.quantity).toStringAsFixed(2)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ADDRESS
          const Text(
            "Shipping Address",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${order.address['name'] ?? ''}"),
                  Text("Mobile: ${order.address['mobile'] ?? ''}"),
                  Text('Address: ${order.address['addressLine']}'),
                  Text("District: ${order.address['district'] ?? ''}}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
