import 'package:dtxproject/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'auth/verification_page.dart';
import 'controllers/auth_controller.dart';
import 'controllers/liver_controller.dart';
import 'controllers/survey_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthController 초기화
    Get.put(AuthController());
    Get.put(LiverController());
    Get.put(SurveyController());

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
