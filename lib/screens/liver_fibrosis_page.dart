import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'liver_fibrosis_result_page.dart';
import '../controllers/auth_controller.dart';

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
                const Text(
                  '환자 정보',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final emrData = authController.user.value?.emrData;
                  if (emrData == null) {
                    return const Center(
                      child: Text('EMR 데이터가 없습니다.'),
                    );
                  }

                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEmrDataItem('환자명', emrData['patient_name']),
                          _buildEmrDataItem('환자 ID', emrData['patient_id']),
                          _buildEmrDataItem('이메일', emrData['email']),
                          _buildEmrDataItem('전화번호', emrData['phone']),
                          _buildEmrDataItem('생년월일', emrData['birth_date']),
                          _buildEmrDataItem('성별', emrData['gender']),
                          const Divider(),
                          const Text(
                            '검사 결과',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildEmrDataItem('AST', '${emrData['ast']} U/L'),
                          _buildEmrDataItem('ALT', '${emrData['alt']} U/L'),
                          _buildEmrDataItem('GGT', '${emrData['ggt']} U/L'),
                          _buildEmrDataItem(
                              '허리둘레', '${emrData['waist_circumference']} cm'),
                          _buildEmrDataItem('BMI', '${emrData['bmi']} kg/m²'),
                          _buildEmrDataItem(
                              '공복혈당', '${emrData['glucose']} mg/dL'),
                          _buildEmrDataItem('당화혈색소', '${emrData['hba1c']}%'),
                          _buildEmrDataItem(
                              '중성지방', '${emrData['triglyceride']} mg/dL'),
                          _buildEmrDataItem(
                              'LDL 콜레스테롤', '${emrData['ldl']} mg/dL'),
                          _buildEmrDataItem(
                              'HDL 콜레스테롤', '${emrData['hdl']} mg/dL'),
                          _buildEmrDataItem(
                              '요산', '${emrData['uric_acid']} mg/dL'),
                          _buildEmrDataItem('수축기 혈압', '${emrData['sbp']} mmHg'),
                          _buildEmrDataItem('이완기 혈압', '${emrData['dbp']} mmHg'),
                          _buildEmrDataItem(
                              'GFR', '${emrData['gfr']} mL/min/1.73m²'),
                          _buildEmrDataItem('혈소판', '${emrData['plt']} x10³/μL'),
                          const Divider(),
                          const Text(
                            '진료 기록',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildEmrDataItem('진료기록', emrData['medical_record']),
                          _buildEmrDataItem(
                              '처방기록', emrData['prescription_record']),
                          _buildEmrDataItem('최초 등록일', emrData['created_at']),
                          _buildEmrDataItem('최근 수정일', emrData['last_updated']),
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
