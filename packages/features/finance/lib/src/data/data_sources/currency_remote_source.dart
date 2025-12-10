import 'package:fpdart/fpdart.dart';
import 'package:core/core.dart';
import '../dtos/currency_chart_point_dto.dart';

/// Currency Remote Data Source
/// 
/// API çağrılarını yapar
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

    return response.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final data = response.data as List<dynamic>;
          final dtos = data
              .map((json) => CurrencyChartPointDTO.fromJson(
                    json as Map<String, dynamic>,
                  ))
              .toList();
          return Right(dtos);
        } catch (e) {
          return Left(
            UnknownFailure(
              message: 'Veri parse edilemedi: ${e.toString()}',
              originalError: e,
            ),
          );
        }
      },
    );
  }

  /// Euro history verilerini API'den çeker
  /// 
  /// Returns Either<Failure, List<CurrencyChartPointDTO>>
  Future<Either<Failure, List<CurrencyChartPointDTO>>> getEuroHistory() async {
    final response = await apiClient.get<List<dynamic>>(
      '/eurohistory',
    );

    return response.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final data = response.data as List<dynamic>;
          final dtos = data
              .map((json) => CurrencyChartPointDTO.fromJson(
                    json as Map<String, dynamic>,
                  ))
              .toList();
          return Right(dtos);
        } catch (e) {
          return Left(
            UnknownFailure(
              message: 'Veri parse edilemedi: ${e.toString()}',
              originalError: e,
            ),
          );
        }
      },
    );
  }
}

