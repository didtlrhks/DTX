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

  // 사용자의 모든 하루 리뷰 조회 API 호출
  static Future<List<DailyReview>> getUserDailyReviews(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$apiPath/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
          // 필요시 인증 토큰 추가
          // 'Authorization': 'Bearer $token',
        },
      );

      // 응답 처리
      if (response.statusCode == 200) {
        print('하루 리뷰 조회 성공: ${response.body}');

        // JSON 응답을 파싱하여 DailyReview 객체 리스트로 변환
        List<dynamic> jsonList = jsonDecode(response.body);
        List<DailyReview> reviewList =
            jsonList.map((json) => DailyReview.fromJson(json)).toList();

        return reviewList;
      } else {
        print('하루 리뷰 조회 실패: ${response.statusCode}, ${response.body}');
        return [];
      }
    } catch (e) {
      print('하루 리뷰 조회 오류: $e');
      return [];
    }
  }

  // 사용자의 최신 하루 리뷰만 조회
  static Future<DailyReview?> getLatestDailyReview(int userId) async {
    try {
      final reviews = await getUserDailyReviews(userId);

      // 기록이 있으면 첫 번째(최신) 기록 반환
      if (reviews.isNotEmpty) {
        // 날짜 기준으로 정렬 (최신 순)
        reviews.sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
        return reviews.first;
      }
      return null;
    } catch (e) {
      print('최신 하루 리뷰 조회 오류: $e');
      return null;
    }
  }

  // 오늘 날짜를 API에서 요구하는 형식(YYYY-MM-DD)으로 반환
  static String getTodayFormatted() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
