import 'package:dtxproject/screens/survey_screens/survey_home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
//import 'package:dtxproject/constants/app_theme.dart';

class AlcoholSurveyPage2 extends StatelessWidget {
  final surveyController = Get.find<SurveyController>();

  AlcoholSurveyPage2({super.key});

  @override
  Widget build(BuildContext context) {
    // 화면의 전체 너비
    double screenWidth = MediaQuery.of(context).size.width;
    // 좌우 패딩과 가운데 간격을 제외한 너비
    double availableWidth = screenWidth - 50 - 4; // 50: 좌우 패딩 합, 4: 가운데 간격
    // 진행 바 개당 너비
    double progressBarWidth = availableWidth / 2;
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
                    }, // 현재 선택한 값을 이전 페이지로 전달
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
                            text: '음주',
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
                              color: Color(0xff4D4D4D), // 두 번째 진행 바 색상
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 50),
                      // 질문 설명
                      const Text(
                        '다음은 최근 1년 동안의\n음주(술) 경험에 대한 질문입니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 130),
                      const Text(
                        '2. 한번에 술을 얼마나 마십니까?',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),

                      // 사각형 박스
                      Container(
                        width: MediaQuery.of(context).size.width - 34,
                        decoration: BoxDecoration(
                          color: Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '소주, 양주 등 술의 종류와 상관없이 각각의 술잔으로 계산합니다.\n'
                              '  · 캔맥주 1개(355cc)는 맥주 1.5잔과 같습니다.\n '
                              '  · 소주 1병은 7잔과 같습니다.',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20), // 텍스트와 입력 필드 사이 여백 추가

                            // 주관식 입력필드
                            Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    '한 번에 ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 12),
                                  Container(
                                    width: 78,
                                    height: 37,
                                    child: TextField(
                                      onChanged: (value) {
                                        surveyController.alcoholQ2InputText
                                            .value = value; // 값 업데이트
                                      },
                                      controller: TextEditingController(
                                        text: surveyController
                                            .alcoholQ2InputText.value,
                                      ),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    ' 잔',
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              );
                            }),
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
            surveyController.alcoholQ2InputText.value.isNotEmpty; // 값 입력 여부만 확인

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
                      surveyController.completeAlcoholSurvey();
                      Get.to(SurveyHomePage());
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
