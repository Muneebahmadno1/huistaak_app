import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/auth/welcome_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final TextEditingController controller;

  const SignUpScreen({Key? key, required this.controller}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();
  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController postalCodeEditingController =
      TextEditingController();
  bool imageLoading = false;
  final GlobalKey<FormState> signInFormField = GlobalKey();

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
      body: Form(
        key: signInFormField,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 300),
                    slidingBeginOffset: Offset(0, -1),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          "Setup New Profile",
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
                        "Create your account to get started",
                        style: authSubHeading,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: imageLoading
                          ? Center(child: CircularProgressIndicator())
                          : ClipOval(
                              child: Container(
                              height: 60 * 2,
                              width: 60 * 2,
                              color: Colors.grey,
                              child: _authController.imageFile != null
                                  ? Image.file(_authController.imageFile!)
                                  : Image.asset(
                                      AppImages.groupIcon,
                                      fit: BoxFit.fitHeight,
                                    ),
                            )),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: ZoomTapAnimation(
                        onTap: () async {
                          setState(() {
                            imageLoading = true;
                          });
                          await _authController.upload("gallery");
                          setState(() {
                            imageLoading = false;
                          });
                        },
                        onLongTap: () {},
                        enableLongTapRepeatEvent: false,
                        longTapRepeatDuration:
                            const Duration(milliseconds: 100),
                        begin: 1.0,
                        end: 0.93,
                        beginDuration: const Duration(milliseconds: 20),
                        endDuration: const Duration(milliseconds: 120),
                        beginCurve: Curves.decelerate,
                        endCurve: Curves.fastOutSlowIn,
                        child: CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.buttonColor,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 10.h,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _authController.localDp.length,
                      itemBuilder: (context, a) {
                        return InkWell(
                          onTap: () async {
                            setState(() {
                              imageLoading = true;
                            });
                            await _authController.upload(
                                _authController.localDp[a].toString(),
                                name: a.toString() + "dp",
                                fromLocal: true);
                            setState(() {
                              imageLoading = false;
                            });
                          },
                          child: SizedBox(
                            height: 10.h,
                            width: 20.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      // Adjust the radius as needed
                                      backgroundColor: Colors.grey,
                                      // You can set a default background color
                                      child: ClipOval(
                                        child: SizedBox(
                                            height: 30 * 2,
                                            width: 30 * 2,
                                            child: Image.asset(
                                              _authController.localDp[a],
                                              // Replace with your asset image path
                                              fit: BoxFit.fitHeight,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                // _dataController.assignTaskMember.any((person) =>
                                //         person.userID ==
                                //         _dataController.userList[a].userID)
                                //     ? Positioned(
                                //         right: 2,
                                //         bottom: 20,
                                //         child: Image.asset(
                                //           "assets/images/added.png",
                                //           height: 20,
                                //         ),
                                //       )
                                //     : Positioned(
                                //         right: 2,
                                //         bottom: 20,
                                //         child: Image.asset(
                                //           "assets/images/addNow.png",
                                //           height: 20,
                                //         ),
                                //       )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Full Name",
                        style: bodyNormal.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MontserratSemiBold"),
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
                      controller: nameEditingController,
                      validator: (value) =>
                          CustomValidator.isEmptyUserName(value),
                      hintText: "Full Name",
                      prefixIcon: AppImages.personIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                DelayedDisplay(
                  delay: Duration(milliseconds: 700),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Address",
                        style: bodyNormal.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MontserratSemiBold"),
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
                      controller: emailEditingController,
                      validator: (value) => CustomValidator.email(value),
                      hintText: "Email Address",
                      prefixIcon: AppImages.emailIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1100),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Postal Code Of House",
                        style: bodyNormal.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MontserratSemiBold"),
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1200),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AuthTextField(
                      isNumber: true,
                      controller: postalCodeEditingController,
                      validator: (value) => CustomValidator.postalCode(value),
                      hintText: "Postal Code",
                      prefixIcon: AppImages.mapIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1300),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: bodyNormal.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MontserratSemiBold"),
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1400),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AuthTextField(
                      controller: passwordEditingController,
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
                const SizedBox(height: 15),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Confirm Password",
                        style: bodyNormal.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontFamily: "MontserratSemiBold"),
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1600),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: AuthTextField(
                      controller: confirmPasswordEditingController,
                      validator: (value) => CustomValidator.confirmPassword(
                          value, passwordEditingController.text),
                      hintText: "Confirm Password",
                      isObscure: _obscureTextConfirm,
                      prefixIcon: AppImages.lockIcon,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _obscureTextConfirm = !_obscureTextConfirm;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 22.0),
                          child: Icon(
                            !_obscureTextConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1700),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8),
                    child: CustomButton(
                      buttonText: "Sign Up",
                      onTap: () async {
                        if (_authController.imageUrl != null) {
                          if (signInFormField.currentState!.validate()) {
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
                            Map<String, String> map = {
                              "displayName":
                                  nameEditingController.text.toString(),
                              "email": emailEditingController.text.toString(),
                              "password":
                                  passwordEditingController.text.toString(),
                              "imageUrl": _authController.imageUrl.toString(),
                              "postalCode":
                                  postalCodeEditingController.text.toString(),
                            };
                            await _authController.registerUser(
                                context,
                                emailEditingController.text.removeAllWhitespace
                                    .toLowerCase(),
                                passwordEditingController.text,
                                map);
                          }
                        } else {
                          errorPopUp(context, "Profile image is required");
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 2000),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: bodyNormal.copyWith(color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Get.off(() => LoginScreen());
                          },
                          child: Text(
                            "Sign In",
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
      ),
    );
  }
}
