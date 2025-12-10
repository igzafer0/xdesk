import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:finance/finance.dart';

part 'home_store.g.dart';

/// Home Store
///
/// Ana sayfa state'ini ve otomatik yenileme mantığını yönetir.
@StoreConfig()
class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  final DollarChartStore dollarChartStore;
  final EuroChartStore euroChartStore;

  Timer? _refreshTimer;
  static const Duration _refreshInterval = Duration(seconds: 10);

  _HomeStore({
    required this.dollarChartStore,
    required this.euroChartStore,
  });

  /// Chart'ları yükler ve otomatik yenilemeyi başlatır
  @action
  void initialize() {
    // İlk yükleme
    dollarChartStore.loadChart();
    euroChartStore.loadChart();

    // Otomatik yenileme timer'ını başlat
    _refreshTimer = Timer.periodic(
      _refreshInterval,
      (_) {
        dollarChartStore.loadChart();
        euroChartStore.loadChart();
      },
    );
  }

  /// Otomatik yenilemeyi durdurur
  @action
  void dispose() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }
}

