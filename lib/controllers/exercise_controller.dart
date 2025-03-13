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

    try {
      // 사용자 ID 설정
      if (_authController.user.value != null &&
          _authController.user.value!.id != null) {
        _exerciseService.setUserId(_authController.user.value!.id!);
        print('사용자 ID 설정: ${_authController.user.value!.id!}');
      } else {
        // 임시로 사용자 ID를 1로 설정 (테스트용)
        _exerciseService.setUserId(1);
        print('임시 사용자 ID 설정: 1');
      }
    } catch (e) {
      // 오류 발생 시 임시 ID 사용
      _exerciseService.setUserId(1);
      print('사용자 ID 설정 오류, 임시 ID 사용: $e');
    }

    fetchExercises();
  }

  // 운동 기록 목록 가져오기
  Future<void> fetchExercises() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      print('운동 기록 조회 시작...');
      final fetchedExercises = await _exerciseService.getExercises();
      print('조회된 운동 기록 수: ${fetchedExercises.length}');

      // 조회된 데이터 설정
      exercises.value = fetchedExercises;

      // 디버깅을 위해 조회된 데이터 출력
      if (fetchedExercises.isNotEmpty) {
        print(
            '첫 번째 운동 기록: ${fetchedExercises[0].exercise_text}, 강도: ${fetchedExercises[0].intensity}');
      } else {
        print('조회된 운동 기록이 없습니다.');
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('운동 기록 조회 오류: $e');
      // 오류 발생 시 빈 목록으로 초기화
      exercises.value = [];
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
      final now = DateTime.now();
      final tempExercise = ExerciseModel(
        exercise_text: text,
        intensity: ExerciseModel.intensityToString(intensity),
        exercise_date:
            "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        user_id: 0,
        id: 'temp_${now.millisecondsSinceEpoch}',
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
