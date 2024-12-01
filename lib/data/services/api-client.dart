import 'dart:ffi';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class ApiClient {
  // Base URL for API calls
  static final String baseUrl = dotenv.env['BASE_DOMAIN_API'] ?? 'http://localhost:3000';

  // Dio instance
  final Dio dio;
  ApiClient._internal(this.dio){
      // Add logging interceptor
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
          print("Request [${options.method}] => PATH: ${options.path}");
          print("Headers: ${options.headers}");
          print("Data: ${options.data}");
          return handler.next(options);
        },
        onResponse: (Response response, ResponseInterceptorHandler handler) {
          print("Response [${response.statusCode}] => PATH: ${response.requestOptions.path}");
          print("Data: ${response.data}");
          return handler.next(response);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) {
          print("Error [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}");
          print("Message: ${error.message}");
          if (error.response != null) {
            print("Error Data: ${error.response?.data}");
          }
          return handler.next(error);
        },
      ));
  }

  // Singleton pattern to reuse the same Dio instance
  static final ApiClient _instance = ApiClient._internal(
    Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15) ,// 15 seconds
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      ),
    ),
  );

  factory ApiClient() => _instance;

  // Example method to perform a GET request
  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParameters}) async {
    return dio.get(endpoint, queryParameters: queryParameters);
  }

  // Example method to perform a POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    return dio.post(endpoint, data: data);
  }

  // Example method to handle authentication tokens
  void setAuthorizationToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
