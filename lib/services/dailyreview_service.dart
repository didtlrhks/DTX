import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dtxproject/models/dailyreview_model.dart';

class DailyReviewService {
  // API 엔드포인트 URL
  static const String baseUrl = 'http://localhost:3000'; // 실제 서버 URL로 변경 필요
  static const String apiPath = '/api/daily-review';

  // 하루 리뷰 저장 API 호출
  static Future<bool> saveDailyReview(DailyReview dailyReview) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$apiPath'),
        headers: {
          'Content-Type': 'application/json',
          // 필요시 인증 토큰 추가
          // 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(dailyReview.toJson()),
      );

      // 응답 처리
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('하루 리뷰 저장 성공: ${response.body}');
        return true;
      } else {
        print('하루 리뷰 저장 실패: ${response.statusCode}, ${response.body}');
        return false;
      }
    } catch (e) {
      print('하루 리뷰 저장 오류: $e');
      return false;
    }
  }

  // 오늘 날짜를 API에서 요구하는 형식(YYYY-MM-DD)으로 반환
  static String getTodayFormatted() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
