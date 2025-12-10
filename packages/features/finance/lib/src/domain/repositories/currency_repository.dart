import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';
import '../entities/currency_chart.dart';

/// Currency Repository Interface
/// 
/// Domain katmanı - Sadece interface, implementation yok
abstract class CurrencyRepository {
  /// Dolar history verilerini getirir
  /// 
  /// Returns Either<Failure, CurrencyChart>
  Future<Either<Failure, CurrencyChart>> getDollarHistory();

  /// Euro history verilerini getirir
  /// 
  /// Returns Either<Failure, CurrencyChart>
  Future<Either<Failure, CurrencyChart>> getEuroHistory();
}

