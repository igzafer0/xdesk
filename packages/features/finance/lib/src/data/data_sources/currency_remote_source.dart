import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:core/core.dart';
import '../dtos/currency_chart_point_dto.dart';

/// Isolate'te çalışacak JSON parsing fonksiyonu (top-level olmalı)
List<CurrencyChartPointDTO> parseCurrencyData(List<dynamic> data) {
  return data
      .map((json) => CurrencyChartPointDTO.fromJson(
            json as Map<String, dynamic>,
          ))
      .toList();
}

/// Currency Remote Data Source
/// 
/// API çağrılarını yapar
@lazySingleton
class CurrencyRemoteSource {
  final ApiClient apiClient;

  CurrencyRemoteSource(this.apiClient);

  /// Dolar history verilerini API'den çeker
  /// 
  /// Returns Either<Failure, List<CurrencyChartPointDTO>>
  Future<Either<Failure, List<CurrencyChartPointDTO>>> getDollarHistory() async {
    final response = await apiClient.get<List<dynamic>>(
      '/dolarhistory',
    );

    // fold() sync, async işlemi dışarıda yap
    final either = response.fold(
      (failure) => Left<Failure, List<dynamic>>(failure),
      (response) {
        try {
          final data = response.data as List<dynamic>;
          return Right<Failure, List<dynamic>>(data);
        } catch (e) {
          return Left<Failure, List<dynamic>>(
            UnknownFailure(
              message: 'Veri parse edilemedi: ${e.toString()}',
              originalError: e,
            ),
          );
        }
      },
    );

    // Async işlemi (compute) fold dışında yap
    if (either.isLeft()) {
      return either.fold(
        (failure) => Left<Failure, List<CurrencyChartPointDTO>>(failure),
        (data) => Left<Failure, List<CurrencyChartPointDTO>>(
          UnknownFailure(message: 'Beklenmeyen hata'),
        ),
      );
    }
    
    try {
      final data = either.getOrElse((l) => <dynamic>[]);
      final dtos = await compute<List<dynamic>, List<CurrencyChartPointDTO>>(
        parseCurrencyData,
        data,
      );
      return Right(dtos);
    } catch (e) {
      return Left<Failure, List<CurrencyChartPointDTO>>(
        UnknownFailure(
          message: 'Veri parse edilemedi: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }

  /// Euro history verilerini API'den çeker
  /// 
  /// Returns Either<Failure, List<CurrencyChartPointDTO>>
  Future<Either<Failure, List<CurrencyChartPointDTO>>> getEuroHistory() async {
    final response = await apiClient.get<List<dynamic>>(
      '/eurohistory',
    );

    // fold() sync, async işlemi dışarıda yap
    final either = response.fold(
      (failure) => Left<Failure, List<dynamic>>(failure),
      (response) {
        try {
          final data = response.data as List<dynamic>;
          return Right<Failure, List<dynamic>>(data);
        } catch (e) {
          return Left<Failure, List<dynamic>>(
            UnknownFailure(
              message: 'Veri parse edilemedi: ${e.toString()}',
              originalError: e,
            ),
          );
        }
      },
    );

    // Async işlemi (compute) fold dışında yap
    if (either.isLeft()) {
      return either.fold(
        (failure) => Left<Failure, List<CurrencyChartPointDTO>>(failure),
        (data) => Left<Failure, List<CurrencyChartPointDTO>>(
          UnknownFailure(message: 'Beklenmeyen hata'),
        ),
      );
    }
    
    try {
      final data = either.getOrElse((l) => <dynamic>[]);
      final dtos = await compute<List<dynamic>, List<CurrencyChartPointDTO>>(
        parseCurrencyData,
        data,
      );
      return Right(dtos);
    } catch (e) {
      return Left<Failure, List<CurrencyChartPointDTO>>(
        UnknownFailure(
          message: 'Veri parse edilemedi: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}

