import 'package:abara/model/transaction_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//
class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _transactionType = 'In';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min, // Added for dialog layout
              children: [
                // amount
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _amountController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    //
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Transaction Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 10,
                          ),
                        ),
                        value: _transactionType,
                        onChanged: (String? newValue) {
                          // setState(() { // No need for setState in dialog
                          _transactionType = newValue!;
                          // });
                        },
                        items: <String>['In', 'Out']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                //name
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (val) {},
                ),

                const SizedBox(height: 24),

                // add btn
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});

                      // Get current date formatted
                      var today = DateTime.now().toLocal();
                      String currentDate =
                          DateFormat('dd/MM/yyyy').format(today);

                      // Prepare transaction model
                      TransactionModel transActionModel = TransactionModel(
                        title: _nameController.text.trim(),
                        amount: int.parse(_amountController.text.trim()),
                        type: _transactionType.toLowerCase(),
                        date: currentDate,
                        time: DateTime.now(),
                      );

                      //
                      String id =
                          DateTime.now().microsecondsSinceEpoch.toString();

                      // Add transaction data to 'history'
                      await FirebaseFirestore.instance
                          .collection('transactions')
                          .doc(id)
                          .set(transActionModel.toJson())
                          .then((value) async {
                        // Update total
                        // await FirebaseFirestore.instance
                        //     .collection('transactions')
                        //     .doc(currentDate)
                        //     .set({
                        //   'total': 0,
                        //   'time': DateTime.now(),
                        // });
                        if (kDebugMode) {
                          print('Add successfully');
                        }
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pop(context); // Close the dialog after adding
                      });
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator())
                      : const Text('Add Transaction'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
