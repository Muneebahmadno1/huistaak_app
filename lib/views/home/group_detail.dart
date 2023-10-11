import 'package:avatar_stack/avatar_stack.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_setting.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:huistaak/widgets/like_bar_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import 'group/create_new_group.dart';

class GroupDetail extends StatelessWidget {
  const GroupDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DelayedDisplay(
              delay: Duration(milliseconds: 300),
              slidingBeginOffset: Offset(0, -1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      ZoomTapAnimation(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
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
                              "You, James, Robert, Lucy",
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
                      Get.to(() => GroupSetting());
                    },
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/icons/home/setting.png")),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 400),
              slidingBeginOffset: Offset(0, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Today's Task",
                  style: bodyNormal.copyWith(color: Colors.black54),
                ),
              ),
            ),
            SizedBox(
              height: 6,
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
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, -1),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Update Mom’s Room Furniture",
                          style: headingLarge.copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TaskDetailWidget(
                          icon: "assets/icons/home/date.png",
                          title: "Date",
                          data: "Tuesday, 26th Sep, 2023"),
                      SizedBox(
                        height: 10,
                      ),
                      TaskDetailWidget(
                          icon: "assets/icons/home/time.png",
                          title: "Time",
                          data: "10 am to 05 pm"),
                      SizedBox(
                        height: 10,
                      ),
                      TaskDetailWidget(
                          icon: "assets/icons/home/duration.png",
                          title: "Task Duration",
                          data: "08 hours"),
                      SizedBox(
                        height: 10,
                      ),
                      TaskDetailWidget(
                          icon: "assets/icons/home/points.png",
                          title: "Task Score Points",
                          data: "15"),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Task assigned to:",
                            style: headingSmall.copyWith(color: Colors.white),
                          ),
                          SizedBox(
                            width: 74,
                            child: AvatarStack(
                              height: 34,
                              avatars: [
                                for (var n = 0; n < 3; n++)
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
                        height: 10,
                      ),
                      LikeBarWidget(
                          image: "assets/images/man1.jpg",
                          count: "10/15",
                          percent: 0.8),
                      SizedBox(
                        height: 10,
                      ),
                      LikeBarWidget(
                          image: "assets/images/man1.jpg",
                          count: "3/15",
                          percent: 0.3),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Get.to(() => CreateNewGroup());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
