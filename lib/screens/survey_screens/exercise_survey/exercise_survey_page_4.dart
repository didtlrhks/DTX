import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
//import 'package:dtxproject/constants/app_theme.dart';
import 'package:dtxproject/utils/survey_progress_bar_utils.dart';
import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_page_5.dart';
import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_page_6.dart';

class ExerciseSurveyPage4 extends StatelessWidget {
  final surveyController = Get.find<SurveyController>();

  ExerciseSurveyPage4({super.key});

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 설문 상태바 (현재 문항 current : 0부터 시작)
                    SurveyProgressBar(
                      total: 7,
                      current: 3,
                      screenWidth: MediaQuery.of(context).size.width,
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: SingleChildScrollView(
                        // 스크롤 시작
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 30),
                            // 질문 설명
                            const Text(
                              '다음은 평소 일주일 동안 본인이 참여하고 있는 다양한 신체활동 시간과 관련된 질문입니다.',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Text(
                              '※ ‘고강도 활동’은 격렬한 신체활동으로 숨이 많이 차거나 심장이 매우 빠르게 뛰는 활동을 말합니다.',
                              style: TextStyle(fontSize: 14),
                            ),

                            const SizedBox(height: 20), // 원래는 80, 길이가 길어서 조정함

                            // 문항
                            const Text(
                              '4. 평소 최소 10분 이상 계속 숨이 많이 차거나 심장이 매우 빠르게 뛰는 고강도의 스포츠, 운동 및 여가 활동을 하십니까? 혹은 직업적으로 이러한 일을 최소 10분 이상 포함하십니까?',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'Paperlogy'),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '고강도 신체활동: 무거운 것을 들어 올리거나 나르는 일(약 20kg 이상), 땅파기, 건설 현장에서의 노동, 계단으로 물건 나르기, 달리기, 줄넘기, 등산, 농구 시합, 수영, 배드민턴 등',
                              style: TextStyle(
                                  fontSize: 14, fontFamily: 'Paperlogy'),
                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(8, (index) {
                                      //객관식 문항
                                      List<String> options = [
                                        '전혀 하지 않음',
                                        '1일',
                                        '2일',
                                        '3일',
                                        '4일',
                                        '5일',
                                        '6일',
                                        '7일(매일)',
                                      ];
                                      return Obx(
                                        () {
                                          // 옵션 선택 확인
                                          bool isSelected = surveyController
                                                  .exerciseQ4Option.value ==
                                              index;
                                          return GestureDetector(
                                            onTap: () => surveyController
                                                .exerciseQ4Option.value = index,
                                            child: IntrinsicWidth(
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                                height: 39,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 20.0),
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? const Color(0xff4E4E4E)
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
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
                            ), // 컨테이너
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 다음 버튼
      bottomNavigationBar: Obx(() {
        bool isButtonEnabled = surveyController.exerciseQ4Option.value !=
            -1; // 선택된 옵션이 있어야 버튼 활성화됨.
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
                      if (surveyController.exerciseQ4Option.value == 0) {
                        // "전혀 하지 않았다" 선택 시, 다음 질문 생략 & 6번 질문으로 이동
                        Get.to(() =>
                            ExerciseSurveyPage6()); // 혹은 Get.back() 등 원하는 동작
                      } else {
                        // 1일 이상 걸은 경우 → 걷는 시간 묻는 다음 페이지로 이동
                        Get.to(() => ExerciseSurveyPage5());
                      }
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
