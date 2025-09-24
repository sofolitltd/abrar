import 'package:abrar/features/address/address.dart';
import 'package:abrar/features/auth/create_account_page.dart';
import 'package:abrar/features/auth/login_page.dart';
import 'package:abrar/models/address_model.dart';
import 'package:abrar/models/product_model.dart';
import 'package:abrar/notification/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/home.dart';
import '/features/profile/profile.dart';
import '../../features/cart/cart_page.dart';
import '../../features/products/products_page.dart';
import '../bkash/models/create_payment_response.dart';
import '../bkash/views/bkash_web_view.dart';
import '../features/address/add_address.dart';
import '../features/address/edit_address.dart';
import '../features/checkout/checkout.dart';
import '../features/checkout/order_placed.dart';
import '../features/home/all_brands_page.dart';
import '../features/home/all_categories_page.dart';
import '../features/orders/order_details.dart';
import '../features/products/products_details.dart';
import '../models/order_model.dart';
import 'app_route.dart';

// Global key for the root navigator, essential for GoRouter
final rootNavigatorKey = GlobalKey<NavigatorState>();
// final FirebaseAuth _auth = FirebaseAuth.instance;

final GoRouter routerConfig = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoute.home.path,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Page not found'),
      leading: BackButton(
        onPressed: () {
          routerConfig.go(AppRoute.home.path);
        },
      ),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          const Text(
            'Page not found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text('${state.error}'),
          TextButton(
            onPressed: () {
              routerConfig.go(AppRoute.home.path);
            },
            child: const Text('Go to Home'),
          ),
        ],
      ),
    ),
  ),
  routes: [
    // StatefulShellRoute is used for persistent UI
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // This builder defines the shared Scaffold with the NavigationBar.
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // --- Branch for the 'Home' tab ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoute.home.name,
              path: AppRoute.home.path,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: Home(), // The widget displayed for this route
              ),
            ),
          ],
        ),

        // --- Branch for the 'Shop' tab ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoute.shop.name,
              path: AppRoute.shop.path,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProductsPage(sortBy: "Low to High"),
              ),
            ),
          ],
        ),

        // --- Branch for the 'Cart' tab ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoute.cart.name,
              path: AppRoute.cart.path,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CartPage(), // The widget displayed for this route
              ),
            ),
          ],
        ),

        // --- Branch for the 'account' tab ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              name: AppRoute.profile.name,
              path: AppRoute.profile.path,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: Profile()),
            ),
          ],
        ),
      ],
    ),

    // login
    GoRoute(
      name: AppRoute.login.name,
      path: AppRoute.login.path,
      pageBuilder: (context, state) =>
          NoTransitionPage(child: LoginPage(route: state.extra as String?)),
    ),

    //create account
    GoRoute(
      name: AppRoute.createAccount.name,
      path: AppRoute.createAccount.path,
      pageBuilder: (context, state) => NoTransitionPage(
        child: CreateAccountPage(route: state.extra as String?),
      ),
    ),

    // address
    GoRoute(
      name: AppRoute.address.name,
      path: AppRoute.address.path,
      pageBuilder: (context, state) => NoTransitionPage(child: AddressPage()),
    ),

    // edit address
    GoRoute(
      name: AppRoute.editAddress.name,
      path: AppRoute.editAddress.path,
      pageBuilder: (context, state) {
        final address = state.extra as AddressModel;
        return NoTransitionPage(
          key: state.pageKey,
          child: EditAddress(address: address),
        );
      },
    ),

    // add address
    GoRoute(
      name: AppRoute.addAddress.name,
      path: AppRoute.addAddress.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(key: state.pageKey, child: AddAddress());
      },
    ),

    // bkash
    GoRoute(
      name: AppRoute.bkash.name,
      path: AppRoute.bkash.path,
      builder: (context, state) {
        final payment = state.extra as CreatePaymentResponse;
        return BkashWebView(
          url: payment.bkashURL,
          successURL: payment.successCallbackURL,
          failureURL: payment.failureCallbackURL,
          cancelURL: payment.cancelledCallbackURL,
        );
      },
    ),

    // checkout
    GoRoute(
      name: AppRoute.checkout.name,
      path: AppRoute.checkout.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: const CheckOut());
      },
    ),

    // product page
    GoRoute(
      name: AppRoute.products.name,
      path: AppRoute.products.path,
      pageBuilder: (context, state) {
        final params = state.extra as ProductsPageParams?;

        return NoTransitionPage(
          key: state.pageKey,
          child: ProductsPage(
            category: params?.category,
            subCategory: params?.subCategory,
            brand: params?.brand,
            isFeatured: params?.isFeatured,
            sortBy: params?.sortBy ?? 'Latest Items',
          ),
        );
      },
    ),

    // product details
    GoRoute(
      name: AppRoute.productDetails.name,
      path: AppRoute.productDetails.path,
      pageBuilder: (context, state) {
        final product = state.extra as ProductModel;
        return NoTransitionPage(
          key: state.pageKey,
          child: ProductsDetails(product: product),
        );
      },
    ),

    // all brand
    GoRoute(
      name: AppRoute.brands.name,
      path: AppRoute.brands.path,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: AllBrandsPage()),
    ),

    // categories
    GoRoute(
      name: AppRoute.categories.name,
      path: AppRoute.categories.path,
      pageBuilder: (context, state) {
        return NoTransitionPage(child: const AllCategoriesPage());
      },
    ),

    // order placed
    GoRoute(
      name: AppRoute.orderPlaced.name,
      path: AppRoute.orderPlaced.path,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: OrderPlaced());
      },
    ),

    // order details
    GoRoute(
      name: AppRoute.orderDetails.name,
      path: AppRoute.orderDetails.path, // e.g. '/order-details'
      pageBuilder: (context, state) {
        final order = state.extra as OrderModel;

        return NoTransitionPage(child: OrderDetailsPage(order: order));
      },
    ),

    // notifications
    GoRoute(
      name: AppRoute.notifications.name,
      path: AppRoute.notifications.path,
      pageBuilder: (context, state) {
        final userId = state.extra as String;
        return NoTransitionPage(child: NotificationPage(userId: userId));
      },
    ),
  ],
);

// --- The Shared UI Shell with Material 3 NavigationBar ---
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: .2)),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          height: 64,
          backgroundColor: Colors.white,
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              selectedIcon: Icon(Iconsax.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.shop),
              selectedIcon: Icon(Iconsax.shop),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.shopping_cart),
              selectedIcon: Icon(Iconsax.shopping_cart),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              selectedIcon: Icon(Iconsax.user),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (int index) {
            // Navigates to the selected branch using goBranch.
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          },
        ),
      ),
    );
  }
}
