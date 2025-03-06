import 'package:get/get.dart';
import '../models/liver_data_model.dart';
import '../services/api_service.dart';
import '../constants/api_constants.dart';

class LiverController extends GetxController {
  final Rx<LiverData?> liverData = Rx<LiverData?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchLiverData(String patientId) async {
    isLoading.value = true;
    error.value = '';

    try {
      final response =
          await ApiService.get('${ApiConstants.liverData}/$patientId');

      if (response['statusCode'] == 200) {
        liverData.value = LiverData.fromJson(response['data']);
      } else {
        error.value = '데이터를 불러오는데 실패했습니다.';
      }
    } catch (e) {
      error.value = '오류가 발생했습니다: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
