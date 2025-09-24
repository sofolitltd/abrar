import 'package:flutter_riverpod/flutter_riverpod.dart';

final promoNotifierProvider = NotifierProvider<PromoNotifier, double>(
  PromoNotifier.new,
);

class PromoNotifier extends Notifier<double> {
  @override
  double build() => 0.0;

  void setDiscount(double value) => state = value;

  void clear() => state = 0.0;
}
