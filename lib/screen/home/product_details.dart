import 'package:abara/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/product_model.dart';
import '../../utils/constants.dart';
import '../../widgets/capitalize_words.dart';
import '../../widgets/slug_generator.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    super.key,
    required this.category,
    required this.name,
    required this.id,
  });

  final String category;
  final String name;
  final String id;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerSection(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Header(),

                //
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('products')
                      .doc(widget.id)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something wrong'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (!snapshot.data!.exists) {
                      return const Center(child: Text('No data Found!'));
                    }

                    Map<String, dynamic> json =
                        snapshot.data!.data() as Map<String, dynamic>;
                    ProductModel productModel = ProductModel.fromJson(json);

                    //
                    return Container(
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
                                  context.goNamed('home');
                                },
                                child: Icon(
                                  Icons.home,
                                  size: 18,
                                  color: Colors.blueGrey.shade400,
                                ),
                              ),
                              const Text(' /'),
                              InkWell(
                                onTap: () {
                                  context.goNamed(
                                    'category',
                                    pathParameters: {
                                      'category': slugGenerator(widget.category)
                                    },
                                  );
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(capitalizeWords(widget.category)),
                                ),
                              ),
                              if (productModel.brand.isNotEmpty) ...[
                                const Text(' /'),
                                InkWell(
                                  onTap: null,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Text(productModel.brand),
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
                                ImageSection(images: productModel.images),

                                const SizedBox(height: 24),

                                //
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productModel.name,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  '$kTkSymbol${productModel.salePrice}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                        '$kTkSymbol${productModel.regularPrice}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1,
                                                              color: Colors
                                                                  .blueGrey,
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
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              height: 1,
                                                              color:
                                                                  Colors.green,
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

                                    const SizedBox(height: 32),

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
                                      productModel.description.isEmpty
                                          ? '${productModel.name}, Category: ${productModel.category}, Brand: ${productModel.brand}, RegularPrice: ${productModel.regularPrice}'
                                          : productModel.description,
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
                                          minWidth: 150,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          onPressed: () {},
                                          child: const Text(
                                            'Add  to Cart',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        //
                                        MaterialButton(
                                          color: Colors.deepOrangeAccent,
                                          height: 48,
                                          minWidth: 120,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          onPressed: () {},
                                          child: const Text(
                                            'Buy Now',
                                            style:
                                                TextStyle(color: Colors.white),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Expanded(
                                  flex: 2,
                                  child:
                                      ImageSection(images: productModel.images),
                                ),

                                const SizedBox(width: 24),

                                //
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //
                                        Text(
                                          productModel.name,
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
                                                color: Colors
                                                    .blueAccent.shade100
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
                                                    '$kTkSymbol${productModel.salePrice}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                  '$kTkSymbol${productModel.regularPrice}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                          productModel.description.isEmpty
                                              ? '${productModel.name}, Category: ${productModel.category}, Brand: ${productModel.brand}, RegularPrice: ${productModel.regularPrice}'
                                              : productModel.description,
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
                                              minWidth: 150,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              onPressed: () {},
                                              child: const Text(
                                                'Add  to Cart',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            //
                                            MaterialButton(
                                              color: Colors.deepOrangeAccent,
                                              height: 48,
                                              minWidth: 120,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              onPressed: () {},
                                              child: const Text(
                                                'Buy Now',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          //
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.images});

  final List images;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //
        Image.network(
          widget.images.isEmpty
              ? 'https://firebasestorage.googleapis.com/v0/b/abrar-shop.appspot.com/o/placeholder.png?alt=media&token=dc5ea06a-d65d-4689-9196-329781aef7d6'
              : widget.images[selectedImage],
          height: MediaQuery.sizeOf(context).width < 600 ? 200 : 400,
          fit: BoxFit.cover,
        ),

        const SizedBox(height: 8),

        //
        Container(
          height: MediaQuery.sizeOf(context).width < 600 ? 40 : 56,
          alignment: Alignment.center,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
            shrinkWrap: true,
            itemCount: widget.images.length,
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
                          : Colors.white,
                    ),
                  ),
                  child: Image.network(
                    widget.images[index],
                    height: MediaQuery.sizeOf(context).width < 600 ? 40 : 56,
                    width: MediaQuery.sizeOf(context).width < 600 ? 40 : 56,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
