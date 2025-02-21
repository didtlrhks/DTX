import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/screens/survey_screens/survey_home_page.dart';
import 'package:dtxproject/controllers/survey_controller.dart';
import 'package:dtxproject/screens/survey_screens/exercise_survey/exercise_survey_start_page.dart';

class ExerciseSurveyEndPage extends StatelessWidget {
  const ExerciseSurveyEndPage({super.key});

  @override
  Widget build(BuildContext context) {
    final surveyController = Get.find<SurveyController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 설문조사'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(() => const ExerciseSurveyStartPage());
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(
                  Icons.check_circle_outline,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  '설문조사가 완료되었습니다',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '귀하의 소중한 응답 감사합니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      surveyController.completeExerciseSurvey();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      '완료',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
