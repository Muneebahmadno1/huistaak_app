import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';

class ResentVerification extends StatefulWidget {
  const ResentVerification({Key? key}) : super(key: key);

  @override
  State<ResentVerification> createState() => _ResentVerificationState();
}

class _ResentVerificationState extends State<ResentVerification> {
  final AuthController _authController = Get.find<AuthController>();
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
                          "Resend Verification Email",
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
                        "Enter your Email, we will send you link to verify your Email.",
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
                          setState(() {
                            isLoading = true;
                          });
                          await _authController
                              .reSendVerificationEmail(context);
                          setState(() {
                            isLoading = false;
                          });
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
}
