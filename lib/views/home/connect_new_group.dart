import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import '../../widgets/text_form_fields.dart';
import '../notification/notifications.dart';
import 'group/create_new_group.dart';

class ConnectNewGroup extends StatelessWidget {
  const ConnectNewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
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
                      Text(
                        userData.displayName,
                        style: headingMedium,
                      ),
                    ],
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      Get.to(() => Notifications());
                    },
                    child: SizedBox(
                      width: 22,
                      child: Stack(
                        children: [
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                  "assets/icons/home/notification.png")),
                          Positioned(
                            right: 1,
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 130,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Connect Group",
                  style: headingLarge,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "You have to be connected to any group to see activities",
                  style: bodyNormal,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Join Group",
                  style: headingSmall,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              AuthTextField(
                hintText: "Enter Group Code",
                prefixIcon: "assets/icons/home/add_group.png",
              ),
              SizedBox(
                height: 6,
              ),
              SizedBox(
                height: 20,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 600),
                slidingBeginOffset: Offset(0, 0),
                child: ZoomTapAnimation(
                  onTap: () {
                    // Get.to(() => CreateNewGroupTask());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Join Now",
                          style: headingSmall.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
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
                    Get.to(() => CreateNewGroup());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Create Group",
                          style: headingSmall.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
