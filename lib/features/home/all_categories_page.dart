import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '/providers/category_providers.dart';
import '/routes/app_route.dart';
import '../../routes/router_config.dart';

class AllCategoriesPage extends ConsumerWidget {
  const AllCategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentAsync = ref.watch(parentCategoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: parentAsync.when(
        data: (parents) {
          if (parents.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8),
            child: ListView.builder(
              itemCount: parents.length,
              itemBuilder: (context, index) {
                final parent = parents[index];

                return ExpansionTile(
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey, width: .2),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: parent.imageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(parent.imageUrl)
                            : const AssetImage('assets/images/no_image.png')
                                  as ImageProvider,
                      ),
                    ),
                  ),
                  title: Text(parent.name),
                  childrenPadding: EdgeInsets.only(left: 24, right: 12),
                  children: [
                    //
                    GestureDetector(
                      onTap: () {
                        context.push(
                          AppRoute.products.path,
                          extra: ProductsPageParams(category: parent.name),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: .2),
                            bottom: BorderSide(color: Colors.grey, width: .2),
                          ),
                        ),
                        child: Row(
                          spacing: 12,
                          children: [
                            Container(
                              height: 32,
                              width: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: .2,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: parent.imageUrl.isNotEmpty
                                      ? CachedNetworkImageProvider(
                                          parent.imageUrl,
                                        )
                                      : const AssetImage(
                                              'assets/images/no_image.png',
                                            )
                                            as ImageProvider,
                                ),
                              ),
                            ),
                            Expanded(child: Text('All ${parent.name}')),
                            IconButton(
                              icon: const Icon(
                                Icons.keyboard_arrow_right_rounded,
                              ),
                              onPressed: () {
                                // Navigate to subcategory products
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    //
                    Consumer(
                      builder: (context, ref, _) {
                        final subAsync = ref.watch(
                          subCategoriesStreamProvider(parent.name), //
                        );

                        return subAsync.when(
                          data: (subs) {
                            return subs.isEmpty
                                ? SizedBox()
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: subs.length,
                                    itemBuilder: (context, subIndex) {
                                      final sub = subs[subIndex];

                                      //
                                      return GestureDetector(
                                        onTap: () {
                                          //
                                          context.push(
                                            AppRoute.products.path,
                                            extra: ProductsPageParams(
                                              category: sub.name,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Colors.grey,
                                                width: .2,
                                              ),
                                              bottom: BorderSide(
                                                color: Colors.grey,
                                                width: .2,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            spacing: 12,
                                            children: [
                                              Container(
                                                height: 32,
                                                width: 32,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                    width: .2,
                                                  ),
                                                  image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image:
                                                        sub.imageUrl.isNotEmpty
                                                        ? CachedNetworkImageProvider(
                                                            sub.imageUrl,
                                                          )
                                                        : const AssetImage(
                                                                'assets/images/no_image.png',
                                                              )
                                                              as ImageProvider,
                                                  ),
                                                ),
                                              ),

                                              Expanded(child: Text(sub.name)),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons
                                                      .keyboard_arrow_right_rounded,
                                                ),
                                                onPressed: () {
                                                  // Navigate to subcategory products
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                          loading: () =>
                              const Padding(padding: EdgeInsets.all(0)),
                          error: (e, _) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Error: $e'),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
