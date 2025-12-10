import 'package:dio/dio.dart';
import 'failures.dart';

/// Maps various error types to Failure objects
///
/// Dio, Exception ve diğer hata tiplerini Failure nesnelerine çevirir.
class ErrorMapper {
  /// Maps DioException to appropriate Failure
  static Failure mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          message: 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.',
          code: 'TIMEOUT',
          originalError: error,
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getServerErrorMessage(
          statusCode,
          error.response?.data,
        );

        return ServerFailure(
          message: message,
          statusCode: statusCode,
          code: statusCode?.toString(),
          originalError: error,
        );

      case DioExceptionType.cancel:
        return NetworkFailure(
          message: 'İstek iptal edildi.',
          code: 'CANCELLED',
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'İnternet bağlantısı yok. Lütfen bağlantınızı kontrol edin.',
          code: 'NO_CONNECTION',
          originalError: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          message: 'Güvenlik sertifikası hatası.',
          code: 'BAD_CERTIFICATE',
          originalError: error,
        );

      case DioExceptionType.unknown:
        return UnknownFailure(
          message: 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.',
          code: 'UNKNOWN',
          originalError: error,
        );
    }
  }

  /// Maps generic Exception to Failure
  static Failure mapException(Exception exception) {
    if (exception is DioException) {
      return mapDioException(exception);
    }

    return UnknownFailure(
      message: 'Bir hata oluştu: ${exception.toString()}',
      originalError: exception,
    );
  }

  /// Maps generic Error to Failure
  static Failure mapError(Error error) {
    return UnknownFailure(
      message: 'Beklenmeyen bir hata oluştu: ${error.toString()}',
      originalError: error,
    );
  }

  /// Gets user-friendly error message from server response
  static String _getServerErrorMessage(int? statusCode, dynamic data) {
    // Önce data'dan mesaj almayı dene
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'] ?? data['msg'];
      if (message != null && message is String) {
        return message;
      }
    }

    // Status code'a göre varsayılan mesajlar
    switch (statusCode) {
      case 400:
        return 'Geçersiz istek. Lütfen bilgilerinizi kontrol edin.';
      case 401:
        return 'Oturum süreniz dolmuş. Lütfen tekrar giriş yapın.';
      case 403:
        return 'Bu işlem için yetkiniz bulunmamaktadır.';
      case 404:
        return 'Aranan kayıt bulunamadı.';
      case 409:
        return 'Bu işlem çakışma yaratıyor. Lütfen tekrar deneyin.';
      case 422:
        return 'Gönderilen veriler geçersiz. Lütfen kontrol edin.';
      case 429:
        return 'Çok fazla istek gönderildi. Lütfen bir süre sonra tekrar deneyin.';
      case 500:
        return 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
      case 502:
      case 503:
      case 504:
        return 'Servis şu anda kullanılamıyor. Lütfen daha sonra tekrar deneyin.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
