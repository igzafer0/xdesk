import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../entities/currency_chart.dart';
import '../repositories/currency_repository.dart';

/// Get Euro History Use Case
/// 
/// Domain katmanı - İş mantığı burada
@lazySingleton
class GetEuroHistory {
  final CurrencyRepository repository;

  GetEuroHistory(this.repository);

  /// Euro history verilerini getirir
  /// 
  /// Returns Either<Failure, CurrencyChart>
  Future<Either<Failure, CurrencyChart>> call() {
    return repository.getEuroHistory();
  }
}

