// providers/selected_address_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/address_model.dart';

class SelectedAddressNotifier extends Notifier<AddressModel?> {
  @override
  AddressModel? build() => null; // initial value

  void setAddress(AddressModel? address) => state = address;
  void clear() => state = null;
}

final selectedAddressProvider =
    NotifierProvider<SelectedAddressNotifier, AddressModel?>(
      () => SelectedAddressNotifier(),
    );
