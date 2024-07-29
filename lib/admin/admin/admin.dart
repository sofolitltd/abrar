import 'package:flutter/material.dart';

import '../ocr/ocr.dart';
import '../product/product.dart';
import '../transaction/transaction.dart';

class Admin extends StatelessWidget {
  const Admin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Abrar'),
        actions: [
          //
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OCR(),
                  ),
                );
              },
              icon: const Icon(Icons.sensor_occupied_rounded)),

          //
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Transaction(),
                  ),
                );
              },
              icon: const Icon(Icons.stacked_bar_chart_outlined)),
        ],
      ),

      //
      body: const Product(),
    );
  }
}
