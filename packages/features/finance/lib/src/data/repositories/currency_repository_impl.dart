import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../../domain/entities/currency_chart.dart';
import '../../domain/entities/currency_chart_point.dart';
import '../../domain/repositories/currency_repository.dart';
import '../data_sources/currency_remote_source.dart';
import '../dtos/currency_chart_point_dto.dart';

List<CurrencyChartPointDTO> parseCurrencyDataFromCache(List<dynamic> cachedData) {
  return cachedData
      .map((json) {
        final jsonMap = json is Map
            ? Map<String, dynamic>.from(json as Map)
            : json as Map<String, dynamic>;
        return CurrencyChartPointDTO.fromJson(jsonMap);
      })
      .toList();
}

@LazySingleton(as: CurrencyRepository)
class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteSource remoteSource;
  final LocalStorage cache;

  static const String _dollarCacheKey = 'dollar_history';
  static const String _euroCacheKey = 'euro_history';

  CurrencyRepositoryImpl({
    required this.remoteSource,
    required this.cache,
  });

  @override
  Future<Either<Failure, CurrencyChart>> getDollarHistory() async {
    return _getCurrencyHistory(
      cacheKey: _dollarCacheKey,
      remoteCall: () => remoteSource.getDollarHistory(),
      currency: 'USD',
    );
  }

  @override
  Future<Either<Failure, CurrencyChart>> getEuroHistory() async {
    return _getCurrencyHistory(
      cacheKey: _euroCacheKey,
      remoteCall: () => remoteSource.getEuroHistory(),
      currency: 'EUR',
    );
  }

  @override
  Future<Either<Failure, CurrencyChart?>> getCachedDollarHistory() async {
    return _getCachedCurrencyHistory(
      cacheKey: _dollarCacheKey,
      currency: 'USD',
    );
  }

  @override
  Future<Either<Failure, CurrencyChart?>> getCachedEuroHistory() async {
    return _getCachedCurrencyHistory(
      cacheKey: _euroCacheKey,
      currency: 'EUR',
    );
  }

  Future<Either<Failure, CurrencyChart?>> _getCachedCurrencyHistory({
    required String cacheKey,
    required String currency,
  }) async {
    final cacheResult = await cache.get<List<dynamic>>(key: cacheKey);

    final cacheEither = cacheResult.fold(
      (failure) => Left<Failure, List<dynamic>>(failure),
      (cachedData) {
        if (cachedData == null || cachedData.isEmpty) {
          return Right<Failure, List<dynamic>>(<dynamic>[]);
        }
        return Right<Failure, List<dynamic>>(cachedData);
      },
    );

    if (cacheEither.isLeft()) {
      return cacheEither.map((r) => null);
    }

    final cachedData = cacheEither.getOrElse((l) => <dynamic>[]);
    if (cachedData.isEmpty) {
      return Right<Failure, CurrencyChart?>(null);
    }

    try {
      final dtos = await compute(parseCurrencyDataFromCache, cachedData);
      final chart = _mapToEntity(dtos, currency: currency);
      return Right<Failure, CurrencyChart?>(chart);
    } catch (e) {
      return Right<Failure, CurrencyChart?>(null);
    }
  }

  Future<Either<Failure, CurrencyChart>> _getCurrencyHistory({
    required String cacheKey,
    required Future<Either<Failure, List<CurrencyChartPointDTO>>> Function() remoteCall,
    required String currency,
  }) async {
    final remoteResult = await remoteCall();

    if (remoteResult.isLeft()) {
      final failure = remoteResult.fold(
        (f) => f,
        (r) => UnknownFailure(message: 'Beklenmeyen hata'),
      );
      return Left<Failure, CurrencyChart>(failure);
    }

    final dtos = remoteResult.getOrElse((l) => <CurrencyChartPointDTO>[]);

    final jsonList = dtos.map((dto) => dto.toJson()).toList();
    await cache.save(key: cacheKey, value: jsonList);

    final chart = _mapToEntity(dtos, currency: currency);
    return Right(chart);
  }

  CurrencyChart _mapToEntity(
    List<CurrencyChartPointDTO> dtos, {
    required String currency,
  }) {
    final points = dtos.map((dto) {
      return CurrencyChartPoint(
        value: dto.value,
        createdAt: DateTime.parse(dto.createdAt),
        originalCreatedAt: dto.createdAt,
      );
    }).toList();

    return CurrencyChart(
      currency: currency,
      points: points,
    );
  }
}

