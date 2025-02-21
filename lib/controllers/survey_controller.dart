import 'package:get/get.dart';

class SurveyController extends GetxController {
  final RxBool isAlcoholSurveyCompleted = false.obs;
  final RxBool isDietSurveyCompleted = false.obs;
  final RxBool isSleepSurveyCompleted = false.obs;
  final RxBool isExerciseSurveyCompleted = false.obs;
  final RxBool isEmotionSurveyCompleted = false.obs;
  final RxBool isLifeQualitySurveyCompleted = false.obs;

  void completeAlcoholSurvey() {
    isAlcoholSurveyCompleted.value = true;
  }
}
