import 'package:dio/dio.dart';

class ApiService {
  // For Android Emulator use 10.0.2.2 instead of localhost
  static const String baseUrl = "http://10.0.2.2:8000/api";

  final Dio _dio = Dio();

  /// Call the /hello/ endpoint (created for testing)
  Future<String> getHello() async {
    try {
      final response = await _dio.get("$baseUrl/hello/");
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception("Failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  /// Call the /training-programs/ endpoint
  Future<List<dynamic>> getTrainingPrograms() async {
    try {
      final response = await _dio.get("$baseUrl/training-programs/");
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
