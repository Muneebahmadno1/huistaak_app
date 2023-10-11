import 'package:avatar_stack/avatar_stack.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/goals/create_new_task.dart';
import 'package:huistaak/views/goals/widgets/goal_detail_widget.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../widgets/like_bar_widget.dart';

class NewGoalsScreen extends StatelessWidget {
  const NewGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            DelayedDisplay(
              delay: Duration(milliseconds: 300),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "New Goals",
                  style: headingLarge,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 400),
              slidingBeginOffset: Offset(0, 0),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.buttonColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                AssetImage("assets/images/man1.jpg"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Cameron Williamson has set a goal for you",
                              style:
                                  headingMedium.copyWith(color: Colors.white),
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Visit to a zoo",
                          style: headingLarge.copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GoalDetailWidget(
                          icon: "assets/icons/home/date.png",
                          title: "Date",
                          data: "Tuesday, 26th Sep, 2023"),
                      SizedBox(
                        height: 10,
                      ),
                      GoalDetailWidget(
                          icon: "assets/icons/home/time.png",
                          title: "Time",
                          data: "10 am to 05 pm"),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "This goal is set for:",
                            style: headingSmall.copyWith(color: Colors.white),
                          ),
                          SizedBox(
                            width: 34,
                            child: AvatarStack(
                              height: 34,
                              avatars: [
                                for (var n = 0; n < 1; n++)
                                  AssetImage("assets/images/man1.jpg"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      LikeBarWidget(
                          image: "assets/images/man1.jpg",
                          count: "5/15",
                          percent: 0.6),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text("Start",
                                          style: bodyLarge.copyWith(
                                              color: AppColors.buttonColor,
                                              fontWeight: FontWeight.bold)),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text("Finish",
                                          style: bodyLarge.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            DelayedDisplay(
              delay: Duration(milliseconds: 600),
              slidingBeginOffset: Offset(0, 0),
              child: CustomButton(
                onTap: () {
                  Get.to(() => CreateNewTask());
                },
                buttonText: "Set Goal for your group members",
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
