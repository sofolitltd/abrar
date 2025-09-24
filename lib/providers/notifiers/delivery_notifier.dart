import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/delivery_charge_model.dart';

class DeliveryNotifier extends Notifier<List<DeliveryChargeModel>> {
  @override
  List<DeliveryChargeModel> build() {
    fetchDeliveryOptions();
    return [];
  }

  final _firestore = FirebaseFirestore.instance;

  Future<void> fetchDeliveryOptions() async {
    final snapshot = await _firestore.collection('deliveryCharges').get();

    final options = snapshot.docs.map((doc) {
      return DeliveryChargeModel.fromMap(doc.data(), doc.id);
    }).toList();

    state = options;
  }
}

final deliveryProvider =
    NotifierProvider<DeliveryNotifier, List<DeliveryChargeModel>>(
      DeliveryNotifier.new,
    );

// Change state type from Map<String, dynamic>? to DeliveryChargeModel?
class SelectedDeliveryNotifier extends Notifier<DeliveryChargeModel?> {
  @override
  DeliveryChargeModel? build() {
    // We will listen to address changes in the UI via a ref.listen
    return null;
  }

  void set(DeliveryChargeModel delivery) {
    state = delivery;
  }
}

// Provider
final selectedDeliveryProvider =
    NotifierProvider<SelectedDeliveryNotifier, DeliveryChargeModel?>(
      SelectedDeliveryNotifier.new,
    );
