import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/home/group_task_list.dart';
import 'package:huistaak/widgets/text_form_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../widgets/custom_widgets.dart';

class GroupSetting extends StatelessWidget {
  const GroupSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Edit Group Detail",
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
                      "Group Photo:",
                      style: headingSmall,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 400),
                slidingBeginOffset: Offset(0, 0),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("assets/images/man1.jpg"),
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
                      style: headingSmall,
                    )),
              ),
              SizedBox(
                height: 6,
              ),
              DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: CustomTextField(hintText: "House Hold Task")),
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 600),
                slidingBeginOffset: Offset(0, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ZoomTapAnimation(
                    onTap: () {
                      Get.to(() => GroupTaskList());
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Group Task List",
                                style: bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            )
                          ],
                        )),
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
                      style: headingSmall,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return DelayedDisplay(
                      delay: Duration(milliseconds: 800),
                      slidingBeginOffset: Offset(0, -1),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage("assets/images/man1.jpg"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Cameron Williamson",
                                  style: headingMedium,
                                ),
                                Text(
                                  "1st Group Admin",
                                  style: bodyNormal.copyWith(
                                      color: Colors.black26),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 20,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 900),
                slidingBeginOffset: Offset(0, -1),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Group Members:",
                      style: headingSmall,
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return DelayedDisplay(
                      delay: Duration(milliseconds: 1000),
                      slidingBeginOffset: Offset(0, -1),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 14.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage("assets/images/man1.jpg"),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Cameron Williamson",
                                style: headingMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1100),
                slidingBeginOffset: Offset(0, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: ZoomTapAnimation(
                    onTap: () {
                      _showPopup(context);
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: Divider(
                          thickness: 1.2,
                          color: AppColors.buttonColor,
                        )),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "View more",
                          style: bodyNormal.copyWith(
                              color: AppColors.buttonColor, fontSize: 13),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 1.2,
                          color: AppColors.buttonColor,
                        )),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1200),
                slidingBeginOffset: Offset(0, 0),
                child: ZoomTapAnimation(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Leave this group",
                        style: headingSmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                delay: Duration(milliseconds: 1200),
                slidingBeginOffset: Offset(0, 0),
                child: ZoomTapAnimation(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        "Share Link",
                        style: headingSmall.copyWith(color: Colors.white),
                      ),
                    ),
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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Align(alignment: Alignment.center, child: Text('Group Members')),
          content: SizedBox(
            width: 90.w,
            height: 50.h,
            child: ListView.builder(
              itemCount: 14,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage("assets/images/man1.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Cameron Williamson",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
