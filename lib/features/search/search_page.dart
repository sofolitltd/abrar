import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '/utils/constants/constants.dart';
import '../../models/product_model.dart';
import '../../providers/product_providers.dart';
import '../../routes/app_route.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(allProductsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Search Product')),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: asyncProducts.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (productList) {
            if (productList.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return Autocomplete<ProductModel>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<ProductModel>.empty();
                }
                final words = textEditingValue.text.toLowerCase().split(' ');
                return productList.where((product) {
                  return words.every(
                    (word) => product.name.toLowerCase().contains(word),
                  );
                });
              },
              displayStringForOption: (ProductModel option) => option.name,
              onSelected: (ProductModel product) {
                //
                context.push(AppRoute.productDetails.path, extra: product);
              },
              fieldViewBuilder:
                  (context, textController, focusNode, onFieldSubmitted) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Iconsax.search_favorite,
                            size: 20,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: textController,
                              focusNode: focusNode,
                              autofocus: true,
                              onSubmitted: (_) => onFieldSubmitted(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              decoration: InputDecoration(
                                hintText: ' Search product ...',
                                border: InputBorder.none,
                                suffix: GestureDetector(
                                  onTap: () => textController.clear(),
                                  child: const Icon(
                                    Iconsax.close_circle,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      child: Container(
                        height: MediaQuery.of(context).size.height - 32,
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.all(12),
                        child: ListView.separated(
                          itemCount: options.length,
                          separatorBuilder: (_, __) =>
                              const Divider(thickness: 0.5),
                          itemBuilder: (_, index) {
                            final option = options.elementAt(index);
                            return InkWell(
                              onTap: () {
                                //
                                context.push(
                                  AppRoute.productDetails.path,
                                  extra: option,
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    child: option.images.isNotEmpty
                                        ? Image.network(
                                            option.images[0],
                                            fit: BoxFit.cover,
                                          )
                                        : const Placeholder(),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '${option.regularPrice.toStringAsFixed(0)} $kTkSymbol',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 18,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
