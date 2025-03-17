import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/lunch_model.dart';
import '../constants/api_constants.dart';

class LunchService extends GetxService {
  // API 기본 URL
  final String baseUrl = 'http://localhost:3000/api';

  // 인증 토큰 (실제 인증 로직에 맞게 수정 필요)
  String? _authToken;

  // 사용자 ID
  int _userId = 0;

  // 인증 토큰 설정
  void setAuthToken(String token) {
    _authToken = token;
    print('LunchService: 인증 토큰이 설정되었습니다.');
  }

  // 사용자 ID 설정
  void setUserId(int userId) {
    _userId = userId;
    print('LunchService: 사용자 ID가 $_userId로 설정되었습니다.');
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

  // 점심 식사 기록 목록 가져오기
  Future<List<LunchModel>> getLunches() async {
    try {
      if (_userId <= 0) {
        throw Exception('유효하지 않은 사용자 ID ($_userId). 로그인이 필요합니다.');
      }

      final url = '$baseUrl/launch/user/$_userId';
      print('🔷 점심 기록 조회 요청: GET $url (사용자 ID: $_userId)');

      final response = await http.get(
        Uri.parse(url),
        headers: _getHeaders(),
      );

      print('🔶 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          print('📝 사용자 $_userId의 점심 기록이 없습니다.');
          return [];
        }

        final dynamic decodedData = json.decode(response.body);
        print('📝 사용자 $_userId의 점심 기록을 성공적으로 불러왔습니다.');

        if (decodedData is List) {
          return decodedData.map((json) => LunchModel.fromJson(json)).toList();
        } else if (decodedData is Map<String, dynamic>) {
          return [LunchModel.fromJson(decodedData)];
        } else {
          throw Exception('예상치 못한 응답 형식: $decodedData');
        }
      } else {
        throw Exception(
            'API 응답 오류: ${response.statusCode}, 응답: ${response.body}');
      }
    } catch (e) {
      print('❌ API 호출 오류: $e');
      throw Exception('점심 기록을 가져오는 중 오류 발생: $e');
    }
  }

  // 점심 식사 기록 추가
  Future<LunchModel> addLunch(String text) async {
    try {
      if (_userId <= 0) {
        throw Exception('유효하지 않은 사용자 ID ($_userId)');
      }

      final lunch = LunchModel(
        lunch_text: text,
        lunch_date: _getTodayDate(),
        user_id: _userId,
      );

      final url = '$baseUrl${ApiConstants.lunch}';
      final body = json.encode(lunch.toJson());
      print('🔷 점심 기록 추가 요청: POST $url (사용자 ID: $_userId)');
      print('📦 요청 데이터: $body');

      final response = await http.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: body,
      );

      print('🔶 응답 상태 코드: ${response.statusCode}');
      print('📦 응답 데이터: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('📝 사용자 $_userId의 점심 기록이 성공적으로 추가되었습니다.');
        return LunchModel.fromJson(json.decode(response.body));
      } else {
        final error =
            '점심 기록 추가 실패: ${response.statusCode}, 응답: ${response.body}';
        print('❌ $error');
        throw Exception(error);
      }
    } catch (e) {
      print('❌ 점심 기록 추가 오류: $e');
      throw Exception('점심 기록 추가 중 오류 발생: $e');
    }
  }

  // 점심 식사 기록 삭제
  Future<void> deleteLunch(String id) async {
    try {
      final url = '$baseUrl${ApiConstants.lunch}/$id/user/$_userId';
      print('🔷 점심 기록 삭제 요청: DELETE $url (사용자 ID: $_userId)');

      final response = await http.delete(
        Uri.parse(url),
        headers: _getHeaders(),
      );

      print('🔶 응답 상태 코드: ${response.statusCode}');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('점심 기록 삭제 실패: ${response.statusCode}');
      }

      print('📝 점심 기록이 성공적으로 삭제되었습니다.');
    } catch (e) {
      print('❌ 점심 기록 삭제 오류: $e');
      throw Exception('점심 기록 삭제 중 오류 발생: $e');
    }
  }
}
