import 'package:abara/screen/product/product_category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key, required this.isShown});
  final bool isShown;

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          Text(
            'Add Category',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          // all cat
          if (widget.isShown)
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProductCategory(),
                      ));
                },
                icon: const Icon(Icons.description))
        ],
      ),
      content: SizedBox(
        height: 50,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _addCategory,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _addCategory() async {
    final String categoryName = _categoryController.text.trim();

    // Check if the category already exists
    final QuerySnapshot existingCategories = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: categoryName)
        .get();

    if (existingCategories.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: 'Category already exists');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('categories').add({
        'name': categoryName.toUpperCase(),
      });
      _categoryController.clear();
      Navigator.pop(context);
    } catch (error) {
      print('Error adding category: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}

void showAddCategoryDialog(BuildContext context, {required bool isShown}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddCategoryDialog(isShown: isShown);
    },
  );
}
