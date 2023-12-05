import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../controllers/data_controller.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final HomeController _dataController = Get.find<HomeController>();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  bool isLoading = false;
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
            // Get.off(() => LoginScreen());
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: Form(
        key: key,
        child: SizedBox(
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
                          "Forgot Password?",
                          style: headingLarge.copyWith(
                              color: AppColors.buttonColor),
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
                        "Enter your Email, we will send you link to reset your password.",
                        style: authSubHeading,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 700),
                    slidingBeginOffset: Offset(0, -1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email address:",
                          style: bodyNormal.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontFamily: "MontserratSemiBold"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DelayedDisplay(
                          delay: Duration(milliseconds: 600),
                          slidingBeginOffset: Offset(0, 0),
                          child: AuthTextField(
                            controller: emailEditingController,
                            validator: (value) => CustomValidator.email(value),
                            hintText: "Email Address",
                            prefixIcon: AppImages.emailIcon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 700),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8),
                    child: CustomButton(
                      buttonText: "Send link to reset Password",
                      onTap: () async {
                        if (key.currentState!.validate()) {
                          Get.defaultDialog(
                              barrierDismissible: false,
                              title: "Huistaak",
                              titleStyle: const TextStyle(
                                color: AppColors.buttonColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                              middleText: "",
                              content: const Column(
                                children: [
                                  Center(
                                      child: CircularProgressIndicator(
                                    color: AppColors.buttonColor,
                                  ))
                                ],
                              ));

                          await resetPassword(
                              email: emailEditingController.text);
                        }
                      },
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
      ),
    );
  }

  Future resetPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.back();
      successPopUp(context, const LoginScreen(),
          'An email has been sent to your email address with instructions to reset password.');
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        errorPopUp(
          context,
          "There is no record of this email",
        );
      }
    }
  }
}
