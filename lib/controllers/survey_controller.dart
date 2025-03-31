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
  final RxInt sleepQ1Option = (-1).obs;
  final RxInt sleepQ2Option = (-1).obs;
  final RxInt sleepQ3Option = (-1).obs;
  final RxInt sleepQ4Option = (-1).obs;
  final RxInt sleepQ5Option = (-1).obs;
  final RxInt sleepQ6Option = (-1).obs;
  final RxInt sleepQ7Option = (-1).obs;

  // 삶의질 문항
  final RxInt lifeQualityQ1Option = (-1).obs;
  final RxInt lifeQualityQ2Option = (-1).obs;
  final RxInt lifeQualityQ3Option = (-1).obs;
  final RxInt lifeQualityQ4Option = (-1).obs;
  final RxInt lifeQualityQ5Option = (-1).obs;
  final RxInt lifeQualityQ6Option = (-1).obs;
  final RxInt lifeQualityQ7Option = (-1).obs;
  final RxInt lifeQualityQ8Option = (-1).obs;

  // 감정 문항
  final RxInt emotionQ1Option = (-1).obs;
  final RxInt emotionQ2Option = (-1).obs;
  final RxInt emotionQ3Option = (-1).obs;
  final RxInt emotionQ4Option = (-1).obs;
  final RxInt emotionQ5Option = (-1).obs;
  final RxInt emotionQ6Option = (-1).obs;
  final RxInt emotionQ7Option = (-1).obs;
  final RxInt emotionQ8Option = (-1).obs;
  final RxInt emotionQ9Option = (-1).obs;
  final RxInt emotionQ10Option = (-1).obs;
  final RxInt emotionQ11Option = (-1).obs;
  final RxInt emotionQ12Option = (-1).obs;
  final RxInt emotionQ13Option = (-1).obs;
  final RxInt emotionQ14Option = (-1).obs;

  // 운동 문항
  final RxInt exerciseQ1Option = (-1).obs;
  final RxString exerciseQ21InputText = "".obs; //2번 문항 시간
  final RxString exerciseQ22nputText = "".obs; //2번 문항 분
  final RxInt exerciseQ3Option = (-1).obs;
  final RxInt exerciseQ4Option = (-1).obs;
  final RxString exerciseQ51InputText = "".obs; //5번 문항 시간
  final RxString exerciseQ52InputText = "".obs; //5번 문항 분
  final RxInt exerciseQ6Option = (-1).obs;
  final RxString exerciseQ71InputText = "".obs; //7번 문항 시간
  final RxString exerciseQ72InputText = "".obs; //7번 문항 분

  // 식사 문항
  final RxInt dietQ1Option = (-1).obs;
  final RxInt dietQ2Option = (-1).obs;
  final RxInt dietQ3Option = (-1).obs;
  final RxInt dietQ4Option = (-1).obs;
  final RxInt dietQ5Option = (-1).obs;
  final RxInt dietQ6Option = (-1).obs;
  final RxInt dietQ7Option = (-1).obs;
  final RxInt dietQ8Option = (-1).obs;
  final RxInt dietQ9Option = (-1).obs;
  final RxInt dietQ10Option = (-1).obs;
  final RxInt dietQ11Option = (-1).obs;
  final RxInt dietQ12Option = (-1).obs;
  final RxInt dietQ13Option = (-1).obs;
  final RxInt dietQ14Option = (-1).obs;
  final RxInt dietQ15Option = (-1).obs;
  final RxInt dietQ16Option = (-1).obs;
  final RxInt dietQ17Option = (-1).obs;
  final RxInt dietQ18Option = (-1).obs;
  final RxInt dietQ19Option = (-1).obs;
  final RxInt dietQ20Option = (-1).obs;
  final RxInt dietQ21Option = (-1).obs;
  final RxInt dietQ22Option = (-1).obs;
  final RxInt dietQ23Option = (-1).obs;
  final RxInt dietQ24Option = (-1).obs;
  final RxInt dietQ25Option = (-1).obs;
  final RxInt dietQ26Option = (-1).obs;
  final RxInt dietQ27Option = (-1).obs;
  final RxInt dietQ28Option = (-1).obs;
  final RxInt dietQ29Option = (-1).obs;
  final RxInt dietQ30Option = (-1).obs;
  final RxInt dietQ31Option = (-1).obs;
  final RxInt dietQ32Option = (-1).obs;
  final RxInt dietQ33Option = (-1).obs;
  final RxInt dietQ34Option = (-1).obs;
  final RxInt dietQ35Option = (-1).obs;
  final RxInt dietQ36Option = (-1).obs;
  final RxInt dietQ37Option = (-1).obs;
  final RxInt dietQ38Option = (-1).obs;
  final RxInt dietQ39Option = (-1).obs;
  final RxInt dietQ40Option = (-1).obs;

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

  // 음주 설문 초기화
  void clearAlcoholSurveys() {
    alcoholQ1Option.value = -1;
    alcoholQ1InputText.value = "";
    alcoholQ2InputText.value = "";
  }

  // 수면 설문 초기화
  void clearSleepSurveys() {
    sleepQ1Option.value = -1;
    sleepQ2Option.value = -1;
    sleepQ3Option.value = -1;
    sleepQ4Option.value = -1;
    sleepQ5Option.value = -1;
    sleepQ6Option.value = -1;
    sleepQ7Option.value = -1;
  }

  // 삶의질설문 초기화
  void clearLifeQualitySurveys() {
    lifeQualityQ1Option.value = -1;
    lifeQualityQ2Option.value = -1;
    lifeQualityQ3Option.value = -1;
    lifeQualityQ4Option.value = -1;
    lifeQualityQ5Option.value = -1;
    lifeQualityQ6Option.value = -1;
    lifeQualityQ7Option.value = -1;
    lifeQualityQ8Option.value = -1;
  }

  // 감정설문 초기화
  void clearEmotionSurveys() {
    emotionQ1Option.value = -1;
    emotionQ2Option.value = -1;
    emotionQ3Option.value = -1;
    emotionQ4Option.value = -1;
    emotionQ5Option.value = -1;
    emotionQ6Option.value = -1;
    emotionQ7Option.value = -1;
    emotionQ8Option.value = -1;
    emotionQ9Option.value = -1;
    emotionQ10Option.value = -1;
    emotionQ11Option.value = -1;
    emotionQ12Option.value = -1;
    emotionQ13Option.value = -1;
    emotionQ14Option.value = -1;
  }

  // 운동 설문 초기화
  void clearExerciseSurveys() {
    exerciseQ1Option.value = -1;
    exerciseQ21InputText.value = "";
    exerciseQ22nputText.value = "";
    exerciseQ3Option.value = -1;
    exerciseQ4Option.value = -1;
    exerciseQ51InputText.value = "";
    exerciseQ52InputText.value = "";
    exerciseQ6Option.value = -1;
    exerciseQ71InputText.value = "";
    exerciseQ72InputText.value = "";
  }

  // 식사설문 초기화
  void clearDietSurveys() {
    dietQ1Option.value = -1;
    dietQ2Option.value = -1;
    dietQ3Option.value = -1;
    dietQ4Option.value = -1;
    dietQ5Option.value = -1;
    dietQ6Option.value = -1;
    dietQ7Option.value = -1;
    dietQ8Option.value = -1;
    dietQ9Option.value = -1;
    dietQ10Option.value = -1;
    dietQ11Option.value = -1;
    dietQ12Option.value = -1;
    dietQ13Option.value = -1;
    dietQ14Option.value = -1;
    dietQ15Option.value = -1;
    dietQ16Option.value = -1;
    dietQ17Option.value = -1;
    dietQ18Option.value = -1;
    dietQ19Option.value = -1;
    dietQ20Option.value = -1;
    dietQ21Option.value = -1;
    dietQ22Option.value = -1;
    dietQ23Option.value = -1;
    dietQ24Option.value = -1;
    dietQ25Option.value = -1;
    dietQ26Option.value = -1;
    dietQ27Option.value = -1;
    dietQ28Option.value = -1;
    dietQ29Option.value = -1;
    dietQ30Option.value = -1;
    dietQ31Option.value = -1;
    dietQ32Option.value = -1;
    dietQ33Option.value = -1;
    dietQ34Option.value = -1;
    dietQ35Option.value = -1;
    dietQ36Option.value = -1;
    dietQ37Option.value = -1;
    dietQ38Option.value = -1;
    dietQ39Option.value = -1;
    dietQ40Option.value = -1;
  }
}
