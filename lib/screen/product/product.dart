import 'package:abara/model/product_model.dart';
import 'package:abara/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'components/add_product.dart';
import 'product_details.dart';
import 'widgets/delete_dialog.dart';

class Product extends StatelessWidget {
  const Product({super.key, this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    var ref;
    if (category == null) {
      ref = FirebaseFirestore.instance.collection('products');
    } else {
      ref = FirebaseFirestore.instance
          .collection('products')
          .where('categories', arrayContains: category);
    }

    //
    return Scaffold(
      //
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProduct(),
              ));
        },
        label: const Text('Add Product'),
      ),

      appBar: category == null
          ? null
          : AppBar(
              title: Text(category == null ? "" : category!),
            ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: ref
            // .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data Found!'));
          }

          var data = snapshot.data!.docs;

          List<String> listItem = [];
          for (var item in data) {
            String name = item.get('name');
            listItem.add(name);
          }

          return Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                //
                Autocomplete(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    List<String> words =
                        textEditingValue.text.toLowerCase().split(' ');
                    return listItem.where((String item) {
                      // Check if all words are contained in the item
                      return words
                          .every((word) => item.toLowerCase().contains(word));
                    });
                  },
                  onSelected: (String selectedItem) {
                    // Find the selected product from the list
                    var selectedProduct = data.firstWhere(
                      (product) => product.get('name') == selectedItem,
                    );

                    // Instantiate Product object
                    ProductModel productModel =
                        ProductModel.fromJson(selectedProduct);

                    // Navigate to details page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetails(
                          productModel: productModel,
                        ),
                      ),
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
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 10,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                //
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: data.length,
                    shrinkWrap: true,
                    separatorBuilder: (BuildContext context, int index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      ProductModel productModel =
                          ProductModel.fromJson(data[index]);

                      //
                      return GestureDetector(
                        onTap: () {
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                productModel: productModel,
                              ),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            //
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  // image
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(.5),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.black12),
                                      image: productModel.imageUrls.isEmpty
                                          ? null
                                          : DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                productModel.imageUrls[0],
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

                                        SizedBox(
                                          // color: Colors.red,
                                          height: 24,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                productModel.categories.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Center(
                                                child: Text(
                                                  '${productModel.categories[index]} ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(height: 1.4),
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return Text(
                                                ', ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        height: 2,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              );
                                            },
                                          ),
                                        ),

                                        // const SizedBox(height: 2),

                                        //
                                        Row(
                                          children: [
                                            //
                                            Text.rich(
                                              TextSpan(
                                                  text: 'Sale: ',
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${productModel.salePrice.toStringAsFixed(0)} $kTkSymbol',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            color: Colors.red,
                                                            fontSize: 20,
                                                            height: 1,
                                                          ),
                                                    ),
                                                  ]),
                                            ),

                                            const SizedBox(width: 16),

                                            //
                                            Text.rich(
                                              TextSpan(
                                                  text: 'Regular: ',
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '${productModel.regularPrice.toStringAsFixed(0)} $kTkSymbol',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                            color:
                                                                Colors.black87,
                                                            fontSize: 20,
                                                            height: 1,
                                                          ),
                                                    ),
                                                  ]),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            //
                            IconButton(
                                onPressed: () async {
                                  //

                                  await showDeleteDialog(
                                      context: context,
                                      id: productModel.id,
                                      collectionName: 'products');

                                  for (int i = 0;
                                      i < productModel.imageUrls.length;
                                      i++) {
                                    await FirebaseStorage.instance
                                        .refFromURL(productModel.imageUrls[i])
                                        .delete()
                                        .then((val) {
                                      print('Delete images');
                                    });
                                  }
                                },
                                icon: const Icon(Icons.delete_outline, size: 20,))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
