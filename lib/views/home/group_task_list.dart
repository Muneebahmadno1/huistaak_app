import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:huistaak/widgets/like_bar_widget.dart';

import '../../constants/global_variables.dart';
import '../../widgets/custom_widgets.dart';

class GroupTaskList extends StatelessWidget {
  const GroupTaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Group Task List",
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
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Tuesday, 26th Sep, 2023",
                style: bodyNormal.copyWith(color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.buttonColor,
                borderRadius: BorderRadius.circular(20),
              ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
