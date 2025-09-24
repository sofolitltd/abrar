import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cart_model.dart';
import 'notifiers/cart_notifier.dart';

// class CartNotifier extends Notifier<List<CartItemModel>> {
//   @override
//   List<CartItemModel> build() => [];
//
//   // Add item to cart
//   void addToCart(CartItemModel item) {
//     final index = state.indexWhere((e) => e.id == item.id);
//     if (index == -1) {
//       state = [...state, item];
//     } else {
//       final existing = state[index];
//       if (existing.quantity < existing.stock) {
//         existing.quantity++;
//         state = [...state];
//       }
//     }
//   }
//
//   // Set exact quantity (for selector)
//   void setQuantity(String id, int quantity) {
//     final index = state.indexWhere((e) => e.id == id);
//     if (index != -1) {
//       final stock = state[index].stock;
//       state[index].quantity = quantity.clamp(1, stock);
//       state = [...state]; // trigger state update
//     }
//   }
//
//   // Increase quantity
//   void increaseQuantity(String id) {
//     final index = state.indexWhere((e) => e.id == id);
//     if (index != -1 && state[index].quantity < state[index].stock) {
//       state[index].quantity++;
//       state = [...state];
//     }
//   }
//
//   // Decrease quantity
//   void decreaseQuantity(String id) {
//     final index = state.indexWhere((e) => e.id == id);
//     if (index != -1) {
//       if (state[index].quantity > 1) {
//         state[index].quantity--;
//         state = [...state];
//       } else {
//         removeFromCart(id);
//       }
//     }
//   }
//
//   // Remove item
//   void removeFromCart(String id) {
//     state = state.where((e) => e.id != id).toList();
//   }
//
//   // Total quantity
//   int get totalQuantity => state.fold(0, (sum, e) => sum + e.quantity);
//
//   // Total price
//   double get totalPrice =>
//       state.fold(0, (sum, e) => sum + e.price * e.quantity);
// }

final cartProvider = NotifierProvider<CartNotifier, List<CartItemModel>>(
  CartNotifier.new,
);
