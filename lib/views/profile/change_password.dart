import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../helper/data_helper.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  final DataHelper _dataController = Get.find<DataHelper>();
  final TextEditingController passwordEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordEditingController =
      TextEditingController();
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
          pageTitle: "Change Password",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.buttonColor,
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
            child: SizedBox(
              height: 88.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: DelayedDisplay(
                      delay: Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0, -1),
                      child: Text(
                        "Create a new Password for your account",
                        style: headingMedium.copyWith(color: Colors.black54),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 6),
                    child: DelayedDisplay(
                      delay: Duration(milliseconds: 400),
                      slidingBeginOffset: Offset(0, -1),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Current Password",
                          style: headingSmall.copyWith(
                              color: AppColors.buttonColor),
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 500),
                    slidingBeginOffset: Offset(0, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AuthTextField(
                        controller: passwordEditingController,
                        validator: (value) => CustomValidator.password(value),
                        hintText: "Current Password",
                        isObscure: _obscureText,
                        prefixIcon: AppImages.lockIcon,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
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
                  const SizedBox(
                    height: 20,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 600),
                    slidingBeginOffset: Offset(0, -1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "New Password",
                          style: headingSmall.copyWith(
                              color: AppColors.buttonColor),
                        ),
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 700),
                    slidingBeginOffset: Offset(0, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: AuthTextField(
                        controller: confirmPasswordEditingController,
                        validator: (value) => CustomValidator.password(value),
                        hintText: "New Password",
                        isObscure: _obscureTextConfirm,
                        prefixIcon: AppImages.lockIcon,
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _obscureTextConfirm = !_obscureTextConfirm;
                            });
                          },
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
                  const SizedBox(
                    height: 120,
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 800),
                    slidingBeginOffset: Offset(0, 0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 8),
                      child: CustomButton(
                        buttonText: "Change Changes",
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
                            _dataController.changePassword(
                                context,
                                passwordEditingController.text,
                                confirmPasswordEditingController.text);
                          }
                          ;
                          setState(() {});
                          // Get.offAll(() => CustomBottomNavBar());
                        },
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
      ),
    );
  }
}
