import 'package:dtxproject/screens/goal_weight_page.dart';
import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/alcohol_survey/alcohol_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/emotion_survey/emotion_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/lifequality_survey/lifequality_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/sick_survey/sick_survey_start_page.dart';
import 'package:flutter/material.dart';
import 'diet_survey/diet_survey_start_page.dart';
import 'sleep_survey/sleep_survey_start_page.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
import 'package:dtxproject/screens/survey_screens/survey_result_page.dart';
import 'package:dtxproject/screens/survey_screens/alcohol_survey/alcohol_survey_page_1.dart';
import 'package:dtxproject/screens/survey_screens/sleep_survey/sleep_survey_page_1.dart';
import 'package:dtxproject/screens/survey_screens/diet_survey/diet_survey_page_1.dart';
import 'package:dtxproject/screens/survey_screens/emotion_survey/emotion_survey_page_1.dart';
import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_page_1.dart';
import 'package:dtxproject/screens/survey_screens/lifequality_survey/lifequality_survey_page_1.dart';
import 'package:dtxproject/screens/survey_screens/sick_survey/sick_survey_page_1.dart';

class SurveyHomePage extends GetView<SurveyController> {
  const SurveyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.to(GoalWeightPage()),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '방금 목표를 달성할',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const Text(
                        '방법을 매일 알려드릴게요.',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '그 동안 실천한 방법 점검과 함께\n앞으로 실천할 방법을 찾아봐요.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return GetX<SurveyController>(
                            builder: (_) => Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              alignment: WrapAlignment.start,
                              children: [
                                _buildSurveyCard(
                                  '운동 설문',
                                  '운동 실천',
                                  '소요시간 4분 30초',
                                  () => Get.to(() => ExerciseSurveyPage1()),
                                  controller.isExerciseSurveyCompleted.value,
                                ),
                                _buildSurveyCard(
                                  '식단 설문',
                                  '식단 실천',
                                  '소요시간 4분 30초',
                                  () => Get.to(() => DietSurveyPage1()),
                                  controller.isDietSurveyCompleted.value,
                                ),
                                _buildSurveyCard(
                                  '수면 설문',
                                  '수면 실천',
                                  '소요시간 2분 30초',
                                  () => Get.to(() => SleepSurveyPage1()),
                                  controller.isSleepSurveyCompleted.value,
                                ),
                                _buildSurveyCard(
                                  '삶의 질 설문',
                                  '삶의 질 실천',
                                  '소요시간 3분 30초',
                                  () => Get.to(() => LifeQualitySurveyPage1()),
                                  controller.isLifeQualitySurveyCompleted.value,
                                ),
                                _buildSurveyCard(
                                  '감정 설문',
                                  '감정 실천',
                                  '소요시간 40초',
                                  () => Get.to(() => EmotionSurveyPage1()),
                                  controller.isEmotionSurveyCompleted.value,
                                ),
                                _buildSurveyCard(
                                  '음주 설문',
                                  '음주 실천',
                                  '소요시간 40초',
                                  () => Get.to(() => AlcoholSurveyPage1()),
                                  controller.isAlcoholSurveyCompleted.value,
                                ),
                                _buildSurveyCard(
                                  '질병 설문',
                                  '질병 실천',
                                  '소요시간 40초',
                                  () => Get.to(() => SickSurveyPage1()),
                                  controller.isSickSurveyCompleted.value,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      GetX<SurveyController>(
                        builder: (_) => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            //나중에 지우기 설문 넘어가는 용으로 있음
                            onPressed: () async {
                              // 설문 완료 상관없이 다음 페이지로 이동
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                barrierDismissible: false,
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              Get.back();
                              Get.to(() => const SurveyResultPage());
                            },

                            //원래 코드
                            // onPressed: controller.isAllSurveysCompleted.value
                            //     ? () async {
                            //         Get.dialog(
                            //           const Center(
                            //             child: CircularProgressIndicator(),
                            //           ),
                            //           barrierDismissible: false,
                            //         );
                            //         await Future.delayed(
                            //             const Duration(seconds: 2));
                            //         Get.back();
                            //         Get.to(() => const SurveyResultPage());
                            //       }
                            //     : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey[300],
                              disabledForegroundColor: Colors.grey[600],
                            ),
                            child: Text(
                              controller.isAllSurveysCompleted.value
                                  ? '다음'
                                  : '모든 설문을 완료해주세요',
                              style: const TextStyle(fontSize: 16),
                            ),
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
      ),
    );
  }

  Widget _buildSurveyCard(String title, String subtitle, String time,
      VoidCallback onTap, bool isCompleted) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 125,
        decoration: BoxDecoration(
          color: isCompleted ? Colors.green[100] : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            if (isCompleted)
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.check_circle, color: Colors.green, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
