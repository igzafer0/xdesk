import 'package:mobx/mobx.dart';
import '../../domain/entities/currency_chart.dart';
import '../../domain/use_cases/get_euro_history.dart';

part 'euro_chart_store.g.dart';

/// Euro Chart Store
/// 
/// MobX store - State yönetimi
@StoreConfig()
class EuroChartStore = _EuroChartStore with _$EuroChartStore;

abstract class _EuroChartStore with Store {
  final GetEuroHistory getEuroHistory;

  _EuroChartStore(this.getEuroHistory);

  @observable
  CurrencyChart? chart;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  /// Euro history verilerini yükler
  @action
  Future<void> loadChart() async {
    isLoading = true;
    errorMessage = null;

    final result = await getEuroHistory();

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

    isLoading = false;
  }

  /// Chart'ı yeniler
  @action
  Future<void> refresh() async {
    await loadChart();
  }
}

