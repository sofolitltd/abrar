import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTextDialog extends StatefulWidget {
  const AddTextDialog({super.key, required this.collection});
  final String collection;

  @override
  State<AddTextDialog> createState() => _AddTextDialogState();
}

class _AddTextDialogState extends State<AddTextDialog> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          Text(
            'Add ${widget.collection}',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          // all cat
          //   IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => const ProductCategory(),
          //             ));
          //       },
          //       icon: const Icon(Icons.description))
        ],
      ),
      content: SizedBox(
        height: 50,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  labelText: widget.collection,
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ${widget.collection}';
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
          onPressed: _isLoading ? null : _addText,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _addText() async {
    final String name = _textController.text.trim();

    // Check if the category already exists
    final QuerySnapshot existingCategories = await FirebaseFirestore.instance
        .collection(widget.collection)
        .where('name', isEqualTo: name)
        .get();

    if (existingCategories.docs.isNotEmpty) {
      Fluttertoast.showToast(msg: '${widget.collection} already exists');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection(widget.collection).add({
        'name': name.trim(),
      });
      _textController.clear();
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

showAddDialog(BuildContext context, {required String collection}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddTextDialog(collection: collection);
    },
  );
}
