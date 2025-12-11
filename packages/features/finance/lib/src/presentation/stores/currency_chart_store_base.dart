import '../../domain/entities/currency_chart.dart';

/// Base interface for currency chart stores
/// 
/// Tüm currency chart store'ları bu interface'i implement etmelidir.
abstract class CurrencyChartStoreBase {
  CurrencyChart? get chart;
  String? get errorMessage;
  CurrencyChart? get last24HoursChart;
  Future<void> loadChart();
  Future<void> refresh();
}

