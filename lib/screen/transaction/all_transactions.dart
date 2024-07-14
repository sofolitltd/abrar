import 'package:abara/model/transaction_model.dart';
import 'package:abara/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'components/add_transaction.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  State<AllTransactions> createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  String _selectedType = '';
  String _selectedDate = '';
  bool _showClearButton = false;

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> ref =
        FirebaseFirestore.instance.collection('transactions');

    // Apply filters if any are selected
    if (_selectedDate.isNotEmpty) {
      ref = ref.where('date', isEqualTo: _selectedDate);
      _showClearButton = true; // Show clear button when date is selected
    } else if (_selectedType.isNotEmpty) {
      ref = ref.where('type', isEqualTo: _selectedType);
      _showClearButton = true; // Show clear button when type is selected
    } else {
      _showClearButton = false; // Hide clear button when no filters are applied
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransaction(),
            ),
          );
        },
        label: const Text('Add Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                // calender
                OutlinedButton.icon(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      setState(() {
                        _selectedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);
                      });
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    visualDensity: const VisualDensity(vertical: -1),
                    padding: const EdgeInsets.only(right: 16, left: 8),
                    backgroundColor:
                        _selectedDate.isEmpty ? null : Colors.purple.shade100,
                  ),
                  label: const Text('Monthly '),
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    size: 20,
                  ),
                ),
                const Spacer(),

                // in
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: const VisualDensity(vertical: -1),
                    padding: const EdgeInsets.only(right: 16, left: 8),
                    backgroundColor:
                        _selectedType == 'in' ? Colors.green.shade100 : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedType = (_selectedType == "in") ? "" : "in";
                      _selectedDate =
                          ""; // Clear date filter when selecting type
                    });
                  },
                  label: const Text(
                    'IN',
                    style: TextStyle(color: Colors.green),
                  ),
                  icon: const Icon(
                    Icons.add_outlined,
                    size: 18,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),

                //out
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    visualDensity: const VisualDensity(vertical: -1),
                    padding: const EdgeInsets.only(right: 16, left: 8),
                    backgroundColor:
                        _selectedType == 'out' ? Colors.red.shade100 : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedType = (_selectedType == "out") ? "" : "out";
                      _selectedDate =
                          ""; // Clear date filter when selecting type
                    });
                  },
                  label: const Text(
                    'OUT',
                    style: TextStyle(color: Colors.red),
                  ),
                  icon: const Icon(
                    Icons.remove_outlined,
                    size: 18,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const Divider(),
            //
            Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate.isEmpty ? "Transactions" : _selectedDate,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                  ),

                  //
                  // Clear filter button
                  if (_showClearButton)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = '';
                          _selectedDate = '';
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: const EdgeInsets.only(left: 8, right: 6),
                        child: const Row(
                          children: [
                            Text('Clear'),
                            SizedBox(width: 4),
                            Icon(
                              Icons.clear,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 4),
            //
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: ref.orderBy('time', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 56,
                    );
                  }
                  var data = snapshot.data!.docs;
                  if (data.isEmpty) {
                    return const Center(child: Text('No data Found!'));
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      TransactionModel transactionModel =
                          TransactionModel.fromJson(data[index]);
                      return Container(
                        padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                          color: transactionModel.type == "in"
                              ? Colors.green.shade50.withOpacity(.8)
                              : Colors.red.shade50.withOpacity(.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  transactionModel.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  transactionModel.type.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: transactionModel.type == "in"
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$kTkSymbol ${transactionModel.amount.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(),
                                ),
                                Text(
                                  DateFormat('hh:mm a  dd/MM/yy')
                                      .format(transactionModel.time.toLocal()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
