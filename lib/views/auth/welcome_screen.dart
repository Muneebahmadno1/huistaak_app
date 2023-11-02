import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/auth/signup_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../widgets/custom_widgets.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SizedBox(
          height: 100.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 300,
                    child: DelayedDisplay(
                        delay: Duration(milliseconds: 300),
                        slidingBeginOffset: Offset(0, 0),
                        child: Image.asset(AppImages.welcomeImage)),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  slidingBeginOffset: Offset(0, -1),
                  child: Text(
                    "Organize your daily task with Huistaak",
                    style: headingLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Text(
                    "Our main objective is to manage the household tasks efficiently. From daily tasks to some exceptional working tasks, you can can create group, add members into a group and assign tasks to them, keeping track of each task.",
                    style: authSubHeading.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomButton(
                      buttonText: "Sign Up",
                      onTap: () {
                        Get.to(
                            () => SignUpScreen(
                                controller: TextEditingController()),
                            transition: Transition.rightToLeft);
                      },
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 700),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: ZoomTapAnimation(
                      onTap: () {
                        Get.to(() => LoginScreen(),
                            transition: Transition.rightToLeft);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.buttonColor)),
                          child: Center(
                            child: Text("Log In",
                                style: bodyLarge.copyWith(
                                    color: AppColors.buttonColor,
                                    fontWeight: FontWeight.bold)),
                          )),
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
