import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';
import '../entities/currency_chart.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, CurrencyChart>> getDollarHistory();

  Future<Either<Failure, CurrencyChart>> getEuroHistory();

  Future<Either<Failure, CurrencyChart?>> getCachedDollarHistory();

  Future<Either<Failure, CurrencyChart?>> getCachedEuroHistory();
}
