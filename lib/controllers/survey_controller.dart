import 'package:get/get.dart';

class SurveyController extends GetxController {
  final RxBool isAlcoholSurveyCompleted = false.obs;
  final RxBool isDietSurveyCompleted = false.obs;
  final RxBool isSleepSurveyCompleted = false.obs;
  final RxBool isExerciseSurveyCompleted = false.obs;
  final RxBool isEmotionSurveyCompleted = false.obs;
  final RxBool isLifeQualitySurveyCompleted = false.obs;

  final Rx<bool> isAllSurveysCompleted = false.obs;

  @override
  void onInit() {
    super.onInit();

    ever(isDietSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isSleepSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isExerciseSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isAlcoholSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isEmotionSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isLifeQualitySurveyCompleted, (_) => _checkAllSurveysCompleted());
  }

  void _checkAllSurveysCompleted() {
    isAllSurveysCompleted.value = isDietSurveyCompleted.value &&
        isSleepSurveyCompleted.value &&
        isExerciseSurveyCompleted.value &&
        isAlcoholSurveyCompleted.value &&
        isEmotionSurveyCompleted.value &&
        isLifeQualitySurveyCompleted.value;
  }

  void completeAlcoholSurvey() {
    isAlcoholSurveyCompleted.value = true;
  }

  void completeDietSurvey() {
    isDietSurveyCompleted.value = true;
  }

  void completeEmotionSurvey() {
    isEmotionSurveyCompleted.value = true;
  }

  void completeExerciseSurvey() {
    isExerciseSurveyCompleted.value = true;
  }

  void completeLifeQualitySurvey() {
    isLifeQualitySurveyCompleted.value = true;
  }

  void completeSleepSurvey() {
    isSleepSurveyCompleted.value = true;
  }

  void resetAllSurveys() {
    isAlcoholSurveyCompleted.value = false;
    isDietSurveyCompleted.value = false;
    isSleepSurveyCompleted.value = false;
    isExerciseSurveyCompleted.value = false;
    isEmotionSurveyCompleted.value = false;
    isLifeQualitySurveyCompleted.value = false;
    isAllSurveysCompleted.value = false;

    update();
  }
}
