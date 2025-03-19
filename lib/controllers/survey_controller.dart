import 'package:get/get.dart';

class SurveyController extends GetxController {
  final RxBool isAlcoholSurveyCompleted = false.obs;
  final RxBool isDietSurveyCompleted = false.obs;
  final RxBool isSleepSurveyCompleted = false.obs;
  final RxBool isExerciseSurveyCompleted = false.obs;
  final RxBool isEmotionSurveyCompleted = false.obs;
  final RxBool isLifeQualitySurveyCompleted = false.obs;
  final RxBool isSickSurveyCompleted = false.obs;

  final Rx<bool> isAllSurveysCompleted = false.obs;

  // 음주 문항
  final RxInt alcoholQ1Option = (-1).obs;
  final RxString alcoholQ1InputText = "".obs;
  final RxString alcoholQ2InputText = "".obs;

  // 수면 문항
  final RxInt SleepQ1Option = (-1).obs;
  final RxInt SleepQ2Option = (-1).obs;
  final RxInt SleepQ3Option = (-1).obs;
  final RxInt SleepQ4Option = (-1).obs;
  final RxInt SleepQ5Option = (-1).obs;
  final RxInt SleepQ6Option = (-1).obs;
  final RxInt SleepQ7Option = (-1).obs;

  // 삶의질 문항
  final RxInt LifeQualityQ1Option = (-1).obs;
  final RxInt LifeQualityQ2Option = (-1).obs;
  final RxInt LifeQualityQ3Option = (-1).obs;
  final RxInt LifeQualityQ4Option = (-1).obs;
  final RxInt LifeQualityQ5Option = (-1).obs;
  final RxInt LifeQualityQ6Option = (-1).obs;
  final RxInt LifeQualityQ7Option = (-1).obs;
  final RxInt LifeQualityQ8Option = (-1).obs;

  @override
  void onInit() {
    super.onInit();

    ever(isDietSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isSleepSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isExerciseSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isAlcoholSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isEmotionSurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isLifeQualitySurveyCompleted, (_) => _checkAllSurveysCompleted());
    ever(isSickSurveyCompleted, (_) => _checkAllSurveysCompleted());
  }

  void _checkAllSurveysCompleted() {
    isAllSurveysCompleted.value = isDietSurveyCompleted.value &&
        isSleepSurveyCompleted.value &&
        isExerciseSurveyCompleted.value &&
        isAlcoholSurveyCompleted.value &&
        isEmotionSurveyCompleted.value &&
        isLifeQualitySurveyCompleted.value &&
        isSickSurveyCompleted.value;
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

  void completeSickSurvey() {
    isSickSurveyCompleted.value = true;
  }

  void resetAllSurveys() {
    isAlcoholSurveyCompleted.value = false;
    isDietSurveyCompleted.value = false;
    isSleepSurveyCompleted.value = false;
    isExerciseSurveyCompleted.value = false;
    isEmotionSurveyCompleted.value = false;
    isLifeQualitySurveyCompleted.value = false;
    isSickSurveyCompleted.value = false;
    isAllSurveysCompleted.value = false;

    update();
  }

  void resetAlcoholSurveys() {
    isAlcoholSurveyCompleted.value = false;
  }

  void resetDietSurveys() {
    isDietSurveyCompleted.value = false;
  }

  void resetSleepSurveys() {
    isSleepSurveyCompleted.value = false;
  }

  void resetExerciseSurveys() {
    isExerciseSurveyCompleted.value = false;
  }

  void resetEmotionSurveys() {
    isEmotionSurveyCompleted.value = false;
  }

  void resetLifeQualitySurveys() {
    isLifeQualitySurveyCompleted.value = false;
  }

  void resetSickSurveySurveys() {
    isSickSurveyCompleted.value = false;
  }

  // 음주 설문 초기화)
  void clearAlcoholSurveys() {
    alcoholQ1Option.value = -1;
    alcoholQ1InputText.value = "";
    alcoholQ2InputText.value = "";
  }

  // 수면 설문 초기화)
  void clearSleepSurveys() {
    SleepQ1Option.value = -1;
    SleepQ2Option.value = -1;
    SleepQ3Option.value = -1;
    SleepQ4Option.value = -1;
    SleepQ5Option.value = -1;
    SleepQ6Option.value = -1;
    SleepQ7Option.value = -1;
  }

  // 삶의질설문 초기화)
  void clearLifeQualitySurveys() {
    LifeQualityQ1Option.value = -1;
    LifeQualityQ2Option.value = -1;
    LifeQualityQ3Option.value = -1;
    LifeQualityQ4Option.value = -1;
    LifeQualityQ5Option.value = -1;
    LifeQualityQ6Option.value = -1;
    LifeQualityQ7Option.value = -1;
    LifeQualityQ8Option.value = -1;
  }
}
