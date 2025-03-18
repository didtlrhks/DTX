import 'package:dtxproject/screens/survey_screens/sleep_survey/sleep_survey_page_1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
//import 'package:dtxproject/constants/app_theme.dart';

class ExerciseSurveyPage1 extends StatelessWidget {
  final surveyController = Get.find<SurveyController>();
  // 선택된 옵션을 저장하는 RxInt 변수
  final RxInt selectedOption = (-1).obs;

  ExerciseSurveyPage1({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 전체 너비
    double screenWidth = MediaQuery.of(context).size.width;
    // 좌우 패딩과 가운데 간격을 제외한 너비
    double availableWidth =
        screenWidth - 50 - (4 * 5); // 50: 좌우 패딩 합, 4: 가운데 간격 * n 번
    // 진행 바 개당 너비
    double progressBarWidth = availableWidth / 6;
    return Scaffold(
      backgroundColor: const Color(0xFF9D9D9D), // 배경색 적용
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 바 (뒤로가기 버튼 + 제목)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool shouldPop = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15.0), // 모서리 둥글게 설정
                          ),
                          backgroundColor: Colors.white, // 배경색 흰색으로 설정
                          contentPadding: const EdgeInsets.only(top: 30),
                          content: const Text('재시작 시,\n이전 문항의 기록이\n모두 사라집니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16)),
                          actionsPadding:
                              const EdgeInsets.all(20), // 버튼 위쪽에 여백 추가

                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                          double.infinity, 50), //버튼 크기
                                      backgroundColor: const Color(0xff00102B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12.0), // 버튼 모서리 둥글게
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text(
                                      '취소',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8.0), // 버튼 사이의 간격
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(
                                          double.infinity, 50), //버튼 크기

                                      backgroundColor: const Color(0xffD9D9D9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            12.0), // 버튼 모서리 둥글게
                                      ),
                                    ),
                                    onPressed: () {
                                      // surveyController
                                      //     .clearAlcoholSurveyData(); // 모든 응답 초기화 (페이지 2 포함)
                                      surveyController
                                          .resetSleepSurveys(); // 홈 화면에서 비활성화
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text(
                                      '확인',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xff656565)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                      if (shouldPop) {
                        Get.back();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 8, bottom: 12),
                      alignment: Alignment.centerLeft,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      children: [
                        TextSpan(
                            text: '수면',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Paperlogy')),
                        TextSpan(
                            text: ' 설문조사',
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'Paperlogy')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 진행 상태 표시
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xff4D4D4D), // 첫 번째 진행 바 색상
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xffD9D9D9), // 두 번째 진행 바 색상
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xffD9D9D9), // 세 번째 진행 바 색상
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xffD9D9D9), // 네 번째 진행 바 색상
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xffD9D9D9), // 다섯 번째 진행 바 색상
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xffD9D9D9), // 여섯 번째 진행 바 색상
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: const Color(0xffD9D9D9), // 일곱 번째 진행 바 색상
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      // 질문 설명
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '지난',
                            ),
                            TextSpan(
                                text: ' 2주간',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text: ' 귀하의 불면증 문제의 심한 정도에 대해 선택해 주시기 바랍니다.',
                            ),
                          ],
                        ),
                      ),
                      // 질문 설명

                      const SizedBox(height: 80),
                      const Text('1. 잠들기 어렵나요?',
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Paperlogy')),
                      const SizedBox(height: 10),

                      // 객관식 문항이 있는 사각형 박스
                      Container(
                        width: MediaQuery.of(context).size.width - 34,
                        decoration: BoxDecoration(
                          color: const Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(5, (index) {
                                //객관식 문항
                                List<String> options = [
                                  '0. 전혀 그렇지 않습니다.',
                                  '1. 약간 그렇습니다.',
                                  '2. 종종 그런편입니다.',
                                  '3. 자주 그렇습니다.',
                                  '4. 항상 그렇습니다.'
                                ];
                                return Obx(
                                  () {
                                    // 옵션 선택 확인
                                    bool isSelected =
                                        selectedOption.value == index;
                                    return GestureDetector(
                                      onTap: () => selectedOption.value = index,
                                      child: IntrinsicWidth(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 39,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 20.0),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? const Color(0xff4E4E4E)
                                                : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          child: Text(
                                            options[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 다음 버튼
      bottomNavigationBar: Obx(() {
        bool isButtonEnabled =
            selectedOption.value != -1; // 선택된 옵션이 있어야 버튼 활성화됨.
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 42.0),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isButtonEnabled
                    ? const Color(0xff363636)
                    : const Color(0xffD9D9D9),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xffD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // 버튼 모서리 둥글게
                ),
              ),
              onPressed: isButtonEnabled
                  ? () {
                      // Get.to(() => SleepSurveyPage1()); // 다음 페이지 이동
                      Get.back();
                    }
                  : null, // 선택하지 않으면 버튼 비활성화
              child: const Text(
                '다음',
                style: TextStyle(fontSize: 28),
              ),
            ),
          ),
        );
      }),
    );
  }
}
