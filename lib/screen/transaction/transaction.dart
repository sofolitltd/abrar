import 'package:abara/screen/transaction/all_transactions.dart';
import 'package:abara/screen/transaction/single_transaction.dart';
import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Transactions"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily Transaction'),
              Tab(text: 'All Transactions'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SingleTransaction(),
            AllTransactions(),
          ],
        ),
      ),
    );
  }
}
