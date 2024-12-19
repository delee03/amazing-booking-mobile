import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

import '../models/hotel.dart';

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
  Future<List<dynamic>> fetchLocations() async {
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

  Future<List<Hotel>> fetchHotels() async {
    try {
      final response = await get('/ratings');
      if (response.statusCode != 200) {
        throw Exception('Failed to load ratings');
      }

      final locations = await fetchLocations();
      final ratingMap = <String, List<int>>{};
      final processedRoomIds = <String>{};
      final hotels = <Hotel>[];

      for (var item in response.data['content']) {
        final room = item['room'];
        final roomId = room['id'];

        if (!processedRoomIds.add(roomId)) continue;
        ratingMap.putIfAbsent(roomId, () => []).add(item['star']);
      }

      for (var item in response.data['content']) {
        final room = item['room'];
        final roomId = room['id'];

        final ratings = ratingMap[roomId];
        if (ratings == null) continue;

        final averageStar = ratings.reduce((a, b) => a + b) / ratings.length;
        final locationName = locations[room['locationId']]?.city ?? 'Unknown';

        hotels.add(Hotel(
          id: roomId,
          name: room['name'],
          description: room['description'],
          soLuong: room['soLuong'],
          soKhach: room['soKhach'],
          tienNghi: room['tienNghi'],
          price: (room['price'] is int)
              ? room['price'].toDouble()
              : room['price'],
          avatar: room['avatar'],
          averageStar: averageStar,
          locationName: locationName,
        ));
      }

      hotels.sort((a, b) => b.averageStar.compareTo(a.averageStar));
      return hotels.take(5).toList();
    } catch (error) {
      throw Exception('Error fetching data: $error');
    }
  }
}
