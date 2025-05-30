import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/app_constants.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    _dio ??= _createDio();
    return _dio!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_createLogInterceptor());
    dio.interceptors.add(_createErrorInterceptor());
    dio.interceptors.add(_createCacheInterceptor());

    return dio;
  }

  static LogInterceptor _createLogInterceptor() {
    return LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
      requestHeader: kDebugMode,
      responseHeader: false,
      error: kDebugMode,
      logPrint: (object) {
        if (kDebugMode) {
          print('🌐 API: $object');
        }
      },
    );
  }

  static InterceptorsWrapper _createErrorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String errorMessage = 'Unknown error occurred';
        
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Connection timeout. Please check your internet connection.';
        } else if (error.type == DioExceptionType.connectionError) {
          errorMessage = 'No internet connection. Please check your network.';
        } else if (error.response != null) {
          switch (error.response!.statusCode) {
            case 400:
              errorMessage = 'Bad request. Please check your input.';
              break;
            case 401:
              errorMessage = 'Unauthorized. Please check your API key.';
              break;
            case 403:
              errorMessage = 'Forbidden. Access denied.';
              break;
            case 404:
              errorMessage = 'Resource not found.';
              break;
            case 429:
              errorMessage = 'Too many requests. Please try again later.';
              break;
            case 500:
              errorMessage = 'Server error. Please try again later.';
              break;
            default:
              errorMessage = 'Error ${error.response!.statusCode}: ${error.response!.statusMessage}';
          }
        }

        final customError = DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: errorMessage,
        );

        handler.next(customError);
      },
    );
  }

  static InterceptorsWrapper _createCacheInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add cache headers
        options.headers['Cache-Control'] = 'max-age=${AppConstants.maxCacheAge}';
        handler.next(options);
      },
    );
  }
}