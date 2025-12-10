import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../entities/currency_chart.dart';
import '../repositories/currency_repository.dart';

/// Get Dollar History Use Case
/// 
/// Domain katmanı - İş mantığı burada
@lazySingleton
class GetDollarHistory {
  final CurrencyRepository repository;

  GetDollarHistory(this.repository);

  /// Dolar history verilerini getirir
  /// 
  /// Returns Either<Failure, CurrencyChart>
  Future<Either<Failure, CurrencyChart>> call() {
    return repository.getDollarHistory();
  }
}

