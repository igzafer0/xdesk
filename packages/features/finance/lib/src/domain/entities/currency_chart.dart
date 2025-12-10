import 'currency_chart_point.dart';

/// Currency Chart Entity
/// 
/// Domain katmanı - Saf Dart, Flutter'dan bağımsız
class CurrencyChart {
  final String currency;
  final List<CurrencyChartPoint> points;

  const CurrencyChart({
    required this.currency,
    required this.points,
  });

  /// Son değer
  double? get lastValue => points.isNotEmpty ? points.last.value : null;

  /// İlk değer
  double? get firstValue => points.isNotEmpty ? points.first.value : null;

  /// Değişim yüzdesi
  double? get changePercent {
    if (firstValue == null || lastValue == null || firstValue == 0) {
      return null;
    }
    return ((lastValue! - firstValue!) / firstValue!) * 100;
  }

  /// Son 24 saatlik verileri döndürür
  /// 
  /// API'den gelen tarih formatını olduğu gibi kullanır (GMT+0'a çevirmez)
  CurrencyChart last24Hours() {
    if (points.isEmpty) {
      return CurrencyChart(currency: currency, points: []);
    }

    // En son noktanın tarihini al (API'den gelen format)
    final lastPoint = points.last;
    final last24Hours = lastPoint.createdAt.subtract(const Duration(hours: 24));

    final filteredPoints = points
        .where((point) => point.createdAt.isAfter(last24Hours) || 
                         point.createdAt.isAtSameMomentAs(last24Hours))
        .toList();

    return CurrencyChart(
      currency: currency,
      points: filteredPoints,
    );
  }
}

