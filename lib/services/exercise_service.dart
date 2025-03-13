import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:dtxproject/models/exercise_model.dart';
import 'package:intl/intl.dart';

class ExerciseService extends GetxService {
  // API 기본 URL (실제 서버 URL로 변경 필요)
  final String baseUrl = 'http://localhost:3000/api'; // 실제 서버 URL로 변경 필요

  // 인증 토큰 (실제 인증 로직에 맞게 수정 필요)
  String? _authToken;

  // 사용자 ID (실제 사용자 ID로 변경 필요)
  int _userId = 0;

  // 인증 토큰 설정
  void setAuthToken(String token) {
    _authToken = token;
  }

  // 사용자 ID 설정
  void setUserId(int userId) {
    _userId = userId;
  }

  // HTTP 헤더 생성
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_authToken != null) 'Authorization': 'Bearer $_authToken',
    };
  }

  // 오늘 날짜를 YYYY-MM-DD 형식으로 반환
  String _getTodayDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  // 운동 기록 목록 가져오기
  Future<List<ExerciseModel>> getExercises() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/exercise'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => ExerciseModel.fromJson(json)).toList();
      } else {
        print('API 응답 오류: ${response.statusCode}, 응답 내용: ${response.body}');
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    } catch (e) {
      print('API 호출 오류: $e');
      throw Exception('Error fetching exercises: $e');
    }
  }

  // 운동 기록 추가
  Future<ExerciseModel> addExercise(String text, int intensityValue) async {
    try {
      final exercise = ExerciseModel(
        exercise_text: text, // 변경된 필드명에 맞게 수정
        intensity: ExerciseModel.intensityToString(intensityValue),
        exercise_date: _getTodayDate(),
        user_id: _userId, // 변경된 필드명에 맞게 수정
      );

      print('API 요청 데이터: ${json.encode(exercise.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl/exercise'),
        headers: _getHeaders(),
        body: json.encode(exercise.toJson()),
      );

      print('API 응답: ${response.statusCode}, 응답 내용: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ExerciseModel.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to add exercise: ${response.statusCode}, 응답: ${response.body}');
      }
    } catch (e) {
      print('API 호출 오류: $e');
      throw Exception('Error adding exercise: $e');
    }
  }

  // 운동 기록 삭제
  Future<void> deleteExercise(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/exercise/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete exercise: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting exercise: $e');
    }
  }

  // 여러 운동 기록 삭제
  Future<void> deleteMultipleExercises(List<String> ids) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/exercise/delete-multiple'),
        headers: _getHeaders(),
        body: json.encode({'ids': ids}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting exercises: $e');
    }
  }
}
