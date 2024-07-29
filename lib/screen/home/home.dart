import 'package:abara/model/product_model.dart';
import 'package:abara/screen/home/category_details.dart';
import 'package:abara/screen/home/product_details.dart';
import 'package:abara/utils/constants.dart';
import 'package:abara/widgets/header.dart';
import 'package:abara/widgets/running_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/widgets/image_slider.dart';
import '../../model/category_model.dart';
import '../../model/image_model.dart';
import '../../widgets/custom_route.dart';

//

List<String> offers = [
  'assets/images/cover1.png',
  'assets/images/img2.png',
];

List products = [
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator , tpi ffsfsff fsfsfsf fsfs',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator aafafaf af',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator afafa afaf ad',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
  {
    'title': 'Ator',
    'image': 'assets/images/cover1.png',
    'price': '100',
  },
];

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      // drawer: Drawer(
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
      //       child: Column(
      //         children: [
      //           //
      //           const Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               // logo
      //               Text.rich(
      //                 TextSpan(
      //                     text: 'Abrar',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.blueAccent,
      //                       fontSize: 20,
      //                     ),
      //                     children: [
      //                       TextSpan(
      //                         text: ' Shop',
      //                         style: TextStyle(
      //                           fontWeight: FontWeight.w100,
      //                           color: Colors.black,
      //                         ),
      //                       )
      //                     ]),
      //               ),
      //
      //               //
      //               CloseButton(),
      //             ],
      //           ),
      //
      //           const Divider(height: 4),
      //
      //           const SizedBox(height: 8),
      //
      //           //
      //           // Expanded(
      //           //   child: ListView.separated(
      //           //     separatorBuilder: (_, __) {
      //           //       return const Divider(
      //           //         height: .5,
      //           //         thickness: .5,
      //           //         endIndent: 32,
      //           //       );
      //           //     },
      //           //     shrinkWrap: true,
      //           //     itemCount: categoryList.length,
      //           //     itemBuilder: (context, index) {
      //           //       return ExpansionTile(
      //           //         backgroundColor: Colors.blueGrey.shade50,
      //           //         shape: const Border(),
      //           //         title: Text(categoryList[index].name),
      //           //         visualDensity: const VisualDensity(
      //           //           vertical: -4,
      //           //           horizontal: -4,
      //           //         ),
      //           //         tilePadding: const EdgeInsets.only(left: 4),
      //           //         children: [
      //           //           ListView.builder(
      //           //             shrinkWrap: true,
      //           //             itemCount: categoryList[index].brands.length,
      //           //             itemBuilder: (context, index) {
      //           //               return ListTile(
      //           //                 onTap: () {
      //           //                   Navigator.pop(context);
      //           //                 },
      //           //                 title: Text(
      //           //                   categoryList[index].brands[index].name,
      //           //                 ),
      //           //                 visualDensity: const VisualDensity(
      //           //                   vertical: -4,
      //           //                   horizontal: -4,
      //           //                 ),
      //           //                 contentPadding:
      //           //                     const EdgeInsets.symmetric(horizontal: 8),
      //           //               );
      //           //             },
      //           //           ),
      //           //           const SizedBox(height: 4),
      //           //         ],
      //           //       );
      //           //     },
      //           //   ),
      //           // ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      //
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
                  child: Column(
                    children: [
                      // banner
                      if (MediaQuery.sizeOf(context).width < 600)
                        Column(
                          children: [
                            //
                            ImageSlider(images: sliderImageList),

                            // offer
                            const InfoImage(),
                          ],
                        )
                      else
                        Row(
                          children: [
                            //
                            Expanded(
                                flex: 5,
                                child: ImageSlider(images: sliderImageList)),

                            // offer
                            const Expanded(flex: 2, child: InfoImage()),
                          ],
                        ),

                      const SizedBox(height: 32),

                      // running text
                      const RunningText(),

                      const SizedBox(height: 24),

                      //
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Something wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(),
                            );
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No data Found!'));
                          }

                          var data = snapshot.data!.docs;

                          //
                          return Column(
                            children: [
                              //category title
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    //
                                    Text(
                                      'Category',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    //
                                    Text(
                                      'Get your products from category',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),

                              // category list
                              GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(16),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.sizeOf(context).width < 600
                                          ? 4
                                          : 8,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: .8,
                                  // MediaQuery.sizeOf(context).width < 600
                                  //     ? .8
                                  //     : 1.2,
                                ),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  //
                                  var json = data[index].data()
                                      as Map<String, dynamic>;
                                  CategoryModel categoryModel =
                                      CategoryModel.fromJson(json);
                                  //
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CustomPageRoute(
                                          builder: (context) => CategoryDetails(
                                              categoryModel: categoryModel),
                                        ),
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
                                        children: [
                                          //
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8),
                                              ),
                                              child: Image.network(
                                                // height: 40,
                                                // width: 40,
                                                categoryModel.imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 2),

                                          //
                                          Container(
                                            height: 36,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            alignment: Alignment.center,
                                            child: Text(
                                              categoryModel.name,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                height: 1.2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      //
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('products')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Something wrong'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SizedBox(),
                            );
                          }

                          if (snapshot.data!.docs.isEmpty) {
                            return const Center(child: Text('No data Found!'));
                          }

                          var data = snapshot.data!.docs;

                          //
                          //featured product
                          return Column(
                            children: [
                              //featured title
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    //
                                    Text(
                                      'Featured Products',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    //
                                    Text(
                                      'Check and Get your products',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 4),

                              // featured list
                              GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(16),
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.sizeOf(context).width < 600
                                          ? 2
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
                                  Map<String, dynamic> json = data[index].data()
                                      as Map<String, dynamic>;
                                  ProductModel productModel =
                                      ProductModel.fromJson(json);

                                  //
                                  return InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        CustomPageRoute(
                                          builder: (context) => ProductDetails(
                                              productModel: productModel),
                                        ),
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
                                              borderRadius:
                                                  const BorderRadius.only(
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      height: 1.2,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(height: 10),

                                                //price
                                                Text(
                                                  '$kTkSymbol ${productModel.salePrice}',
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
                              ),
                            ],
                          );
                        },
                      ),

                      //
                      const SizedBox(height: 24),
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

class InfoImage extends StatelessWidget {
  const InfoImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.sizeOf(context).width < 600 ? 2 : 1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: offerImageList.map(
        (images) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(images.imageUrl),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
