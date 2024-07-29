import 'package:abara/model/transaction_model.dart';
import 'package:abara/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../product/widgets/delete_dialog.dart';
import 'components/add_transaction.dart';

class SingleTransaction extends StatefulWidget {
  const SingleTransaction({super.key});

  @override
  State<SingleTransaction> createState() => _SingleTransactionState();
}

class _SingleTransactionState extends State<SingleTransaction> {
  @override
  Widget build(BuildContext context) {
    var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    //
    return Scaffold(
      //
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

      //
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('transactions')
              .where('date', isEqualTo: currentDate)
              .orderBy('time', descending: true)
              .snapshots(),
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

            //
            int totalIn = 0;
            int totalOut = 0;

            //
            for (var doc in data) {
              TransactionModel transaction = TransactionModel.fromJson(doc);
              if (transaction.type == "in") {
                totalIn += transaction.amount;
              } else {
                totalOut += transaction.amount;
              }
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // current
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 105,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            Text(
                              'Current Cash',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              '$kTkSymbol ${(totalIn - totalOut).toStringAsFixed(0)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    height: 1,
                                  ),
                            ),

                            const SizedBox(height: 12),

                            // date
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                //
                                const Icon(
                                  Icons.watch_later_outlined,
                                  size: 20,
                                  color: Colors.blueGrey,
                                ),

                                const SizedBox(width: 2),
                                //
                                Text(
                                  currentDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                        fontSize: 22,
                                        height: 1,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // in / out
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 105,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),

                            //
                            Text(
                              'Total In',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                            ),

                            const SizedBox(height: 4),

                            //
                            Text(
                              '$kTkSymbol $totalIn',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    height: 1,
                                    fontSize: 18,
                                  ),
                            ),

                            const SizedBox(height: 4),
                            const Divider(height: 1),
                            const SizedBox(height: 8),

                            // out
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Text(
                                  'Total Out',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                      ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  '$kTkSymbol ${(totalOut).toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        height: 1,
                                        fontSize: 18,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                //
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: data.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      TransactionModel transActionModel =
                          TransactionModel.fromJson(data[index]);

                      //
                      return GestureDetector(
                        onLongPress: () async {
                          await showDeleteDialog(
                            context: context,
                            collectionName: 'transactions',
                            id: data[index].id,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(8),
                            color: transActionModel.type == "in"
                                ? Colors.green.shade50.withOpacity(.8)
                                : Colors.red.shade50.withOpacity(.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    transActionModel.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),

                                  //
                                  Text(
                                    transActionModel.type.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                          color: transActionModel.type == "in"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$kTkSymbol ${transActionModel.amount.toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(),
                                  ),
                                  Text(
                                    DateFormat('hh:mm a  dd/MM/yy').format(
                                        transActionModel.time.toLocal()),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
