import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:dtxproject/models/weightinput_model.dart';
import 'package:dtxproject/services/weightinput_service.dart';
import 'package:dtxproject/controllers/auth_controller.dart';

class WeightPage extends StatelessWidget {
  WeightPage({super.key});

  // AuthController 인스턴스 가져오기
  final AuthController _authController = Get.find<AuthController>();

  // 체중 컨트롤러
  final TextEditingController weightController =
      TextEditingController(text: "70.0");
  final RxBool isEditing = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isInitializing = true.obs; // 초기 데이터 로딩 상태

  // 휠 픽커용 Rx 변수
  final RxInt selectedInteger = 70.obs;
  final RxInt selectedDecimal = 0.obs;

  // 최신 체중 기록
  final Rx<WeightInput?> latestWeight = Rx<WeightInput?>(null);

  @override
  Widget build(BuildContext context) {
    // 페이지가 로드될 때 최신 체중 기록 조회
    _fetchLatestWeight();

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
      body: Obx(() {
        if (isInitializing.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SafeArea(
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
                                                RegExp(
                                                    r'^\d+\.?\d{0,1}')), // 소수점 첫째자리까지만 허용
                                          ],
                                        ),
                                      )
                                    : Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              weightController.text.isEmpty
                                                  ? "0.0"
                                                  : weightController.text,
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
                          offset: const Offset(0, 70),
                          child: GestureDetector(
                            onTap: () {
                              _syncWeightToWheelPicker();
                              _showWeightWheelPicker(context);
                            },
                            child: Container(
                              width: 220,
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
        );
      }),
      bottomNavigationBar: _buildCompleteButton(),
    );
  }

  // 최신 체중 기록 조회
  Future<void> _fetchLatestWeight() async {
    if (_authController.user.value == null) {
      isInitializing.value = false;
      return;
    }

    try {
      isInitializing.value = true;
      final userId = _authController.user.value!.id!;

      // 최신 체중 기록 조회
      final latestWeightRecord =
          await WeightInputService.getLatestWeight(userId);

      if (latestWeightRecord != null) {
        latestWeight.value = latestWeightRecord;

        // 소수점 첫째자리까지만 표시하도록 포맷팅
        final weightStr = latestWeightRecord.weight.toStringAsFixed(1);
        weightController.text = weightStr;

        // 휠 픽커 값 동기화
        _syncWeightToWheelPicker();
      } else {
        // 기본값 설정
        weightController.text = "70.0";
        _syncWeightToWheelPicker();
      }
    } catch (e) {
      print('체중 기록 조회 오류: $e');
      weightController.text = "70.0";
      _syncWeightToWheelPicker();
    } finally {
      isInitializing.value = false;
    }
  }

  // 하단 완료 버튼 - API 호출 로직 추가
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
            child: Obx(() => ElevatedButton(
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          // 사용자 로그인 확인
                          if (_authController.user.value == null) {
                            Get.snackbar(
                              '오류',
                              '로그인이 필요합니다.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red[100],
                              colorText: Colors.red[800],
                            );
                            return;
                          }

                          // 체중 저장 로직
                          if (weightController.text.isEmpty) {
                            Get.snackbar('오류', '체중을 입력해주세요',
                                snackPosition: SnackPosition.BOTTOM);
                            return;
                          }

                          double? weight =
                              double.tryParse(weightController.text);
                          if (weight != null) {
                            try {
                              isLoading.value = true; // 로딩 시작

                              // 현재 로그인된 사용자의 ID 가져오기
                              final userId = _authController.user.value!.id;

                              // 체중 기록 모델 생성 (소수점 첫째자리까지만 저장)
                              final weightInput = WeightInput(
                                weight: double.parse(weight.toStringAsFixed(1)),
                                weightDate:
                                    WeightInputService.getTodayFormatted(),
                                userId: userId!,
                              );

                              // 체중 저장 API 호출
                              final success =
                                  await WeightInputService.saveWeight(
                                      weightInput);
                              isLoading.value = false; // 로딩 종료

                              if (success) {
                                // 딜레이 없이 바로 홈 화면으로 돌아가기
                                Get.back(result: weight.toString());

                                // 메시지는 홈 화면에서 표시
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  Get.snackbar(
                                    '성공',
                                    '체중이 성공적으로 저장되었습니다.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.green[100],
                                    colorText: Colors.green[800],
                                  );
                                });
                              } else {
                                // API 실패 시
                                Get.snackbar(
                                  '오류',
                                  '체중 저장에 실패했습니다. 다시 시도해주세요.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red[100],
                                  colorText: Colors.red[800],
                                );
                              }
                            } catch (e) {
                              isLoading.value = false; // 에러 발생 시 로딩 종료
                              Get.snackbar(
                                '오류',
                                '체중 저장 중 오류가 발생했습니다: $e',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red[100],
                                colorText: Colors.red[800],
                              );
                            }
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
                  child: isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        )
                      : const Text(
                          '완료',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                )),
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

                  // 소수점 부분 (소수점 첫째자리까지만)
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
