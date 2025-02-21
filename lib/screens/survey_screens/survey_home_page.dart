import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/alcohol_survey/alcohol_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/emotion_survey/emotion_survey_start_page.dart';
import 'package:dtxproject/screens/survey_screens/lifequality_survey/lifequality_survey_start_page.dart';
import 'package:flutter/material.dart';
import 'diet_survey/diet_survey_start_page.dart';
import 'sleep_survey/sleep_survey_start_page.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
import 'package:dtxproject/screens/survey_screens/survey_result_page.dart';

class SurveyHomePage extends StatelessWidget {
  const SurveyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final surveyController = Get.find<SurveyController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('설문조사'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '건강 설문조사',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '이 설문조사는 귀하의 건강 상태를 더 자세히 파악하기 위한 것입니다. 약 5-10분 정도 소요됩니다.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() => Card(
                      color: surveyController.isDietSurveyCompleted.value
                          ? Colors.green[100]
                          : null,
                      child: ListTile(
                        title: const Text('식단 설문조사'),
                        subtitle: const Text('평소 식습관 체크'),
                        trailing: surveyController.isDietSurveyCompleted.value
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(() => const DietSurveyStartPage());
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => Card(
                      color: surveyController.isSleepSurveyCompleted.value
                          ? Colors.green[100]
                          : null,
                      child: ListTile(
                        title: const Text('수면 설문조사'),
                        subtitle: const Text('일상적인 수면 습관 체크'),
                        trailing: surveyController.isSleepSurveyCompleted.value
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(() => const SleepSurveyStartPage());
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => Card(
                      color: surveyController.isExerciseSurveyCompleted.value
                          ? Colors.green[100]
                          : null,
                      child: ListTile(
                        title: const Text('운동 설문조사'),
                        subtitle: const Text('평소 운동 체크'),
                        trailing:
                            surveyController.isExerciseSurveyCompleted.value
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(() => const ExerciseSurveyStartPage());
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => Card(
                      color: surveyController.isAlcoholSurveyCompleted.value
                          ? Colors.green[100]
                          : null,
                      child: ListTile(
                        title: const Text('술 설문조사'),
                        subtitle: const Text('평소 술 섭취 체크'),
                        trailing:
                            surveyController.isAlcoholSurveyCompleted.value
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(() => const AlcoholSurveyStartPage());
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => Card(
                      color: surveyController.isEmotionSurveyCompleted.value
                          ? Colors.green[100]
                          : null,
                      child: ListTile(
                        title: const Text('감정 설문조사'),
                        subtitle: const Text('평소 감정변화 체크'),
                        trailing:
                            surveyController.isEmotionSurveyCompleted.value
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(() => const EmotionSurveyStartPage());
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => Card(
                      color: surveyController.isLifeQualitySurveyCompleted.value
                          ? Colors.green[100]
                          : null,
                      child: ListTile(
                        title: const Text('삶의 질 설문조사'),
                        subtitle: const Text('평소 생활 질 체크'),
                        trailing:
                            surveyController.isLifeQualitySurveyCompleted.value
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Get.to(() =>
                              const LifeQualitySurveyStartPage()); // TODO: 삶의 질 설문 페이지로 이동
                        },
                      ),
                    )),
                const SizedBox(height: 16),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: surveyController.isAllSurveysCompleted.value
                            ? () async {
                                // 로딩 다이얼로그 표시
                                Get.dialog(
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  barrierDismissible: false,
                                );

                                // 2초 대기 (로딩 효과)
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                // 로딩 다이얼로그 닫기
                                Get.back();

                                // 결과 페이지로 이동
                                Get.offAll(() => const SurveyResultPage());
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[600],
                        ),
                        child: Text(
                          surveyController.isAllSurveysCompleted.value
                              ? '다음'
                              : '모든 설문을 완료해주세요',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
