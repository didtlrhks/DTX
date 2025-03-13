import 'package:dtxproject/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/verification_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/liver_controller.dart';
import 'controllers/survey_controller.dart';
import 'services/exercise_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 서비스 초기화
  await initServices();

  runApp(const MyApp());
}

// 서비스 초기화 함수
Future<void> initServices() async {
  // AuthController 초기화
  Get.put(AuthController());
  Get.put(LiverController());
  Get.put(SurveyController());

  // ExerciseService 초기화
  Get.put(ExerciseService());
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
