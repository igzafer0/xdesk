import 'package:dio/dio.dart';

/// Auth Interceptor
/// 
/// Her request'e otomatik olarak auth token ekler.
class AuthInterceptor extends Interceptor {
  final String? Function()? getAuthToken;

  AuthInterceptor({required this.getAuthToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getAuthToken?.call();
    
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }
}

