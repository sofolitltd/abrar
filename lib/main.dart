import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/app_initial_provider.dart';
import '/services/firebase_options.dart';
import 'routes/router_config.dart';

Future<void> main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(appInitialProvider, (_, __) {});

    return MaterialApp.router(
      routerConfig: routerConfig,
      debugShowCheckedModeBanner: false,
      title: 'Abrar Shop',
      theme: ThemeData(
        fontFamily: 'Telenor',
        colorSchemeSeed: Colors.white,
        //
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
            fontFamily: 'Telenor',
            color: Colors.black,
          ),
          centerTitle: true,
        ),

        //
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        //
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size(48, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        //
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      //
      // getPages: [
      //   GetPage(name: '/menu', page: () => const NavigationMenu()),
      //   GetPage(name: '/cart', page: () => const CartPage()),
      //   GetPage(name: '/profile', page: () => const Profile()),
      //   GetPage(name: '/login', page: () => const LoginPage()),
      //   GetPage(
      //     name: '/create-account',
      //     page: () => const CreateAccountPage(),
      //   ),
      //
      //   GetPage(name: '/address', page: () => const AddressPage()),
      //   GetPage(name: '/add-address', page: () => const AddAddress()),
      //   GetPage(name: '/edit-address', page: () => const EditAddress()),
      //
      //   GetPage(name: '/orders', page: () => const Orders()),
      // ],
      // home: const NavigationMenu(),
    );
  }
}

// adb -s 5f3e33ba install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
