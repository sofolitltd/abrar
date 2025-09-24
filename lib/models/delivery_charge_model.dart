import 'package:intl/intl.dart';

class DeliveryChargeModel {
  final String id;
  final String title;
  final String district;
  final double deliveryFee;
  final int minDays;
  final int maxDays;

  DeliveryChargeModel({
    required this.id,
    required this.title,
    required this.district,
    required this.deliveryFee,
    required this.minDays,
    required this.maxDays,
  });

  factory DeliveryChargeModel.fromMap(Map<String, dynamic> map, String docId) {
    return DeliveryChargeModel(
      id: docId,
      title: map['title'] ?? '',
      district: map['district'] ?? '',
      deliveryFee: (map['deliveryFee'] ?? 0).toDouble(),
      minDays: map['minDays'] ?? 0,
      maxDays: map['maxDays'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'district': district,
      'deliveryFee': deliveryFee,
      'minDays': minDays,
      'maxDays': maxDays,
    };
  }

  /// Returns estimated delivery as calendar dates
  String getEstimatedDeliveryDates() {
    final now = DateTime.now();
    final minDate = now.add(Duration(days: minDays));
    final maxDate = now.add(Duration(days: maxDays));
    final formatter = DateFormat('d MMM'); // e.g., 27 Sep

    return minDate == maxDate
        ? formatter.format(minDate)
        : '${formatter.format(minDate)}–${formatter.format(maxDate)}';
  }
}
