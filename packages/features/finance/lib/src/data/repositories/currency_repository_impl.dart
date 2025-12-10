import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../../domain/entities/currency_chart.dart';
import '../../domain/entities/currency_chart_point.dart';
import '../../domain/repositories/currency_repository.dart';
import '../data_sources/currency_remote_source.dart';
import '../dtos/currency_chart_point_dto.dart';

/// Isolate'te çalışacak cache JSON parsing fonksiyonu (top-level olmalı)
List<CurrencyChartPointDTO> parseCurrencyDataFromCache(List<dynamic> cachedData) {
  return cachedData
      .map((json) => CurrencyChartPointDTO.fromJson(
            json as Map<String, dynamic>,
          ))
      .toList();
}

/// Currency Repository Implementation
/// 
/// Cache-first yaklaşımı: Önce cache, sonra API
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

  /// Ortak currency history getirme metodu
  Future<Either<Failure, CurrencyChart>> _getCurrencyHistory({
    required String cacheKey,
    required Future<Either<Failure, List<CurrencyChartPointDTO>>> Function() remoteCall,
    required String currency,
  }) async {
    // 1. Önce cache'den kontrol et (Cache-First)
    final cacheResult = await cache.get<List<dynamic>>(key: cacheKey);
    
    CurrencyChart? cachedChart;
    // fold() sync bir metod, async işlemi dışarıda yap
    final cacheEither = cacheResult.fold(
      (failure) => Left<Failure, List<dynamic>>(failure),
      (cachedData) {
        if (cachedData == null) {
          return Right<Failure, List<dynamic>>(<dynamic>[]);
        }
        return Right<Failure, List<dynamic>>(cachedData);
      },
    );

    // Async işlemi (compute) fold dışında yap
    if (cacheEither.isLeft()) {
      // Cache hatası - cachedChart null kalır, API'ye devam et
      cachedChart = null;
    } else {
      final cachedData = cacheEither.getOrElse((l) => <dynamic>[]);
      if (cachedData.isEmpty) {
        cachedChart = null;
      } else {
        try {
          // JSON parsing'i isolate'te yap
          final dtos = await compute(parseCurrencyDataFromCache, cachedData);
          cachedChart = _mapToEntity(dtos, currency: currency);
        } catch (e) {
          // Cache parse hatası - logla ve API'ye devam et
          // (Cache hatası kritik değil, API'den veri çekilebilir)
          debugPrint('Cache parse hatası ($currency): ${e.toString()}');
          cachedChart = null;
        }
      }
    }

    // 2. API'den güncel veriyi çek
    final remoteResult = await remoteCall();

    // API hatası - cache'de varsa onu döndür
    if (remoteResult.isLeft() && cachedChart != null) {
      return Right(cachedChart);
    }

    // API başarılı - veriyi işle
    if (remoteResult.isLeft()) {
      final failure = remoteResult.fold(
        (f) => f,
        (r) => UnknownFailure(message: 'Beklenmeyen hata'),
      );
      return Left<Failure, CurrencyChart>(failure);
    }
    
    final dtos = remoteResult.getOrElse((l) => <CurrencyChartPointDTO>[]);
    
    // 3. Cache'e kaydet
    final jsonList = dtos.map((dto) => dto.toJson()).toList();
    await cache.save(key: cacheKey, value: jsonList);

    // 4. Entity'ye dönüştür ve döndür
    final chart = _mapToEntity(dtos, currency: currency);
    return Right(chart);
  }

  /// DTO listesini Entity'ye dönüştürür
  CurrencyChart _mapToEntity(
    List<CurrencyChartPointDTO> dtos, {
    required String currency,
  }) {
    final points = dtos.map((dto) {
      return CurrencyChartPoint(
        value: dto.value,
        createdAt: DateTime.parse(dto.createdAt), // UTC için karşılaştırma
        originalCreatedAt: dto.createdAt, // API'den gelen orijinal string
      );
    }).toList();

    // Tarihe göre sırala (eski -> yeni)
    points.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return CurrencyChart(
      currency: currency,
      points: points,
    );
  }
}

