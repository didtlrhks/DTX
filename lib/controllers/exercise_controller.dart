import 'package:get/get.dart';
import 'package:dtxproject/models/exercise_model.dart';
import 'package:dtxproject/services/exercise_service.dart';
import 'package:dtxproject/controllers/auth_controller.dart';

class ExerciseController extends GetxController {
  final ExerciseService _exerciseService = Get.find<ExerciseService>();
  final AuthController _authController = Get.find<AuthController>();

  // 운동 기록 목록
  final RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;

  // 로딩 상태
  final RxBool isLoading = false.obs;

  // 에러 메시지
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 사용자 ID 설정
    if (_authController.user.value != null &&
        _authController.user.value!.id != null) {
      _exerciseService.setUserId(_authController.user.value!.id!);
    }

    fetchExercises();
  }

  // 운동 기록 목록 가져오기
  Future<void> fetchExercises() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final fetchedExercises = await _exerciseService.getExercises();
      exercises.value = fetchedExercises;
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error fetching exercises: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // 운동 기록 추가
  Future<bool> addExercise(String text, int intensity) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final addedExercise = await _exerciseService.addExercise(text, intensity);
      exercises.add(addedExercise);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error adding exercise: $e');

      // 서버 오류 시 로컬에서만 추가 (임시 처리)
      final tempExercise = ExerciseModel(
        exercise_text: text,
        intensity: ExerciseModel.intensityToString(intensity),
        exercise_date: DateTime.now().toString().split(' ')[0],
        user_id: 0,
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      );
      exercises.add(tempExercise);

      return true; // 사용자 경험을 위해 성공으로 처리
    } finally {
      isLoading.value = false;
    }
  }

  // 운동 기록 삭제
  Future<bool> deleteExercise(String id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _exerciseService.deleteExercise(id);
      exercises.removeWhere((exercise) => exercise.id == id);
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error deleting exercise: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // 여러 운동 기록 삭제
  Future<bool> deleteMultipleExercises(List<String> ids) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _exerciseService.deleteMultipleExercises(ids);
      exercises.removeWhere((exercise) => ids.contains(exercise.id));
      return true;
    } catch (e) {
      errorMessage.value = e.toString();
      print('Error deleting multiple exercises: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
