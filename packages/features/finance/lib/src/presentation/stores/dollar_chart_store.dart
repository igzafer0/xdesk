import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/currency_chart.dart';
import '../../domain/use_cases/get_dollar_history.dart';

part 'dollar_chart_store.g.dart';

/// Dollar Chart Store
/// 
/// MobX store - State yönetimi
@lazySingleton
@StoreConfig()
class DollarChartStore = _DollarChartStore with _$DollarChartStore;

abstract class _DollarChartStore with Store {
  final GetDollarHistory getDollarHistory;

  _DollarChartStore(this.getDollarHistory);

  @observable
  CurrencyChart? chart;

  @observable
  String? errorMessage;

  /// Dolar history verilerini yükler
  @action
  Future<void> loadChart() async {
    errorMessage = null;

    final result = await getDollarHistory();

    result.fold(
      (failure) {
        errorMessage = failure.message;
        chart = null;
      },
      (loadedChart) {
        chart = loadedChart;
        errorMessage = null;
      },
    );
  }

  /// Chart'ı yeniler
  @action
  Future<void> refresh() async {
    await loadChart();
  }
}

