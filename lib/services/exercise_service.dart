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
      // 새로운 API 엔드포인트 형식으로 URL 구성
      final url = '$baseUrl/exercise/user/$_userId';
      print('조회 요청 URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: _getHeaders(),
      );

      print('조회 응답 상태 코드: ${response.statusCode}');
      print('조회 응답 내용: ${response.body}');

      if (response.statusCode == 200) {
        // 응답이 빈 배열이거나 null인 경우 처리
        if (response.body.isEmpty || response.body == 'null') {
          print('응답이 비어있습니다. 빈 목록 반환');
          return [];
        }

        try {
          final dynamic decodedData = json.decode(response.body);

          // 응답이 배열인 경우
          if (decodedData is List) {
            return decodedData
                .map((json) => ExerciseModel.fromJson(json))
                .toList();
          }
          // 응답이 단일 객체인 경우
          else if (decodedData is Map<String, dynamic>) {
            return [ExerciseModel.fromJson(decodedData)];
          }
          // 기타 경우
          else {
            print('예상치 못한 응답 형식: $decodedData');
            return [];
          }
        } catch (parseError) {
          print('JSON 파싱 오류: $parseError');
          return [];
        }
      } else {
        print('API 응답 오류: ${response.statusCode}, 응답 내용: ${response.body}');
        // 오류가 발생해도 빈 목록 반환하여 앱 작동 유지
        return [];
      }
    } catch (e) {
      print('API 호출 오류: $e');
      // 예외가 발생해도 빈 목록 반환하여 앱 작동 유지
      return [];
    }
  }

  // 운동 기록 추가
  Future<ExerciseModel> addExercise(String text, int intensityValue) async {
    try {
      final exercise = ExerciseModel(
        exercise_text: text,
        intensity: ExerciseModel.intensityToString(intensityValue),
        exercise_date: _getTodayDate(),
        user_id: _userId,
      );

      print('API 요청 데이터: ${json.encode(exercise.toJson())}');

      final response = await http.post(
        Uri.parse('$baseUrl/exercise'),
        headers: _getHeaders(),
        body: json.encode(exercise.toJson()),
      );

      print('API 응답: ${response.statusCode}, 응답 내용: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // 서버 응답에서 생성된 모델 가져오기
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

      print('삭제 응답: ${response.statusCode}, 응답 내용: ${response.body}');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete exercise: ${response.statusCode}');
      }
    } catch (e) {
      print('삭제 오류: $e');
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

      print('다중 삭제 응답: ${response.statusCode}, 응답 내용: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete exercises: ${response.statusCode}');
      }
    } catch (e) {
      print('다중 삭제 오류: $e');
      throw Exception('Error deleting exercises: $e');
    }
  }
}
