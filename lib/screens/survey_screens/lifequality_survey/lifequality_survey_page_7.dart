import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
//import 'package:dtxproject/constants/app_theme.dart';
import 'package:dtxproject/screens/survey_screens/lifequality_survey/lifequality_survey_page_8.dart';

class LifeQualitySurveyPage7 extends StatelessWidget {
  final surveyController = Get.find<SurveyController>();

  LifeQualitySurveyPage7({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 전체 너비
    double screenWidth = MediaQuery.of(context).size.width;
    // 좌우 패딩과 가운데 간격을 제외한 너비
    double availableWidth =
        screenWidth - 50 - (4 * 7); // 50: 좌우 패딩 합, 4: 가운데 간격 * 7 번
    // 진행 바 개당 너비
    double progressBarWidth = availableWidth / 8;
    return Scaffold(
      backgroundColor: Color(0xFF9D9D9D), // 배경색 적용
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
                    onTap: () {
                      Get.back();
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
                            text: '삶의질',
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
                padding: EdgeInsets.all(16.0),
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
                              color: Color(0xffD9D9D9), // 첫 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 두 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 세 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 네 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 다섯 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 여섯 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xff4D4D4D), // 일곱 번째 진행 바 색상
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: progressBarWidth,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.5),
                              color: Color(0xffD9D9D9), // 여덟 번째 진행 바 색상
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      // 질문 설명
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                                text: '지난 1주일 동안',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                              text:
                                  ' 귀하의 건강과 관련된 질문입니다.\n보기를 읽고 귀하의 상태를 가장 잘 표현하는 것을\n선택하여 주십시오',
                            ),
                          ],
                        ),
                      ),
                      // 질문 설명

                      SizedBox(height: 80),
                      const Text('7. 잠자기',
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Paperlogy')),
                      SizedBox(height: 10),

                      // 객관식 문항이 있는 사각형 박스
                      Container(
                        width: MediaQuery.of(context).size.width - 34,
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(4, (index) {
                                //객관식 문항
                                List<String> options = [
                                  '나는 잠을 자는 데 어려움이 전혀 없었다.',
                                  '나는 잠을 자는 데 어려움이 약간 있었다.',
                                  '나는 잠을 자는 데 어려움이 많이 있었다.',
                                  '나는 잠을 잘 수 없었다.',
                                ];
                                return Obx(
                                  () {
                                    // 옵션 선택 확인
                                    bool isSelected = surveyController
                                            .LifeQualityQ7Option.value ==
                                        index;
                                    return GestureDetector(
                                      onTap: () => surveyController
                                          .LifeQualityQ7Option.value = index,
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
                                                ? Color(0xff4E4E4E)
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
        bool isButtonEnabled = surveyController.LifeQualityQ7Option.value !=
            -1; // 선택된 옵션이 있어야 버튼 활성화됨.
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 42.0),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isButtonEnabled ? Color(0xff363636) : Color(0xffD9D9D9),
                foregroundColor: Colors.white,
                disabledBackgroundColor: Color(0xffD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // 버튼 모서리 둥글게
                ),
              ),
              onPressed: isButtonEnabled
                  ? () {
                      Get.to(() => LifeQualitySurveyPage8()); // 다음 페이지 이동
                    }
                  : null,
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
