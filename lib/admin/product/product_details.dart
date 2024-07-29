import 'package:flutter/material.dart';

import '/model/product_model.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel productModel;

  const ProductDetails({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          //
          Row(
            children: productModel.images.map((image) {
              return Container(
                height: 100,
                width: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(image))),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          //
          Text(
            productModel.name,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 20.0),

          const Text(
            'Regular Price:',
            style: TextStyle(),
          ),
          Text(
            '${productModel.regularPrice} Tk',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          const Text(
            'Sale Price:',
            style: TextStyle(),
          ),
          Text(
            '${productModel.salePrice} Tk',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),

          //categories
          // if (productModel.categories.isNotEmpty) ...[
          //   const Text(
          //     'Category:',
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 18.0,
          //     ),
          //   ),
          //   const SizedBox(height: 8),

          // Row(
          //   // crossAxisAlignment: CrossAxisAlignment.start,
          //   children: productModel.categories.map((category) {
          //     return GestureDetector(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (context) => Product(
          //               category: category,
          //             ),
          //           ),
          //         );
          //       },
          //       child: Container(
          //         margin: const EdgeInsets.only(right: 8),
          //         padding: const EdgeInsets.symmetric(
          //           vertical: 2,
          //           horizontal: 5,
          //         ),
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(4),
          //             border: Border.all(color: Colors.black12)),
          //         child: Text(
          //           category,
          //           style: const TextStyle(fontSize: 16.0),
          //         ),
          //       ),
          //     );
          //   }).toList(),
          // ),
        ]
                // ],
                ),
      ),
    );
  }
}
