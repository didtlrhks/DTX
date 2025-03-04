import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiService {
  static Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: ApiConstants.headers,
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.baseUrl + endpoint),
        headers: ApiConstants.headers,
      );

      final responseData = jsonDecode(response.body);

      return {
        'statusCode': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      return {
        'statusCode': 500,
        'error': e.toString(),
      };
    }
  }
}
