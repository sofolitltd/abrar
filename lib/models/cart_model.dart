class CartItemModel {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int stock;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.stock,
    this.quantity = 1,
  });

  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price,
      stock: stock,
      quantity: quantity ?? this.quantity,
    );
  }
}
