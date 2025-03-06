import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'liver_fibrosis_result_page.dart';
import '../controllers/auth_controller.dart';
import '../controllers/liver_controller.dart';

class LiverFibrosisPage extends StatelessWidget {
  const LiverFibrosisPage({super.key});

  Widget _buildEmrDataItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value?.toString() ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final LiverController liverController = Get.put(LiverController());

    // 컨트롤러가 초기화되면 데이터를 가져옵니다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authController.user.value?.patientId != null) {
        liverController.fetchLiverData(authController.user.value!.patientId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('간섬유화 위험도'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '간섬유화 위험도 분석',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() {
                  if (liverController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (liverController.error.value.isNotEmpty) {
                    return Center(
                      child: Text(
                        liverController.error.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final liverData = liverController.liverData.value;
                  if (liverData == null) {
                    return const Center(
                      child: Text('간섬유화 데이터가 없습니다.'),
                    );
                  }

                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '지방간 지수',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildEmrDataItem(
                              'FLI 값', '${liverData.indices.fli.value}'),
                          _buildEmrDataItem(
                              'FLI 해석', liverData.indices.fli.interpretation),
                          _buildEmrDataItem(
                              'HSI 값', '${liverData.indices.hsi.value}'),
                          _buildEmrDataItem(
                              'HSI 해석', liverData.indices.hsi.interpretation),
                          const Divider(),
                          const Text(
                            '참조 값',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildEmrDataItem('중성지방',
                              '${liverData.referenceValues.triglyceride} mg/dL'),
                          _buildEmrDataItem(
                              'BMI', '${liverData.referenceValues.bmi} kg/m²'),
                          _buildEmrDataItem(
                              'GGT', '${liverData.referenceValues.ggt} U/L'),
                          _buildEmrDataItem('허리둘레',
                              '${liverData.referenceValues.waistCircumference} cm'),
                          _buildEmrDataItem(
                              'ALT', '${liverData.referenceValues.alt} U/L'),
                          _buildEmrDataItem(
                              'AST', '${liverData.referenceValues.ast} U/L'),
                          _buildEmrDataItem(
                              '당뇨 여부',
                              liverData.referenceValues.hasDiabetes
                                  ? '있음'
                                  : '없음'),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const LiverFibrosisResultPage());
                    },
                    child: const Text('간섬유화 위험도 분석하기'),
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
