import 'package:abara/screen/home/home.dart';
import 'package:flutter/material.dart';

import '../admin/product/product.dart';
import 'custom_route.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent.shade100.withOpacity(.2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Center(
        // Added Center widget
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Row(
            children: [
              //
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    CustomPageRoute(
                      builder: (context) => const Home(),
                    ),
                  );
                },
                child: const Text.rich(
                  TextSpan(
                      text: 'Abrar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 24),
                      children: [
                        TextSpan(
                          text: ' Shop',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.black,
                          ),
                        )
                      ]),
                ),
              ),

              const Spacer(),

              //
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(
                      builder: (context) => const Product(),
                    ),
                  );
                },
                child: Container(
                  constraints: BoxConstraints(
                      minWidth:
                          MediaQuery.sizeOf(context).width < 600 ? 180 : 380),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.search_outlined,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text(' Search here...'),
                    ],
                  ),
                ),
              ),

              //
              // const SizedBox(width: 8),
              //
              // IconButton.filledTonal(
              //     style: IconButton.styleFrom(
              //         padding: EdgeInsets.zero,
              //         visualDensity:
              //             const VisualDensity(horizontal: -1, vertical: -1)),
              //     onPressed: () {},
              //     icon: const Icon(
              //       Icons.shopping_cart_outlined,
              //       size: 20,
              //     )),
            ],
          ),
        ),
      ),
    );
  }
}
