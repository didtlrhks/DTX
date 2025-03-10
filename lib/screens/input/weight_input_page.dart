import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../survey_screens/survey_home_page.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/liver_controller.dart';

class WeightInputPage extends StatelessWidget {
  WeightInputPage({super.key});

  // GetX (사용자 정보, 간섬유화 위험도)
  final AuthController authController = Get.find<AuthController>();
  final LiverController liverController = Get.put(LiverController());

  // GetX 체중 초기 값
  final RxInt selectedInteger = 81.obs;
  final RxInt selectedDecimal = 7.obs;

  @override
  Widget build(BuildContext context) {
    // 간섬유화 위험도
    if (authController.user.value?.patientId != null) {
      liverController.fetchLiverData(authController.user.value!.patientId);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 간섬유화 위험도 표시
            Container(
              width: 200,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(42),
              ),
              child: const Center(
                child: Text(
                  '간섬유화 위험도 고위험',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Paperlogy',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
            ),

            // 이름 + 체중 목표 안내
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() {
                return Text(
                  '${authController.user.value?.username ?? ""}님의\n3달 체중 목표는',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20),

            // 체중 입력
            Stack(
              children: [
                // 맨 아래
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: 295,
                    height: 382,
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                // 가운데 사각형
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, 20), // Container A 상단에서 20픽셀 아래
                    child: Container(
                      width: 339,
                      height: 127,
                      decoration: BoxDecoration(
                        color: const Color(0xffB0B0B0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                // 체중입력틀 사각형
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: const Offset(0, 30),
                    child: Container(
                      width: 295,
                      height: 108,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 정수 NumberPicker
                          Obx(() => NumberPicker(
                                minValue: 0,
                                maxValue: 999,
                                value: selectedInteger.value,
                                itemHeight: 120 / 3,
                                axis: Axis.vertical,
                                textStyle: const TextStyle(
                                    fontFamily: "Paperlogy",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: Colors.grey),
                                selectedTextStyle: const TextStyle(
                                    fontFamily: "Paperlogy",
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                                onChanged: (value) =>
                                    selectedInteger.value = value,
                              )),
                          const Text(
                            ".",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          // 소수점 NumberPicker
                          Obx(() => NumberPicker(
                                minValue: 0,
                                maxValue: 9,
                                value: selectedDecimal.value,
                                itemHeight: 120 / 3,
                                axis: Axis.vertical,
                                textStyle: const TextStyle(
                                    fontFamily: "Paperlogy",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 32,
                                    color: Colors.grey),
                                selectedTextStyle: const TextStyle(
                                    fontFamily: "Paperlogy",
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                                onChanged: (value) =>
                                    selectedDecimal.value = value,
                              )),
                          const Text(
                            " kg",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '현재 체중의 7% 이상을 감량해야\n간의 염증 소견이 줄어들 수 있습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            const Spacer(),
            // 다음 버튼
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        double userWeight = double.parse(
                            "${selectedInteger.value}.${selectedDecimal.value}");
                        Get.to(() => const SurveyHomePage(),
                            arguments: {'weight': userWeight});
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '다음',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
