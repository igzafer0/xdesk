import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

/// Logging Interceptor
///
/// Development sırasında request/response loglarını gösterir.
/// Production'da kapatılabilir.
class LoggingInterceptor extends Interceptor {
  final bool enabled;

  LoggingInterceptor({this.enabled = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      debugPrint('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
      if (options.queryParameters.isNotEmpty) {
        debugPrint('Query Parameters: ${options.queryParameters}');
      }
      if (options.data != null) {
        debugPrint('Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
      );
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      debugPrint(
        '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
      );
      debugPrint('Error Message: ${err.message}');
    }
    super.onError(err, handler);
  }
}
