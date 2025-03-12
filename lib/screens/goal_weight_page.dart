import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dtxproject/controllers/auth_controller.dart';
import 'package:dtxproject/screens/survey_screens/survey_home_page.dart';
import 'package:animated_digit/animated_digit.dart';

class GoalWeightPage extends StatefulWidget {
  const GoalWeightPage({super.key});

  @override
  _GoalWeightPageState createState() => _GoalWeightPageState();
}

class _GoalWeightPageState extends State<GoalWeightPage> {
  // GetX로 사용자 데이터 관리
  final AuthController authController = Get.find<AuthController>();
  // 목표체중의 각 자리수
  late int targetHundreds, targetTens, targetOnes, targetDecimal;
  // 체중 세자리인지 여부
  late bool hasHundreds;
  //애니메이션 완료 여부
  bool animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _calculateTargetWeight(); // 목표체중 계산
    Future.delayed(
        const Duration(milliseconds: 500), () => _startSlotAnimation());
  }

  // 사용자 체중 불러오기(GetX에서 emr추출)
  double? _getUserWeight() {
    final user = authController.user.value;
    if (user != null &&
        user.emrData != null &&
        user.emrData!.containsKey('weight')) {
      final weightValue = user.emrData!['weight'];
      if (weightValue is num) {
        return weightValue.toDouble();
      } else if (weightValue is String) {
        return double.tryParse(weightValue);
      }
    }
    return null;
  }

  // 7% 감량체중 계산 함수 (소수점 1자리까지 반올림)
  void _calculateTargetWeight() {
    double? currentWeight = _getUserWeight();
    if (currentWeight != null) {
      double target = currentWeight * 0.93;
      String weightStr = target.toStringAsFixed(1);
      List<String> parts = weightStr.split('.');
      String integerPart = parts[0];
      String decimalPart = parts[1];

      // 체중 세자리수인지 확인
      hasHundreds = integerPart.length == 3;
      if (hasHundreds) {
        targetHundreds = int.parse(integerPart[0]);
        targetTens = int.parse(integerPart[1]);
        targetOnes = int.parse(integerPart[2]);
      } else {
        targetTens = int.parse(integerPart[0]);
        targetOnes = int.parse(integerPart[1]);
      }
      targetDecimal = int.parse(decimalPart);
    }
  }

  // 애니메이션 자동 실행 (1초)
  void _startSlotAnimation() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() => animationCompleted = true);
  }

  @override
  Widget build(BuildContext context) {
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
      // 사용자 목표 체중표시 구역
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  return Text(
                    '${authController.user.value?.username ?? ""}님의\n3달 체중 목표는',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 28,
                        fontFamily: 'Paperlogy',
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000)),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 박스
              SizedBox(
                height: 382,
                child: Stack(
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
                    // 체중보여지는 사각형
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
                              //목표체중 애니메이션 표시
                              _buildSlotMachine(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //하단 설명
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '현재 체중의 7% 이상 감량해야\n간의 염증 소견이 줄어들 수 있습니다.',
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
      bottomNavigationBar: _buildNextButton(),
    );
  }

// 체중 슬롯머신 UI 위젯
  Widget _buildSlotMachine() {
    return Container(
      width: 295,
      height: 108,
      decoration: BoxDecoration(
        color: const Color(0xffD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasHundreds) _buildAnimatedDigit(targetHundreds),
          _buildAnimatedDigit(targetTens),
          _buildAnimatedDigit(targetOnes),
          const Text(".",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          _buildAnimatedDigit(targetDecimal),
          const Text(" kg",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  //애니메이션 적용 숫자 표시 위젯
  Widget _buildAnimatedDigit(int target) {
    return SizedBox(
      width: 40,
      height: 80,
      child: Center(
        child: AnimatedDigitWidget(
          value: target.toDouble(),
          duration: const Duration(seconds: 2),
          textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // 다음 버튼
  Widget _buildNextButton() {
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
                double userWeight = double.parse(
                    "${hasHundreds ? targetHundreds : ''}$targetTens$targetOnes.$targetDecimal");
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
    );
  }
}
