import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../errors/error_mapper.dart';
import '../errors/failures.dart';
import 'interceptors/logging_interceptor.dart';

/// API Client Configuration
class ApiConfig {
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final Duration sendTimeout;
  final Map<String, String>? defaultHeaders;

  const ApiConfig({
    required this.baseUrl,
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
    this.sendTimeout = const Duration(seconds: 30),
    this.defaultHeaders,
  });
}

/// Dio-based API Client
///
/// Tüm network işlemleri için merkezi client.
/// Interceptors ve error handling içerir.
/// Tüm istekler auth olmadan yapılır.
class ApiClient {
  late final Dio _dio;
  final ApiConfig config;

  ApiClient({
    required this.config,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?config.defaultHeaders,
        },
      ),
    );

    // Interceptors ekle
    _dio.interceptors.add(LoggingInterceptor());
  }

  /// Gets the underlying Dio instance
  Dio get dio => _dio;

  /// Performs a GET request
  /// 
  /// Returns Either<Failure, Response<T>>
  Future<Either<Failure, Response<T>>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on Exception catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(ErrorMapper.mapError(e as Error));
    }
  }

  /// Performs a POST request
  /// 
  /// Returns Either<Failure, Response<T>>
  Future<Either<Failure, Response<T>>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on Exception catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(ErrorMapper.mapError(e as Error));
    }
  }

  /// Performs a PUT request
  /// 
  /// Returns Either<Failure, Response<T>>
  Future<Either<Failure, Response<T>>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on Exception catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(ErrorMapper.mapError(e as Error));
    }
  }

  /// Performs a DELETE request
  /// 
  /// Returns Either<Failure, Response<T>>
  Future<Either<Failure, Response<T>>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(ErrorMapper.mapDioException(e));
    } on Exception catch (e) {
      return Left(ErrorMapper.mapException(e));
    } catch (e) {
      return Left(ErrorMapper.mapError(e as Error));
    }
  }
}

