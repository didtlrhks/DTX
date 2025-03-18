import 'package:dtxproject/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/verification_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/liver_controller.dart';
import 'controllers/survey_controller.dart';
import 'controllers/lunch_controller.dart';
import 'services/exercise_service.dart';
import 'services/lunch_service.dart';
import 'services/breakfast_service.dart';
import 'controllers/breakfast_controller.dart';
import 'services/dinner_service.dart';
import 'controllers/dinner_controller.dart';
import 'services/snack_service.dart';
import 'controllers/snack_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 서비스 초기화
  await initServices();

  runApp(const MyApp());
}

// 서비스 초기화 함수
Future<void> initServices() async {
  // 컨트롤러 초기화
  Get.put(AuthController());
  Get.put(LiverController());
  Get.put(SurveyController());

  // 서비스 초기화
  final exerciseService = Get.put(ExerciseService());
  final lunchService = Get.put(LunchService());
  final breakfastService = Get.put(BreakfastService());
  final dinnerService = Get.put(DinnerService());
  final snackService = Get.put(SnackService());

  // 컨트롤러 초기화 (서비스 의존성 주입)
  Get.put(LunchController(lunchService: lunchService));
  Get.put(BreakfastController(breakfastService: breakfastService));
  Get.put(DinnerController(dinnerService: dinnerService));
  Get.put(SnackController(snackService: snackService));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DTX Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const OnboardingPage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈 페이지'),
      ),
      body: const Center(
        child: Text('홈 페이지입니다'),
      ),
    );
  }
}
