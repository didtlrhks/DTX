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

  //객관식, 주관식 응답값(현재 설문 진행 데이터)
  var selectedOption = (-1).obs; // 객관식 선택값
  var inputText = "".obs; // 주관식(페이지 1)
  var inputText2 = "".obs; // 주관식(페이지 2)

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

    update();
  }

  void DietSurveySurveys() {
    isDietSurveyCompleted.value = false;

    update();
  }

  void resetSleepSurveys() {
    isSleepSurveyCompleted.value = false;

    update();
  }

  void resetExerciseSurveys() {
    isExerciseSurveyCompleted.value = false;

    update();
  }

  void resetEmotionSurveys() {
    isEmotionSurveyCompleted.value = false;

    update();
  }

  void resetLifeQualitySurveys() {
    isLifeQualitySurveyCompleted.value = false;

    update();
  }

  void resetSickSurveySurveys() {
    isSickSurveyCompleted.value = false;

    update();
  }

  void clearAlcoholSurveyData() {
    selectedOption.value = -1; // 객관식 초기화
    inputText.value = ""; // 주관식(페이지 1) 초기화
    inputText2.value = ""; // 주관식(페이지 2) 초기화

    update(); // UI 업데이트
  }
}
