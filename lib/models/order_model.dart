import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, shipped, delivered, canceled }

enum PaymentStatus { paid, unpaid }

class OrderItem {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String image;

  OrderItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.image,
  });

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'title': title,
    'price': price,
    'quantity': quantity,
    'image': image,
  };

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    productId: map['productId'] ?? '',
    title: map['title'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    quantity: map['quantity'] ?? 0,
    image: map['image'] ?? '',
  );
}

//
class OrderModel {
  final int orderId;
  final String userId;
  final List<OrderItem> items;
  final double totalPrice;
  final double deliveryFee;
  final String promoCode;
  final double promoDiscount;
  final Map<String, dynamic> address;
  final String orderStatus;
  final String paymentMethod;
  final String paymentStatus;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalPrice,
    required this.deliveryFee,
    required this.promoCode,
    required this.promoDiscount,
    required this.address,
    required this.orderStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'orderId': orderId,
    'userId': userId,
    'items': items.map((item) => item.toMap()).toList(),
    'totalAmount': totalPrice,
    'deliveryFee': deliveryFee,
    'promoCode': promoCode,
    'discount': promoDiscount,
    'address': address,
    'orderStatus': orderStatus,
    'paymentMethod': paymentMethod,
    'paymentStatus': paymentStatus,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
    orderId: map['orderId'] ?? 0,
    userId: map['userId'] ?? '',
    items:
        (map['items'] as List<dynamic>)
            .map((item) => OrderItem.fromMap(item))
            .toList(),
    totalPrice: (map['totalAmount'] ?? 0).toDouble(),
    deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
    promoCode: map['promoCode'],
    promoDiscount: (map['promoDiscount'] ?? 0).toDouble(),
    address: Map<String, dynamic>.from(map['address'] ?? {}),
    orderStatus: map['orderStatus'] ?? 'pending',
    paymentMethod: map['paymentMethod'] ?? '',
    paymentStatus: map['paymentStatus'] ?? 'unpaid',

    createdAt: map['createdAt'] ?? Timestamp.now(),
    updatedAt: map['updatedAt'] ?? Timestamp.now(),
  );
}
