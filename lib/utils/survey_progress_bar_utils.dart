import 'package:flutter/material.dart';

/// 설문 진행 상황을 가로 막대로 표시하는 위젯
/// [total]은 전체 문항 수, [current]는 현재까지 진행된 문항 인덱스 (0부터 시작)
/// [screenWidth]는 진행바 너비 계산을 위한 전체 화면 너비
class SurveyProgressBar extends StatelessWidget {
  final int total; // 전체 문항 수
  final int current; // 현재 진행 중인 문항 인덱스 (0부터 시작)
  final double screenWidth; // 전체 화면 너비

  const SurveyProgressBar({
    Key? key,
    required this.total,
    required this.current,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 4.0; // 각 진행바 사이의 간격
    const double horizontalPadding = 50.0; // 좌우 패딩의 합 (25 + 25)

    // 사용 가능한 너비 = 전체 너비 - 패딩 - 간격*(n-1)
    double availableWidth =
        screenWidth - horizontalPadding - (spacing * (total - 1));

    // 개별 진행바의 너비
    double progressBarWidth = availableWidth / total;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        return Row(
          children: [
            // 진행 바 하나
            Container(
              width: progressBarWidth,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.5), // 모서리 둥글게
                color: index == current
                    ? const Color(0xff4D4D4D) // 현재까지 완료된 바 색상
                    : const Color(0xffD9D9D9), // 아직 진행되지 않은 바 색상
              ),
            ),
            // 마지막 바가 아니라면 간격 추가
            if (index != total - 1) const SizedBox(width: spacing),
          ],
        );
      }),
    );
  }
}
