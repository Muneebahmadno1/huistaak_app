import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/bottom_nav_bar.dart';
import 'package:huistaak/widgets/country_picker_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      fieldHintText: "DD/MM/YYYY",
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Edit Profile",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 400),
                slidingBeginOffset: Offset(0, 0),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.buttonColor,
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage(AppImages.profileImage),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: ZoomTapAnimation(
                        onTap: () {},
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
              ),
              SizedBox(
                height: 30,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 500),
                slidingBeginOffset: Offset(0, -1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Full Name:",
                      style: bodyNormal.copyWith(
                          color: Colors.black87,
                          fontFamily: "MontserratSemiBold"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      validator: (value) =>
                          CustomValidator.isEmptyUserName(value),
                      hintText: "Robert Fox",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DelayedDisplay(
                delay: Duration(milliseconds: 700),
                slidingBeginOffset: Offset(0, -1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email address:",
                      style: bodyNormal.copyWith(
                          color: Colors.black87,
                          fontFamily: "MontserratSemiBold"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      validator: (value) => CustomValidator.email(value),
                      hintText: "robert123@gmail.com",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DelayedDisplay(
                delay: Duration(milliseconds: 700),
                slidingBeginOffset: Offset(0, -1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Phone Number:",
                      style: bodyNormal.copyWith(
                          color: Colors.black87,
                          fontFamily: "MontserratSemiBold"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                              color: AppColors.buttonColor, width: 0.7)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 26.0, right: 12),
                        child: CountryCodePicker(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              DelayedDisplay(
                delay: Duration(milliseconds: 700),
                slidingBeginOffset: Offset(0, -1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Postal Code of House:",
                      style: bodyNormal.copyWith(
                          color: Colors.black87,
                          fontFamily: "MontserratSemiBold"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextField(
                      validator: (value) => CustomValidator.email(value),
                      hintText: "Postal Code",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                slidingBeginOffset: Offset(0, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: CustomButton(
                    buttonText: "Save Changes",
                    onTap: () {
                      Get.offAll(() => CustomBottomNavBar());
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
