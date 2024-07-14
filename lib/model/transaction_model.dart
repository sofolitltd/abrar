import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String title;
  final int amount;
  final String type;
  final String date;
  final DateTime time;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.time,
  });

  factory TransactionModel.fromJson(QueryDocumentSnapshot json) {
    return TransactionModel(
      title: json['title'],
      amount: json['amount'],
      type: json['type'],
      date: json['date'],
      time: (json['time'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
      'time': time,
    };
  }
}
