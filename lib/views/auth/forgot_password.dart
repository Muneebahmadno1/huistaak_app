import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/auth/verify_phone.dart';

import '../../constants/global_variables.dart';
import '../../widgets/country_picker_widget.dart';
import '../../widgets/custom_widgets.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  final TextEditingController controller;
  const ForgotPassword({Key? key, required this.controller}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
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
            Get.off(() => LoginScreen(controller: TextEditingController()));
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
                        "Forgot Password?",
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
                      "Enter your mobile number, we will send you code to reset your password.",
                      style: authSubHeading,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 120,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 500),
                slidingBeginOffset: Offset(0, -1),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6),
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
                delay: Duration(milliseconds: 600),
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
                      child: CountryCodePicker()),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 700),
                slidingBeginOffset: Offset(0, 0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                  child: CustomButton(
                    buttonText: "Send Code",
                    onTap: () {
                      // if (!key.currentState!.validate()) {
                      //   return;
                      // }
                      Get.to(() =>
                          VerifyPhone(controller: TextEditingController()));
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
    );
  }
}
