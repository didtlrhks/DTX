import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class WeightPage extends StatelessWidget {
  WeightPage({super.key});

  // GetX 체중 초기 값
  final RxInt selectedInteger = 70.obs;
  final RxInt selectedDecimal = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('체중 기록'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // 체중 저장 로직
              double weight = double.parse(
                  "${selectedInteger.value}.${selectedDecimal.value}");
              Get.back();
              Get.snackbar('저장 완료', '체중 $weight kg이 기록되었습니다.',
                  snackPosition: SnackPosition.BOTTOM);
            },
            child: const Text('저장', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 안내 텍스트
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              width: double.infinity,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 체중을 기록해주세요',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '매일 같은 시간에 체중을 측정하면 더 정확한 변화를 확인할 수 있습니다.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 체중 입력 UI
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      '체중',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 정수 부분 NumberPicker
                        Obx(() => NumberPicker(
                              minValue: 30,
                              maxValue: 200,
                              value: selectedInteger.value,
                              itemHeight: 60,
                              itemWidth: 80,
                              axis: Axis.vertical,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                              ),
                              selectedTextStyle: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              onChanged: (value) =>
                                  selectedInteger.value = value,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                            )),

                        const Text(
                          ".",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // 소수점 부분 NumberPicker
                        Obx(() => NumberPicker(
                              minValue: 0,
                              maxValue: 9,
                              value: selectedDecimal.value,
                              itemHeight: 60,
                              itemWidth: 60,
                              axis: Axis.vertical,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                color: Colors.grey,
                              ),
                              selectedTextStyle: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              onChanged: (value) =>
                                  selectedDecimal.value = value,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                              ),
                            )),

                        const Text(
                          " kg",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 현재 선택된 체중 표시
            Obx(() => Text(
                  '현재 선택: ${selectedInteger.value}.${selectedDecimal.value} kg',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                )),

            const Spacer(),

            // 저장 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // 체중 저장 로직
                    double weight = double.parse(
                        "${selectedInteger.value}.${selectedDecimal.value}");
                    Get.back();
                    Get.snackbar('저장 완료', '체중 $weight kg이 기록되었습니다.',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
