class AppRoute {
  final String name;
  final String path;
  final String Function(Map<String, String>? params)? buildPath;

  const AppRoute({required this.name, required this.path, this.buildPath});

  String toPath([Map<String, String>? params]) {
    if (buildPath != null) {
      return buildPath!(params);
    }
    return path;
  }

  // All routes defined below
  static const home = AppRoute(name: 'home', path: '/home');
  static const shop = AppRoute(name: 'shop', path: '/shop');
  static const cart = AppRoute(name: 'cart', path: '/cart');
  static const profile = AppRoute(name: 'profile', path: '/profile');

  //auth
  static const login = AppRoute(name: 'login', path: '/login');
  static const createAccount = AppRoute(
    name: 'create-account',
    path: '/create-account',
  );

  //address
  static const address = AppRoute(name: 'address', path: '/address');
  static const addAddress = AppRoute(name: 'add-address', path: '/add-address');
  static const editAddress = AppRoute(
    name: 'edit-address',
    path: '/edit-address',
  );

  // checkout
  static const checkout = AppRoute(name: 'checkout', path: '/checkout');

  // orders
  static const orders = AppRoute(name: 'orders', path: '/orders');
  static const orderPlaced = AppRoute(
    name: 'order-placed',
    path: '/order-placed',
  );
  static const orderDetails = AppRoute(
    name: 'order-details',
    path: '/order-details',
  );

  //cat
  static const notifications = AppRoute(
    name: 'notifications',
    path: '/notifications',
  );

  //
  static const categories = AppRoute(name: 'categories', path: '/categories');

  //
  static const bkash = AppRoute(name: 'bkash', path: '/bkash');

  // products
  static const products = AppRoute(name: 'products', path: '/products');

  static const productDetails = AppRoute(
    name: 'product-details',
    path: '/product-details',
  );

  static const brands = AppRoute(name: 'brands', path: '/brands');
}

//
class ProductsPageParams {
  final String? category;
  final String? subCategory;
  final String? brand;
  final bool? isFeatured;
  final String? sortBy;

  const ProductsPageParams({
    this.category,
    this.subCategory,
    this.brand,
    this.isFeatured,
    this.sortBy,
  });
}
