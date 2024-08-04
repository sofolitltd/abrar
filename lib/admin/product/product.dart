import 'package:abara/model/product_model.dart';
import 'package:abara/utils/constants.dart';
import 'package:abara/widgets/header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/slug_generator.dart';

class Product extends StatelessWidget {
  const Product({
    super.key,
    // this.category,
  });

  // final String? category;

  @override
  Widget build(BuildContext context) {
    // Query<Map<String, dynamic>> ref;
    // if (category == null) {
    // ref = FirebaseFirestore.instance.collection('products');
    // } else {
    //   ref = FirebaseFirestore.instance
    //       .collection('products')
    //       .where('category', isEqualTo: category);
    // }

    //
    return Scaffold(
      //
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const AddProduct(),
      //         ));
      //   },
      //   label: const Text('Add Product'),
      // ),

      // appBar: category == null
      //     ? null
      //     : AppBar(
      //         title: Text(category == null ? "" : category!),
      //       ),

      //
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Header(),

                //
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 1080,
                  ),
                  alignment: Alignment.topCenter,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Something wrong'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: LinearProgressIndicator(),
                        );
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No data Found!'));
                      }

                      var data = snapshot.data!.docs;

                      //
                      List<ProductModel> productList = [];
                      for (var item in data) {
                        var products = ProductModel.fromJson(
                            item.data() as Map<String, dynamic>);
                        productList.add(products);
                      }

                      return Container(
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            //
                            Autocomplete<ProductModel>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text.isEmpty) {
                                  return const Iterable<ProductModel>.empty();
                                }
                                List<String> words = textEditingValue.text
                                    .toLowerCase()
                                    .split(' ');
                                return productList.where((ProductModel item) {
                                  return words.every((word) =>
                                      item.name.toLowerCase().contains(word));
                                });
                              },
                              displayStringForOption: (ProductModel option) =>
                                  option.name,
                              onSelected: (ProductModel productModel) {
                                context.goNamed(
                                  'product',
                                  pathParameters: {
                                    'category': productModel.category,
                                    'id': productModel.id
                                  },
                                  extra: productModel,
                                );
                              },
                              fieldViewBuilder: (BuildContext context,
                                  TextEditingController textEditingController,
                                  FocusNode focusNode,
                                  VoidCallback onFieldSubmitted) {
                                return TextField(
                                  controller: textEditingController,
                                  focusNode: focusNode,
                                  onSubmitted: (_) => onFieldSubmitted(),
                                  decoration: InputDecoration(
                                    hintText: ' Search here ...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                      horizontal: 10,
                                    ),
                                  ),
                                );
                              },
                              optionsViewBuilder: (BuildContext context,
                                  AutocompleteOnSelected<ProductModel>
                                      onSelected,
                                  Iterable<ProductModel> options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Material(
                                      elevation: 4.0,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 1042),
                                        height:
                                            MediaQuery.of(context).size.height -
                                                32,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                32,
                                        child: ListView.builder(
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final ProductModel option =
                                                options.elementAt(index);
                                            //
                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                leading: SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      option.images.isNotEmpty
                                                          ? Image.network(
                                                              option.images[0],
                                                              fit: BoxFit.cover,
                                                            )
                                                          : const Placeholder(),
                                                ),
                                                title: Text(option.name),
                                                subtitle: Text(
                                                    '${option.regularPrice.toStringAsFixed(0)} $kTkSymbol'),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            //
                            ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: data.length,
                              shrinkWrap: true,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                ProductModel productModel =
                                    ProductModel.fromJson(data[index].data()
                                        as Map<String, dynamic>);

                                //
                                return GestureDetector(
                                  onTap: () {
                                    //
                                    context.goNamed(
                                      'product',
                                      pathParameters: {
                                        'category':
                                            productModel.category.toLowerCase(),
                                        'name':
                                            slugGenerator(productModel.name),
                                      },
                                      extra: productModel,
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      //
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border:
                                              Border.all(color: Colors.black12),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            // image
                                            Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                color: Colors.blueAccent
                                                    .withOpacity(.5),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: Colors.black12),
                                                image:
                                                    productModel.images.isEmpty
                                                        ? null
                                                        : DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                              productModel
                                                                  .images[0],
                                                            ),
                                                          ),
                                              ),
                                            ),

                                            const SizedBox(width: 12),

                                            //
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  //
                                                  Text(
                                                    '${productModel.name} ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(),
                                                  ),

                                                  const SizedBox(height: 10),

                                                  // SizedBox(
                                                  //   // color: Colors.red,
                                                  //   height: 24,
                                                  //   child: ListView.separated(
                                                  //     shrinkWrap: true,
                                                  //     scrollDirection: Axis.horizontal,
                                                  //     itemCount:
                                                  //         productModel.categories.length,
                                                  //     itemBuilder: (BuildContext context,
                                                  //         int index) {
                                                  //       return Center(
                                                  //         child: Text(
                                                  //           '${productModel.categories[index]} ',
                                                  //           style: Theme.of(context)
                                                  //               .textTheme
                                                  //               .bodySmall!
                                                  //               .copyWith(height: 1.4),
                                                  //         ),
                                                  //       );
                                                  //     },
                                                  //     separatorBuilder:
                                                  //         (BuildContext context,
                                                  //             int index) {
                                                  //       return Text(
                                                  //         ', ',
                                                  //         style: Theme.of(context)
                                                  //             .textTheme
                                                  //             .bodySmall!
                                                  //             .copyWith(
                                                  //                 height: 2,
                                                  //                 fontWeight:
                                                  //                     FontWeight.bold),
                                                  //       );
                                                  //     },
                                                  //   ),
                                                  // ),

                                                  // const SizedBox(height: 2),

                                                  //
                                                  Row(
                                                    children: [
                                                      //
                                                      Text(
                                                        '$kTkSymbol${productModel.regularPrice.toStringAsFixed(0)}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleSmall!
                                                            .copyWith(
                                                              color: Colors.red,
                                                              fontSize: 20,
                                                              height: 1,
                                                            ),
                                                      ),

                                                      const SizedBox(width: 16),

                                                      //
                                                      // Text.rich(
                                                      //   TextSpan(
                                                      //       text: 'Sale: ',
                                                      //       children: [
                                                      //         TextSpan(
                                                      //           text:
                                                      //               '${productModel.salePrice.toStringAsFixed(0)} $kTkSymbol',
                                                      //           style: Theme.of(
                                                      //                   context)
                                                      //               .textTheme
                                                      //               .titleSmall!
                                                      //               .copyWith(
                                                      //                 fontSize:
                                                      //                     20,
                                                      //                 height: 1,
                                                      //               ),
                                                      //         ),
                                                      //       ]),
                                                      // ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      //
                                      // IconButton(
                                      //     onPressed: () async {
                                      //       //
                                      //
                                      //       await showDeleteDialog(
                                      //           context: context,
                                      //           id: productModel.id,
                                      //           collectionName: 'products');
                                      //
                                      //       //
                                      //       for (int i = 0;
                                      //           i < productModel.images.length;
                                      //           i++) {
                                      //         await FirebaseStorage.instance
                                      //             .refFromURL(
                                      //                 productModel.images[i])
                                      //             .delete()
                                      //             .then((val) {
                                      //           print('Delete images');
                                      //         });
                                      //       }
                                      //     },
                                      //     icon: const Icon(
                                      //       Icons.delete_outline,
                                      //       size: 20,
                                      //     )),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
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
