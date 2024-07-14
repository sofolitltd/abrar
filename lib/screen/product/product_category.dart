import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screen/product/components/add_category.dart';
import 'widgets/delete_dialog.dart';

class ProductCategory extends StatelessWidget {
  const ProductCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Category'),
      ),
      //
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showAddCategoryDialog(context, isShown: false);
        },
        label: const Text('Add Category'),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
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
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: data.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (context, index) {
                String name = data[index].get('name');

                //
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(name),
                    trailing: IconButton(
                      onPressed: () {
                        showDeleteDialog(
                            context: context,
                            id: data[index].id,
                            collectionName: 'categories');
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
