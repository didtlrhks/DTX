import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';

class WeightPage extends StatelessWidget {
  WeightPage({super.key});

  // 체중 컨트롤러
  final TextEditingController weightController =
      TextEditingController(text: "81.7");
  final RxBool isEditing = false.obs;

  // 휠 픽커용 Rx 변수
  final RxInt selectedInteger = 81.obs;
  final RxInt selectedDecimal = 7.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(result: 'cancel'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 타이틀
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '오늘의 체중은',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 체중 표시 중첩 컨테이너
              SizedBox(
                height: 382,
                child: Stack(
                  children: [
                    // 맨 아래 컨테이너
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

                    // 가운데 회색 사각형
                    Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: const Offset(0, 20),
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

                    // 체중 표시 영역
                    Align(
                      alignment: Alignment.topCenter,
                      child: Transform.translate(
                        offset: const Offset(0, 30),
                        child: GestureDetector(
                          onTap: () {
                            isEditing.value = true;
                          },
                          child: Container(
                            width: 295,
                            height: 108,
                            decoration: BoxDecoration(
                              color: const Color(0xffD9D9D9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Obx(
                              () => isEditing.value
                                  ? Center(
                                      child: TextField(
                                        controller: weightController,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "체중 입력",
                                          suffixText: "kg",
                                        ),
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        onSubmitted: (_) {
                                          isEditing.value = false;
                                          _syncWeightToWheelPicker();
                                        },
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d{0,1}')),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            weightController.text,
                                            style: const TextStyle(
                                              fontSize: 36,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Text(
                                            " kg",
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 체중계 올리기 버튼
                    Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: const Offset(0, 80),
                        child: GestureDetector(
                          onTap: () {
                            _syncWeightToWheelPicker();
                            _showWeightWheelPicker(context);
                          },
                          child: Container(
                            width: 270,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '체중계\n올리기',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
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

              const SizedBox(height: 20),

              // 안내 텍스트
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '현재 체중의 7% 이상을 감량해야 간의\n염증 소견이 줄어들 수 있습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff727272),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCompleteButton(),
    );
  }

  // 하단 완료 버튼
  Widget _buildCompleteButton() {
    return Container(
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
                // 체중 저장 로직
                if (weightController.text.isEmpty) {
                  Get.snackbar('오류', '체중을 입력해주세요',
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                double? weight = double.tryParse(weightController.text);
                if (weight != null) {
                  Get.back(result: weight.toString());
                } else {
                  Get.snackbar('오류', '유효한 체중 값을 입력해주세요',
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '완료',
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
    );
  }

  // 체중값과 휠 픽커 값 동기화
  void _syncWeightToWheelPicker() {
    final parts = weightController.text.split('.');
    try {
      selectedInteger.value = int.parse(parts[0]);
      if (parts.length > 1 && parts[1].isNotEmpty) {
        selectedDecimal.value = int.parse(parts[1][0]);
      } else {
        selectedDecimal.value = 0;
      }
    } catch (e) {
      // 파싱 오류가 있을 경우 기본값으로 설정
      selectedInteger.value = 70;
      selectedDecimal.value = 0;
    }
  }

  // 텍스트 필드와 휠 픽커 값 동기화
  void _syncWheelPickerToWeight() {
    weightController.text = "${selectedInteger.value}.${selectedDecimal.value}";
  }

  // 체중 휠 픽커 다이얼로그
  void _showWeightWheelPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 핸들바
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // 타이틀
              const Text(
                '체중 선택',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // 휠 픽커
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 정수 부분 (kg)
                  Obx(() => NumberPicker(
                        minValue: 30,
                        maxValue: 200,
                        value: selectedInteger.value,
                        onChanged: (value) {
                          selectedInteger.value = value;
                          _syncWheelPickerToWeight();
                        },
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[400],
                        ),
                        selectedTextStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        itemHeight: 60,
                        itemWidth: 80,
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // 소수점 부분
                  Obx(() => NumberPicker(
                        minValue: 0,
                        maxValue: 9,
                        value: selectedDecimal.value,
                        onChanged: (value) {
                          selectedDecimal.value = value;
                          _syncWheelPickerToWeight();
                        },
                        textStyle: TextStyle(
                          fontSize: 22,
                          color: Colors.grey[400],
                        ),
                        selectedTextStyle: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        itemHeight: 60,
                        itemWidth: 50,
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

              const Spacer(),

              // 확인 버튼
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
