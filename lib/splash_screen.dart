import 'dart:async';

import 'package:flutter/material.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/auth/welcome_screen.dart';

import '../constants/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: Image.asset(AppImages.logo),
        ),
      ),
    );
  }
}
