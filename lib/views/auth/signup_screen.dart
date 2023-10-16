import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/widgets/country_picker_widget.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../helper/data_helper.dart';
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
  final DataHelper _dataController = Get.find<DataHelper>();
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();
  final TextEditingController phoneEditingController = TextEditingController();
  final TextEditingController postalCodeEditingController =
      TextEditingController();
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
                        "Create your account to get started",
                        style: authSubHeading,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
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
                      controller: emailEditingController,
                      validator: (value) => CustomValidator.email(value),
                      hintText: "Email Address",
                      prefixIcon: AppImages.emailIcon,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                DelayedDisplay(
                  delay: Duration(milliseconds: 900),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number (Household Member)",
                        style: headingSmall,
                      ),
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent,
                            border: Border.all(color: Colors.black26)),
                        child: CountryCodePicker(
                            controller: phoneEditingController)),
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
                        style: headingSmall,
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
                      controller: postalCodeEditingController,
                      validator: (value) => CustomValidator.isEmpty(value),
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
                        style: headingSmall,
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
                        style: headingSmall,
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
                            "imageUrl": "",
                            "phoneNumber":
                                phoneEditingController.text.toString(),
                            "postalCode":
                                postalCodeEditingController.text.toString(),
                          };
                          await _dataController.registerUser(
                              context,
                              emailEditingController.text.removeAllWhitespace
                                  .toLowerCase(),
                              passwordEditingController.text,
                              map);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1800),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontSize: 12,
                            fontFamily: "MontserratSemiBold",
                          ),
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
                  delay: Duration(milliseconds: 1900),
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
                  height: 20,
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
