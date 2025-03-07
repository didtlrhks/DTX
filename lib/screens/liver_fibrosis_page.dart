import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'liver_fibrosis_result_page.dart';
import '../controllers/auth_controller.dart';
import '../controllers/liver_controller.dart';

class LiverFibrosisPage extends StatelessWidget {
  const LiverFibrosisPage({super.key});

  // Color _getHSIColor(double value) {
  //   if (value < 30) return const Color(0xFFFFDB4B); // 옅은 노랑
  //   if (value > 36) return Colors.red;
  //   return const Color(0xFFFFA500); // 황색
  // }

  Color _getFLIColor(double value) {
    if (value < -1.455) return const Color(0xFFFFDB4B); // 옅은 노랑 (지방간 가능성 낮음)
    if (value > 0.676) return Colors.red; // 빨강 (지방간 가능성 높음)
    return const Color(0xFFFFA500); // 황색 (중간)
  }

  Color _getFibrosisColor(double value) {
    if (value < 1.3) return const Color(0xFFFFDB4B); // 옅은 노랑 (섬유화 위험 낮음)
    if (value > 2.67) return Colors.red; // 빨강 (섬유화 위험 높음)
    return const Color(0xFFFFA500); // 황색 (중간)
  }

  Color _getTrafficLightColor(double fliValue, double fibrosisValue) {
    Color fliColor = _getFLIColor(fliValue);
    Color fibrosisColor = _getFibrosisColor(fibrosisValue);

    // 하나라도 빨간색인 경우
    if (fibrosisColor == Colors.red || fliColor == Colors.red) {
      return Colors.red;
    }
    // 둘 다 옅은 노랑색인 경우
    if (fliColor == const Color(0xFFFFDB4B) &&
        fibrosisColor == const Color(0xFFFFDB4B)) {
      return const Color(0xFFFFDB4B);
    }
    // 나머지 경우 (황색)
    return const Color(0xFFFFA500);
  }

  String _getRiskLevelText(Color trafficLightColor) {
    if (trafficLightColor == Colors.red) {
      return '간섬유화 위험도는 고도 위험입니다.';
    } else if (trafficLightColor == const Color(0xFFFFA500)) {
      return '간섬유화 위험도는 중등도 위험입니다.';
    } else {
      return '간섬유화 위험도는 경도 위험입니다.';
    }
  }

  String _getRiskLevelColoredPart(Color trafficLightColor) {
    if (trafficLightColor == Colors.red) {
      return '고도 위험';
    } else if (trafficLightColor == const Color(0xFFFFA500)) {
      return '중등도 위험';
    } else {
      return '경도 위험';
    }
  }

  String _getRiskTitle(Color trafficLightColor) {
    if (trafficLightColor == Colors.red) {
      return '위험해요!';
    } else if (trafficLightColor == const Color(0xFFFFA500)) {
      return '주의해요!';
    } else {
      return '관찰해요!';
    }
  }

  Widget _buildTrafficLight() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const circleSize = 88.0;
        const containerHeight = circleSize + 32;
        const spacing = 20.0;

        final liverController = Get.find<LiverController>();
        final fibrosisValue =
            liverController.liverData.value?.indices.fibrosis.value ?? 0;
        final fliValue =
            liverController.liverData.value?.indices.fli.value ?? 0;
        final trafficLightColor =
            _getTrafficLightColor(fliValue, fibrosisValue);

        Widget buildCircle(Color color) {
          return Container(
            width: circleSize,
            height: circleSize,
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          );
        }

        return Container(
          width: circleSize * 3 + spacing * 2 + 24,
          height: containerHeight,
          margin: EdgeInsets.symmetric(
              horizontal: (MediaQuery.of(context).size.width -
                      (circleSize * 3 + spacing * 2 + 35)) /
                  2),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -10,
                top: containerHeight / 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildCircle(trafficLightColor == Colors.red
                        ? Colors.red
                        : Colors.grey[300]!),
                    buildCircle(trafficLightColor == const Color(0xFFFFA500)
                        ? const Color(0xFFFFA500)
                        : Colors.grey[300]!),
                    buildCircle(trafficLightColor == const Color(0xFFFFDB4B)
                        ? const Color(0xFFFFDB4B)
                        : Colors.grey[300]!),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIndexBar(
      String title, String subtitle, double value, String interpretation,
      {bool isFLI = false}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 91,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: subtitle,
                              style: const TextStyle(
                                color: Color(0xFF8E8E8E),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        interpretation,
                        style: const TextStyle(
                          color: Color(0xFF8E8E8E),
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  value.toStringAsFixed(2),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 350,
            height: 9,
            decoration: BoxDecoration(
              color: isFLI ? _getFLIColor(value) : _getFibrosisColor(value),
              borderRadius: const BorderRadius.all(Radius.circular(9 / 2)),
            ),
          ),
        ),
      ],
    );
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

            final fliValue = liverData.indices.fli.value;
            final fibrosisValue = liverData.indices.fibrosis.value;
            final trafficLightColor =
                _getTrafficLightColor(fliValue, fibrosisValue);

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 292),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 110, 20, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 346,
                          height: 49,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24.5),
                              topRight: Radius.circular(24.5),
                              bottomRight: Radius.circular(24.5),
                              bottomLeft: Radius.circular(0),
                            ),
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              children: [
                                const TextSpan(text: '간섬유화 위험도는 '),
                                TextSpan(
                                  text: _getRiskLevelColoredPart(
                                      trafficLightColor),
                                  style: TextStyle(
                                    color: trafficLightColor,
                                  ),
                                ),
                                const TextSpan(text: '입니다.'),
                              ],
                            ),
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
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            _buildIndexBar('지방간 지수', '(FLI)', fliValue,
                                liverData.indices.fli.interpretation,
                                isFLI: true),
                            const SizedBox(height: 12),
                            _buildIndexBar(
                              '섬유화 지수',
                              '(Fibrosis)',
                              fibrosisValue,
                              liverData.indices.fibrosis.interpretation,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          width: 346,
                          height: 49,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '간섬유화 검사는 이런 검사에요.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF333333),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${authController.user.value?.username ?? ""}님의 간섬유화 위험도는',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Text(
                                  '간수치 AST < 30, ALT < 30, GGT < 40이\n될 수 있도록 합니다.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/check_circle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        '중성지방은 150 미만으로 낮추는 것을 권합니다.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/check_circle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        'HDL 콜레스테롤은 60 이상이 되어 심혈관 보호 효과가 있습니다.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/check_circle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        '요산 수치는 7 미만으로 유지하도록 합니다.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/check_circle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        '수축기 혈압은 120 미만으로 유지하는 것이 혈관 보호에도 도움이 됩니다.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/check_circle.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        '이완기 혈압은 80 미만으로 유지하는 것이 혈관 보호에도 도움이 됩니다.',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 295,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 382,
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            _getRiskTitle(trafficLightColor),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '${authController.user.value?.username ?? ""}님의 간섬유화 위험도는',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: _buildTrafficLight(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
