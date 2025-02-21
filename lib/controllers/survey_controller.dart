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
}

//   void completeSleepSurvey() {
//     isSleepSurveyCompleted.value = true;
//   }

//   void completeExerciseSurvey() {
//     isExerciseSurveyCompleted.value = true;
//   }

//   void completeLifeQualitySurvey() {
//     isLifeQualitySurveyCompleted.value = true;
//   }
// }
