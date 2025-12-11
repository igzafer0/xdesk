import 'package:finance/finance.dart';
import 'package:flutter/material.dart';

/// Euro Chart Widget
///
/// EuroChartStore için wrapper widget.
/// Generic CurrencyChartWidget'ı kullanır.
class EuroChartWidget extends StatelessWidget {
  final EuroChartStore store;

  const EuroChartWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return CurrencyChartWidget(store: store);
  }
}
