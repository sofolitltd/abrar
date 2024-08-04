import 'package:abara/widgets/slug_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/category_model.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: Border(bottom: BorderSide(width: .1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Center(
        // Added Center widget
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Row(
            children: [
              //
              if (MediaQuery.sizeOf(context).width < 600)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      //
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
                  ),
                ),

              //
              GestureDetector(
                onTap: () {
                  if (GoRouterState.of(context).path != '/') {
                    context.goNamed('home');
                  }
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
                  if (GoRouterState.of(context).path != '/search') {
                    context.goNamed('search');
                  }
                },
                child: Container(
                  constraints: BoxConstraints(
                      minWidth:
                          MediaQuery.sizeOf(context).width < 600 ? 0 : 330),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: MediaQuery.sizeOf(context).width < 600
                          ? Colors.transparent
                          : Colors.black26,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                      if (MediaQuery.sizeOf(context).width > 600) ...[
                        const SizedBox(width: 4),
                        const Text(
                          ' Search here...',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
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

//
class DrawerSection extends StatelessWidget {
  const DrawerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Column(
          children: [
            //
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // logo
                Text.rich(
                  TextSpan(
                      text: 'Abrar',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 20,
                      ),
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

                //
                CloseButton(),
              ],
            ),

            const Divider(height: 8),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
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
                return Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, __) {
                      return const Divider(
                        height: .5,
                        thickness: .5,
                        endIndent: 32,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      //
                      var json = data[index].data() as Map<String, dynamic>;
                      CategoryModel categoryModel =
                          CategoryModel.fromJson(json);
                      //
                      return ExpansionTile(
                        backgroundColor: Colors.blueGrey.shade50,
                        shape: const Border(),
                        title: Text(categoryModel.name),
                        visualDensity: const VisualDensity(
                          vertical: -4,
                          horizontal: -4,
                        ),
                        tilePadding: const EdgeInsets.only(left: 4),
                        children: [
                          InkWell(
                            onTap: () {
                              context.goNamed(
                                'category',
                                pathParameters: {
                                  'category': slugGenerator(categoryModel.name)
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(8.0),
                              child: Text('All ${categoryModel.name}'),
                            ),
                          ),
                          // ListView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: categoryModel.brands.length,
                          //   itemBuilder: (context, index) {
                          //     return ListTile(
                          //       onTap: () {
                          //         Navigator.pop(context);
                          //       },
                          //       title: Text(
                          //         categoryList[index].brands[index].name,
                          //       ),
                          //       visualDensity: const VisualDensity(
                          //         vertical: -4,
                          //         horizontal: -4,
                          //       ),
                          //       contentPadding:
                          //       const EdgeInsets.symmetric(horizontal: 8),
                          //     );
                          //   },
                          // ),
                          const SizedBox(height: 4),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
