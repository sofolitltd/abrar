import 'package:abara/widgets/capitalize_words.dart';
import 'package:abara/widgets/header.dart';
import 'package:abara/widgets/slug_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/product_model.dart';
import '../../utils/constants.dart';

class CategoryDetails extends StatefulWidget {
  const CategoryDetails({
    super.key,
    required this.category,
  });

  final String category;

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  String _sortBy = 'Default';

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>>? ref;
    var ref1 = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: capitalizeWords(widget.category));

    if (_sortBy == 'Default') {
      ref = ref1;
    } else if (_sortBy == 'Low to High') {
      ref = ref1.orderBy('salePrice', descending: false);
    } else if (_sortBy == 'High to Low') {
      ref = ref1.orderBy('salePrice', descending: true);
    }

    return Scaffold(
      drawer: const DrawerSection(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                //
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
                            onTap: null,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(capitalizeWords(widget.category)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      //
                      Text(
                        capitalizeWords(widget.category),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      //
                      // Wrap(
                      //   children: categoryList.map((category) {
                      //     return Padding(
                      //       padding: const EdgeInsets.only(right: 6),
                      //       child: Chip(
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(50),
                      //         ),
                      //         padding: EdgeInsets.zero,
                      //         visualDensity:
                      //             const VisualDensity(horizontal: -4, vertical: -4),
                      //         label: Text(category.name),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),

                      //
                      const Divider(height: 32),
                      //
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade50,
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //
                            Text(
                              'Sort by:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    // fontWeight: FontWeight.bold,
                                    height: 1.6,
                                  ),
                            ),

                            //
                            ButtonTheme(
                              alignedDropdown: true,
                              child: Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButton(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 4, 0, 4),
                                  isDense: true,
                                  isExpanded: true,
                                  value: _sortBy,
                                  items: <String>[
                                    'Default',
                                    'Low to High',
                                    'High to Low',
                                  ].map((String menu) {
                                    return DropdownMenuItem(
                                      value: menu,
                                      child: Text(menu),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    _sortBy = value!;
                                    setState(() {});
                                  },
                                  underline: const SizedBox(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      StreamBuilder<QuerySnapshot>(
                        stream: ref!.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Something wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No data Found!'));
                          }

                          var data = snapshot.data!.docs;

                          // product list
                          return GridView.builder(
                            shrinkWrap: true,
                            // padding: const EdgeInsets.all(16),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.sizeOf(context).width < 600
                                      ? 1
                                      : 5,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio:
                                  MediaQuery.sizeOf(context).width < 600
                                      ? 1
                                      : .8,
                            ),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              //
                              Map<String, dynamic> json =
                                  data[index].data() as Map<String, dynamic>;
                              ProductModel productModel =
                                  ProductModel.fromJson(json);

                              //
                              return InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  //
                                  context.goNamed(
                                    'product',
                                    pathParameters: {
                                      'category':
                                          productModel.category.toLowerCase(),
                                      'name': slugGenerator(productModel.name),
                                    },
                                    extra: productModel.id,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // image
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                          ),
                                          child: Image.network(
                                            productModel.images.isEmpty
                                                ? 'https://firebasestorage.googleapis.com/v0/b/abrar-shop.appspot.com/o/placeholder.png?alt=media&token=dc5ea06a-d65d-4689-9196-329781aef7d6'
                                                : productModel.images.first,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),

                                      const Divider(
                                        height: .5,
                                        thickness: .5,
                                      ),

                                      // const SizedBox(height: 2),

                                      // title
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 40,
                                              child: Text(
                                                productModel.name,
                                                textAlign: TextAlign.left,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                      height: 1.25,
                                                    ),
                                              ),
                                            ),

                                            const SizedBox(height: 10),

                                            //price
                                            Text(
                                              '$kTkSymbol ${productModel.salePrice.toStringAsFixed(0)}',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                height: 1,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 16),
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
