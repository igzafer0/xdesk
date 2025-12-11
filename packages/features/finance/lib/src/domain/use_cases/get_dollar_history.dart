import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../entities/currency_chart.dart';
import '../repositories/currency_repository.dart';

@lazySingleton
class GetDollarHistory {
  final CurrencyRepository repository;

  GetDollarHistory(this.repository);

  Future<Either<Failure, CurrencyChart>> call() {
    return repository.getDollarHistory();
  }

  Future<Either<Failure, CurrencyChart?>> getCached() {
    return repository.getCachedDollarHistory();
  }
}

