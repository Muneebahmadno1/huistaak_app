import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group/add_member.dart';
import 'package:huistaak/views/home/group/create_new_group_task.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../constants/app_images.dart';
import '../../../constants/custom_validators.dart';
import '../../../constants/global_variables.dart';
import '../../../widgets/custom_widgets.dart';
import '../../../widgets/text_form_fields.dart';

class CreateNewGroup extends StatelessWidget {
  const CreateNewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Create New Group",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 300),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Group Admins:",
                    style: headingSmall,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 400),
              slidingBeginOffset: Offset(0, 0),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 59,
                    backgroundColor: AppColors.buttonColor,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 58,
                      child: SizedBox(
                        height: 80,
                        child: Image.asset(
                          AppImages.personIcon,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 10,
                    child: ZoomTapAnimation(
                      onTap: () {},
                      onLongTap: () {},
                      enableLongTapRepeatEvent: false,
                      longTapRepeatDuration: const Duration(milliseconds: 100),
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
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 500),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Group Name:",
                  style: bodyNormal.copyWith(
                      color: Colors.black87, fontFamily: "MontserratSemiBold"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 600),
              slidingBeginOffset: Offset(0, 0),
              child: CustomTextField(
                validator: (value) => CustomValidator.isEmptyUserName(value),
                hintText: "My daily home tasks",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 600),
              slidingBeginOffset: Offset(0, 0),
              child: ZoomTapAnimation(
                onTap: () {
                  Get.to(() => CreateNewGroupTask());
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(40)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Tasks",
                        style: headingSmall.copyWith(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 700),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Group Admins:",
                  style: bodyNormal.copyWith(
                      color: Colors.black87, fontFamily: "MontserratSemiBold"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 800),
              slidingBeginOffset: Offset(0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage("assets/images/man1.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Leslie Alexander",
                            style: headingMedium,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              "Group Admin",
                              style: bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      Get.to(() => AddMember());
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/dotted_border.png"))),
                        child: Icon(
                          Icons.add,
                          color: AppColors.buttonColor,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 900),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Add Group Members:",
                  style: bodyNormal.copyWith(
                      color: Colors.black87, fontFamily: "MontserratSemiBold"),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
