import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
import 'package:dtxproject/utils/survey_progress_bar_utils.dart';
//import 'package:dtxproject/constants/app_theme.dart';
import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_page_3.dart';

class ExerciseSurveyPage2 extends StatelessWidget {
  final surveyController = Get.find<SurveyController>();

  ExerciseSurveyPage2({super.key});

  @override
  Widget build(BuildContext context) {
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
                            text: '운동',
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
                      // 설문 상태바 (현재 문항 current : 0부터 시작)
                      SurveyProgressBar(
                        total: 7,
                        current: 1,
                        screenWidth: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(height: 50),
                      // 질문 설명
                      const Text(
                        '활동량에 대한 평가입니다.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 80),
                      const Text(
                        '2. 최근 1주일 동안 한번에 적어도 10분 이상 걸은 날 중\n하루 동안 걷는 시간은 보통 얼마나 됩니까?',
                        style: TextStyle(fontSize: 16, fontFamily: 'Paperlogy'),
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
                            SizedBox(height: 20), // 텍스트와 입력 필드 사이 여백 추가

                            // 주관식 입력필드
                            Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Text(
                                    '하루에 ',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(width: 12),

                                  // 시간 입력
                                  Container(
                                    width: 78,
                                    height: 37,
                                    child: TextField(
                                      onChanged: (value) {
                                        surveyController.exerciseQ21InputText
                                            .value = value; // 값 업데이트
                                      },
                                      controller: TextEditingController(
                                        text: surveyController
                                            .exerciseQ21InputText.value,
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
                                  const Text(' 시간',
                                      style: TextStyle(fontSize: 16)),

                                  const SizedBox(width: 12),

                                  // 분 입력 (필수)
                                  SizedBox(
                                    width: 78,
                                    height: 37,
                                    child: TextField(
                                      onChanged: (value) {
                                        surveyController
                                            .exerciseQ22InputText.value = value;
                                      },
                                      controller: TextEditingController(
                                        text: surveyController
                                            .exerciseQ22InputText.value,
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
                                  const Text('분',
                                      style: TextStyle(fontSize: 16)),
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
            surveyController.exerciseQ21InputText.value.isNotEmpty ||
                surveyController.exerciseQ22InputText.value
                    .isNotEmpty; // 시간, 분 둘 중 하나만 입력되어도 넘어가게

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
                      Get.to(() => ExerciseSurveyPage3()); // 다음 페이지 이동
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
