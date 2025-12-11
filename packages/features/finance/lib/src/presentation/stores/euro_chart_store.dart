import 'package:mobx/mobx.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/currency_chart.dart';
import '../../domain/use_cases/get_euro_history.dart';
import 'currency_chart_store_base.dart';

part 'euro_chart_store.g.dart';

@lazySingleton
@StoreConfig()
class EuroChartStore = _EuroChartStore with _$EuroChartStore;

abstract class _EuroChartStore with Store implements CurrencyChartStoreBase {
  final GetEuroHistory getEuroHistory;

  _EuroChartStore(this.getEuroHistory);

  @observable
  CurrencyChart? chart;

  @observable
  String? errorMessage;

  @computed
  CurrencyChart? get last24HoursChart => chart?.last24Hours();

  @action
  Future<void> loadChart() async {
    errorMessage = null;

    final cachedResult = await getEuroHistory.getCached();
    CurrencyChart? cachedChart;
    cachedResult.fold(
      (_) => null,
      (chart) => cachedChart = chart,
    );

    if (cachedChart != null) {
      chart = cachedChart;
    }

    final result = await getEuroHistory();

    result.fold(
      (failure) {
        errorMessage = failure.message;
        if (cachedChart == null) {
          chart = null;
        }
      },
      (loadedChart) {
        chart = loadedChart;
        errorMessage = null;
      },
    );
  }

  @action
  Future<void> refresh() async {
    await loadChart();
  }
}

