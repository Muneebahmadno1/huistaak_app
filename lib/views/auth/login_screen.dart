import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/auth/signup_screen.dart';
import 'package:huistaak/views/auth/welcome_screen.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';
import '../home/bottom_nav_bar.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  final TextEditingController controller;

  const LoginScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "",
          onTap: () {
            Get.off(() => WelcomeScreen());
          },
          leadingButton: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 300),
                slidingBeginOffset: Offset(0, -1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      child: Text(
                        "Welcome Back , Leslie",
                        style: headingLarge,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 400),
                slidingBeginOffset: Offset(0, -1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Log in to your account",
                      style: authSubHeading,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Form(
                key: key,
                child: Column(
                  children: [
                    DelayedDisplay(
                      delay: Duration(milliseconds: 500),
                      slidingBeginOffset: Offset(0, -1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Email Address",
                            style: headingSmall,
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0, 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: AuthTextField(
                          validator: (value) => CustomValidator.email(value),
                          hintText: "Email Address",
                          prefixIcon: AppImages.emailIcon,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 700),
                      slidingBeginOffset: Offset(0, -1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 6),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password",
                            style: headingSmall,
                          ),
                        ),
                      ),
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 800),
                      slidingBeginOffset: Offset(0, 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: AuthTextField(
                          validator: (value) => CustomValidator.password(value),
                          hintText: "Password",
                          isObscure: _obscureText,
                          prefixIcon: AppImages.lockIcon,
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 22.0),
                              child: Icon(
                                !_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 900),
                slidingBeginOffset: Offset(0, -1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => ForgotPassword(
                            controller: TextEditingController()));
                      },
                      child: Text(
                        "Forgot Password?",
                        style:
                            headingSmall.copyWith(color: AppColors.buttonColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                slidingBeginOffset: Offset(0, 0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                  child: CustomButton(
                    buttonText: "Log In",
                    onTap: () {
                      Get.off(() => CustomBottomNavBar());
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1100),
                slidingBeginOffset: Offset(0, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 1.2,
                        color: Colors.black38,
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "or continue with",
                        style: bodySmall.copyWith(
                            color: Colors.black54,
                            fontFamily: "MontserratSemiBold",
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 1.2,
                        color: Colors.black38,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1200),
                slidingBeginOffset: Offset(0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12, width: 1.4),
                      ),
                      child: Center(
                        child: SizedBox(
                            height: 30,
                            child: Image.asset(AppImages.facebookIcon)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 56,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12, width: 1.4),
                      ),
                      child: Center(
                        child: SizedBox(
                            height: 30,
                            child: Image.asset(AppImages.googleIcon)),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 56,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black12, width: 1.4),
                      ),
                      child: Center(
                        child: SizedBox(
                            height: 30,
                            child: Image.asset(AppImages.appleIcon)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1300),
                slidingBeginOffset: Offset(0, -1),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: bodyNormal.copyWith(color: Colors.black54),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Get.off(() => SignUpScreen(
                                controller: TextEditingController(),
                              ));
                        },
                        child: Text(
                          "Sign up",
                          style: bodyLarge.copyWith(
                              fontFamily: "MontserratSemiBold",
                              color: AppColors.buttonColor,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
