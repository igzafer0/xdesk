import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../entities/currency_chart.dart';
import '../repositories/currency_repository.dart';

@lazySingleton
class GetEuroHistory {
  final CurrencyRepository repository;

  GetEuroHistory(this.repository);

  Future<Either<Failure, CurrencyChart>> call() {
    return repository.getEuroHistory();
  }

  Future<Either<Failure, CurrencyChart?>> getCached() {
    return repository.getCachedEuroHistory();
  }
}

