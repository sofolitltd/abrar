import 'package:abara/screen/home/category_details.dart';
import 'package:abara/screen/home/home.dart';
import 'package:abara/screen/home/product_details.dart';
import 'package:abara/screen/home/search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  usePathUrlStrategy();

  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Abrar Shop',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'Telenor',
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
    );
  }
}

//
// GoRouter configuration
final _router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (context, state) => const NoTransitionPage(child: Home()),
    ),
    //
    GoRoute(
      name: 'search',
      path: '/search',
      pageBuilder: (context, state) => const NoTransitionPage(child: Search()),
    ),

    //
    GoRoute(
      name: 'category',
      path: '/:category',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: CategoryDetails(
            category: state.pathParameters['category']!,
          ),
        );
      },
    ),

    //
    GoRoute(
      name: 'product',
      path: '/:category/:name',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          child: ProductDetails(
            category: state.pathParameters['category']!,
            name: state.pathParameters['name']!,
            id: state.extra as String,
          ),
        );
      },
    ),
  ],
);
