import 'package:abara/utils/constants.dart';
import 'package:abara/widgets/header.dart';
import 'package:flutter/material.dart';

import '../../model/product_model.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Header(),

                //
                Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      //
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.home,
                              size: 18,
                              color: Colors.blueGrey.shade400,
                            ),
                          ),
                          const Text(' /'),
                          InkWell(
                            onTap: null,
                            // onTap: () {
                            //   // Navigator.pop(context);
                            // },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(widget.productModel.category),
                            ),
                          ),
                          if (widget.productModel.brand.isNotEmpty) ...[
                            const Text(' /'),
                            InkWell(
                              onTap: null,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(widget.productModel.brand),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // image
                      if (MediaQuery.sizeOf(context).width < 600)
                        Column(
                          children: [
                            Column(
                              children: [
                                //
                                Image.network(
                                  widget.productModel.images.isEmpty
                                      ? 'https://firebasestorage.googleapis.com/v0/b/abrar-shop.appspot.com/o/placeholder.png?alt=media&token=dc5ea06a-d65d-4689-9196-329781aef7d6'
                                      : widget
                                          .productModel.images[selectedImage],
                                  height: MediaQuery.sizeOf(context).width < 600
                                      ? 200
                                      : 400,
                                  fit: BoxFit.cover,
                                ),

                                const SizedBox(height: 8),

                                //
                                Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(width: 10);
                                    },
                                    shrinkWrap: true,
                                    itemCount:
                                        widget.productModel.images.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          selectedImage = index;
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: selectedImage == index
                                                  ? Colors.blueAccent
                                                  : Colors.transparent,
                                            ),
                                          ),
                                          child: Image.network(
                                            widget.productModel.images[index],
                                            height: 56,
                                            width: 56,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            //
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.productModel.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),

                                const SizedBox(height: 16),

                                //
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //
                                    Expanded(
                                      flex: 4,
                                      child: Container(
                                        height: 75,
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.shade100
                                              .withOpacity(.2),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //
                                            Text(
                                              'Special Price',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(),
                                            ),
                                            const SizedBox(height: 10),

                                            Text(
                                              '$kTkSymbol${widget.productModel.salePrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    // fontSize: 27,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    //
                                    Expanded(
                                      flex: 5,
                                      child: SizedBox(
                                        height: 75,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // regular
                                            Container(
                                              // width: 130,
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .blueAccent.shade100
                                                    .withOpacity(.2),
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  //
                                                  Text(
                                                    'Regular Price:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          height: 1,
                                                        ),
                                                  ),

                                                  const SizedBox(width: 8),

                                                  Text(
                                                    '$kTkSymbol${widget.productModel.regularPrice}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1,
                                                          color:
                                                              Colors.blueGrey,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            // status
                                            Container(
                                              // width: 130,
                                              decoration: BoxDecoration(
                                                color: Colors
                                                    .blueAccent.shade100
                                                    .withOpacity(.2),
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  //
                                                  Text(
                                                    'Status:',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                          height: 1.1,
                                                        ),
                                                  ),
                                                  const SizedBox(width: 8),

                                                  Text(
                                                    'In Stock',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: 1,
                                                          color: Colors.green,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                //
                                Text(
                                  'Product Description',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                ),

                                const SizedBox(height: 8),
                                //
                                Text(
                                  widget.productModel.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        // fontWeight: FontWeight.bold,
                                        height: 1.6,
                                      ),
                                ),

                                const SizedBox(height: 24),

                                //
                                Row(
                                  children: [
                                    //
                                    MaterialButton(
                                      color: Colors.blueAccent,
                                      height: 48,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      onPressed: () {},
                                      child: const Text(
                                        'Add  to Cart',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    //
                                    MaterialButton(
                                      color: Colors.deepOrangeAccent,
                                      height: 48,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      onPressed: () {},
                                      child: const Text(
                                        'Buy Now',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            //
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Column(
                                  children: [
                                    //
                                    Image.network(
                                      widget.productModel.images.isEmpty
                                          ? 'https://firebasestorage.googleapis.com/v0/b/abrar-shop.appspot.com/o/placeholder.png?alt=media&token=dc5ea06a-d65d-4689-9196-329781aef7d6'
                                          : widget.productModel
                                              .images[selectedImage],
                                      height:
                                          MediaQuery.sizeOf(context).width < 600
                                              ? 200
                                              : 300,
                                      fit: BoxFit.cover,
                                    ),

                                    const SizedBox(height: 16),

                                    //
                                    Container(
                                      height: 60,
                                      alignment: Alignment.center,
                                      child: ListView.separated(
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(width: 10);
                                        },
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.productModel.images.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              selectedImage = index;
                                              setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: selectedImage == index
                                                      ? Colors.blueAccent
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              child: Image.network(
                                                widget
                                                    .productModel.images[index],
                                                height: 56,
                                                width: 56,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 32),

                            //
                            Expanded(
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Text(
                                    widget.productModel.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),

                                  const SizedBox(height: 16),

                                  //
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //
                                      Container(
                                        height: 75,
                                        constraints: const BoxConstraints(
                                          minWidth: 160,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.shade100
                                              .withOpacity(.2),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //
                                            Text(
                                              'Special Price',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(),
                                            ),
                                            const SizedBox(height: 10),

                                            Text(
                                              '$kTkSymbol${widget.productModel.salePrice}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    // fontSize: 27,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 24),

                                      // regular
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //
                                          Text(
                                            'Regular Price:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  height: 1,
                                                ),
                                          ),

                                          const SizedBox(width: 8),

                                          Text(
                                            '$kTkSymbol${widget.productModel.regularPrice}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                  color: Colors.blueGrey,
                                                ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 16),

                                      // status
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //
                                          Text(
                                            'Status:',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  height: 1.1,
                                                ),
                                          ),
                                          const SizedBox(width: 8),

                                          Text(
                                            'In Stock',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1,
                                                  color: Colors.green,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  //
                                  Text(
                                    'Product Description',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                  ),

                                  const SizedBox(height: 8),
                                  //
                                  Text(
                                    widget.productModel.description,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          // fontWeight: FontWeight.bold,
                                          height: 1.6,
                                        ),
                                  ),

                                  const SizedBox(height: 24),

                                  //
                                  Row(
                                    children: [
                                      //
                                      MaterialButton(
                                        color: Colors.blueAccent,
                                        height: 48,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        onPressed: () {},
                                        child: const Text(
                                          'Add  to Cart',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      //
                                      MaterialButton(
                                        color: Colors.deepOrangeAccent,
                                        height: 48,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4)),
                                        onPressed: () {},
                                        child: const Text(
                                          'Buy Now',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
