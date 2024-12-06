import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

class ApiClient {
  // Base URL for API calls
  static final String baseUrl =
      dotenv.env['BASE_DOMAIN_API'] ?? 'http://localhost:3000';

  // Dio instance
  final Dio dio;
  ApiClient._internal(this.dio) {
    // Add logging interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        if (kDebugMode) {
          print("Request [${options.method}] => PATH: ${options.path}");
        }
        if (kDebugMode) {
          print("Headers: ${options.headers}");
        }
        if (kDebugMode) {
          print("Data: ${options.data}");
        }
        return handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (kDebugMode) {
          print(
              "Response [${response.statusCode}] => PATH: ${response.requestOptions.path}");
        }
        if (kDebugMode) {
          print("Data: ${response.data}");
        }
        return handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        if (kDebugMode) {
          print(
              "Error [${error.response?.statusCode}] => PATH: ${error.requestOptions.path}");
        }
        if (kDebugMode) {
          print("Message: ${error.message}");
        }
        if (error.response != null) {
          if (kDebugMode) {
            print("Error Data: ${error.response?.data}");
          }
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
        connectTimeout: const Duration(seconds: 15), // 15 seconds
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
  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    return dio.get(endpoint, queryParameters: queryParameters);
  }

  // Example method to perform a POST request
  Future<Response> post(String endpoint, {dynamic data}) async {
    return dio.post(endpoint, data: data);
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      // Thực hiện yêu cầu PUT với dữ liệu (nếu có)
      final response = await dio.put(endpoint, data: data);
      return response;
    } catch (e) {
      // Xử lý lỗi nếu có
      rethrow;
    }
  }
  // Example method to handle authentication tokens
  void setAuthorizationToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  Future<List<dynamic>> fetchTopLocation() async {
    try {
      final response = await get('/locations');
      if (response.statusCode == 200) {
        final List<dynamic> content = response.data['content'];
        content.shuffle();
        return content.take(6).toList();
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

// Method to fetch all locations
  Future<List<dynamic>> fetchAllLocations() async {
    try {
      final response = await get('/locations');
      if (response.statusCode == 200) {
        return response.data['content'];
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
