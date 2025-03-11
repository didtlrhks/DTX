import 'package:flutter/material.dart';

class DateUtil {
  /// 현재 날짜 정보를 반환하는 함수
  static Map<String, String> getCurrentDateInfo() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final weekday = getWeekdayInKorean(now.weekday);

    return {
      'day': day,
      'weekday': weekday,
    };
  }

  /// 요일을 한글로 변환하는 함수
  static String getWeekdayInKorean(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }

  /// 날짜 형식을 포맷팅하는 함수 (추가 기능)
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');

    String formatted = format
        .replaceAll('yyyy', year)
        .replaceAll('MM', month)
        .replaceAll('dd', day);

    return formatted;
  }
}
