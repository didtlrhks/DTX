import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'liver_fibrosis_result_page.dart';
import '../controllers/auth_controller.dart';
import '../controllers/liver_controller.dart';

class LiverFibrosisPage extends StatelessWidget {
  const LiverFibrosisPage({super.key});

  Widget _buildTrafficLight(String level, bool isActive) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (level == '황색등' ? Colors.orange : Colors.grey[300])
                : Colors.grey[300],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          level,
          style: TextStyle(
            color: isActive
                ? (level == '황색등' ? Colors.orange : Colors.grey)
                : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildIndexBar(String title, String subtitle, double value,
      {bool isHSI = false}) {
    const double barHeight = 160.0;
    const double barWidth = 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Paperlogy',
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: subtitle,
                style: const TextStyle(
                  color: Color(0xFF8E8E8E),
                  fontSize: 12,
                  fontFamily: 'Paperlogy',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: barHeight + 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isHSI) ...[
                // HSI 구분선 옆 숫자들 (왼쪽)
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: barHeight * 0.33 - 6),
                    Text(
                      '36',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: barHeight * 0.34 - 6),
                    Text(
                      '30',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(width: 4),
              ],
              // 게이지 바
              Stack(
                children: [
                  Container(
                    width: barWidth,
                    height: barHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color(0xFFE8E7E7), width: 1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 33,
                            child: Container(
                              width: barWidth,
                              color: const Color(0xFF9A9A9A),
                            ),
                          ),
                          Expanded(
                            flex: 34,
                            child: Container(
                              width: barWidth,
                              color: const Color(0xFFC9C9C9),
                            ),
                          ),
                          Expanded(
                            flex: 33,
                            child: Container(
                              width: barWidth,
                              color: const Color(0xFFE8E7E7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: _calculateMarkerPosition(value, isHSI, barHeight),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF363636),
                        border: Border.all(color: Colors.white, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (!isHSI) ...[
                // FLI 구분선 옆 숫자들 (오른쪽)
                const SizedBox(width: 4),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: barHeight * 0.33 - 6),
                    Text(
                      '60',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: barHeight * 0.34 - 6),
                    Text(
                      '30',
                      style: TextStyle(
                        color: Color(0xFF363636),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  double _calculateMarkerPosition(double value, bool isHSI, double barHeight) {
    double minValue = isHSI ? 30 : 0;
    double maxValue = isHSI ? 36 : 60;
    double normalizedValue = (value - minValue) / (maxValue - minValue);
    // Invert the position since the bar is vertical (0 is at the bottom)
    double position = (1 - normalizedValue) * (barHeight - 8);
    // Ensure the marker stays within bounds
    return position.clamp(0.0, barHeight - 8);
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final LiverController liverController = Get.put(LiverController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authController.user.value?.patientId != null) {
        liverController.fetchLiverData(authController.user.value!.patientId);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (liverController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final liverData = liverController.liverData.value;
            if (liverData == null) {
              return const Center(child: Text('데이터가 없습니다.'));
            }

            final hsiValue = liverData.indices.hsi.value;
            final fliValue = liverData.indices.fli.value;

            print('HSI Value: $hsiValue');
            print('FLI Value: $fliValue');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '주의해요!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${authController.user.value?.username ?? ""}님의 간섬유화 위험도는',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTrafficLight('정상등', false),
                          _buildTrafficLight('황색등', true),
                          _buildTrafficLight('적색등', false),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '간지방증 위험도는 중등도 위험입니다.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '간에 영향을 주는 음식, 술에 대해 주의하세요.\n3개월 뒤 추적검사 확인을 권합니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${authController.user.value?.username ?? ""}님의 간섬유화 지수',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildIndexBar('간 지방증 지수', '(HSI)', hsiValue,
                                isHSI: true),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _buildIndexBar('지방간 지수', '(FLI)', fliValue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '간섬유화 검사는 이런 검사를 해요.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '지방간은 얼마나 많하며 간 내 5% 이상의 지방 침착이 되는 상황입니다. 간 지방증 검사는 혈액 검사와 체질량지수 등을 가지고 지방간이 있을 확률을 보여주는 것으로, 정밀한 검사는 초음파 나 MRI 등으로 확인하실 권합니다.',
                        style: TextStyle(
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '정보 출처 : 대한간학회',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
