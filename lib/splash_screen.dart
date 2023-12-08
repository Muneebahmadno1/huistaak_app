import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/auth/welcome_screen.dart';
import 'package:huistaak/views/home/bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

import '../constants/app_images.dart';
import 'helper/collections.dart';
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
      await Collections.USERS.doc(userDocId.value).get().then((value) async {
        setState(() {
          userData = UserModel.fromDocument(value.data());
        });
      });

      Future.delayed(const Duration(milliseconds: 3000), () {
        PageTransition.pageProperNavigation(page: CustomBottomNavBar());
      });
    } else {
      Future.delayed(const Duration(milliseconds: 3000), () {
        PageTransition.pageProperNavigation(page: const WelcomeScreen());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getFCM();
  }

  getFCM() async {
    await FirebaseMessaging.instance.getToken().then((value) {
      fcmToken.value = value!;
    });
    login
        ? await Collections.USERS
            .doc(userDocId.value)
            .update({"fcmToken": fcmToken.value})
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.buttonColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Container(
                width: 90.w,
                height: 35.w,
                child: Image.asset(
                  AppImages.logo,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            SpinKitFadingCircle(
              color: Colors.white,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
