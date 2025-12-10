/// Currency Chart Point Entity
/// 
/// Domain katmanı - Saf Dart, Flutter'dan bağımsız
class CurrencyChartPoint {
  final double value;
  final DateTime createdAt;
  final String originalCreatedAt; // API'den gelen orijinal string (timezone korunur)

  const CurrencyChartPoint({
    required this.value,
    required this.createdAt,
    required this.originalCreatedAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CurrencyChartPoint &&
        other.value == value &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => value.hashCode ^ createdAt.hashCode;
}

