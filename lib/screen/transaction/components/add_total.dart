import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddTotalDialog extends StatefulWidget {
  const AddTotalDialog({super.key, required this.data});

  final DocumentSnapshot data;

  @override
  State<AddTotalDialog> createState() => _AddTotalDialogState();
}

class _AddTotalDialogState extends State<AddTotalDialog> {
  final TextEditingController _totalController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    _totalController.text = widget.data.get("total").toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // title
          Text(
            'Total',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      content: SizedBox(
        height: 50,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : TextFormField(
                controller: _totalController,
                decoration: const InputDecoration(
                  labelText: 'Total',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a total';
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
          onPressed: _isLoading ? null : _addTotal,
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _addTotal() async {
    final String total = _totalController.text.trim();

    setState(() {
      _isLoading = true;
    });

    String docID = widget.data.id;
    try {
      await FirebaseFirestore.instance
          .collection('transactions')
          .doc(docID)
          .update({
        'total': int.parse(_totalController.text.trim()),
      });
      _totalController.clear();
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

void showAddTotalDialog(BuildContext context,
    {required DocumentSnapshot data}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AddTotalDialog(data: data);
    },
  );
}
