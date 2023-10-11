import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/auth/welcome_screen.dart';
import 'package:huistaak/views/home/bottom_nav_bar.dart';

import '../constants/app_images.dart';
import 'helper/page_navigation.dart';
import 'models/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late bool login;
  getData() async {
    // Future.delayed(const Duration(milliseconds: 10000), () {
    //   PageTransition.pageProperNavigation(page: const EmojiRatingApp());
    // });

    login = await getUserLoggedIn();
    if (login == true) {
      var userid = await getUserData();
      userDocId.value = userid.toString();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDocId.value)
          .get()
          .then((value) async {
        setState(() {
          userData = UserModel.fromDocument(value.data());
        });
      });
      Future.delayed(const Duration(milliseconds: 5000), () {
        PageTransition.pageProperNavigation(page: CustomBottomNavBar());
      });
    } else {
      Future.delayed(const Duration(milliseconds: 5000), () {
        PageTransition.pageProperNavigation(page: const WelcomeScreen());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
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
