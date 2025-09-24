import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/cart_model.dart';
import '../../models/product_model.dart';

class CartNotifier extends Notifier<List<CartItemModel>> {
  @override
  List<CartItemModel> build() => [];

  // Add item to cart
  void addToCart(CartItemModel item) {
    final index = state.indexWhere((e) => e.id == item.id);
    if (index == -1) {
      state = [...state, item];
    } else {
      final existing = state[index];
      if (existing.quantity < existing.stock) {
        existing.quantity++;
        state = [...state];
      }
    }
  }

  // Increase quantity
  void increaseQuantity(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1 && state[index].quantity < state[index].stock) {
      state[index].quantity++;
      state = [...state];
    }
  }

  // Decrease quantity
  void decreaseQuantity(String id) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1) {
      if (state[index].quantity > 1) {
        state[index].quantity--;
        state = [...state];
      } else {
        removeFromCart(id);
      }
    }
  }

  // Set exact quantity (for selector)
  void setQuantity(String id, int quantity, {ProductModel? product}) {
    final index = state.indexWhere((e) => e.id == id);
    if (index != -1) {
      final stock = state[index].stock;
      state[index].quantity = quantity.clamp(1, stock);
      state = [...state];
    } else if (product != null) {
      // Add new item with quantity
      state = [
        ...state,
        CartItemModel(
          id: product.id,
          name: product.name,
          price: product.salePrice,
          imageUrl: product.images.isNotEmpty ? product.images[0] : '',
          quantity: quantity.clamp(1, product.stock),
          stock: product.stock,
        ),
      ];
    }
  }

  // Remove item
  void removeFromCart(String id) {
    state = state.where((e) => e.id != id).toList();
  }

  // Clear all items
  void clearCart() {
    state = [];
  }

  // Total quantity
  int get totalQuantity => state.fold(0, (sum, e) => sum + e.quantity);

  // Total price
  double get totalPrice =>
      state.fold(0, (sum, e) => sum + e.price * e.quantity);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItemModel>>(
  CartNotifier.new,
);
