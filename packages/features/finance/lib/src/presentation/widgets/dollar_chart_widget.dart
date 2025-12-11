import 'package:finance/finance.dart';
import 'currency_chart_widget.dart';

/// Dollar Chart Widget
/// 
/// DollarChartStore için wrapper widget.
/// Generic CurrencyChartWidget'ı kullanır.
class DollarChartWidget extends StatelessWidget {
  final DollarChartStore store;

  const DollarChartWidget({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return CurrencyChartWidget(store: store);
  }
}
