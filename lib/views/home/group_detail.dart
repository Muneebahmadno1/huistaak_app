import 'package:avatar_stack/avatar_stack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_setting.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:huistaak/widgets/like_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import 'group/create_new_group_task.dart';

class GroupDetail extends StatefulWidget {
  final String groupID;
  final String groupTitle;

  const GroupDetail(
      {super.key, required this.groupID, required this.groupTitle});

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  List<Map<String, dynamic>> taskList = [];
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .collection("tasks")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      setState(() {
        taskList.add({
          "taskTitle": a['taskTitle'],
          "taskScore": a['taskScore'],
          "taskDate": a['taskDate'],
          "startTime": a['startTime'],
          "endTime": a['endTime'],
          "assignMembers": List.from(a['assignMembers']),
          "id": a['id'],
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

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
        child: SingleChildScrollView(
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
                              widget.groupTitle,
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
                        Get.to(() => GroupSetting(
                              groupID: widget.groupID,
                            ));
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
              isLoading
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: 25.h),
                      child: CircularProgressIndicator(),
                    ))
                  : taskList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 25.h),
                            child: Container(
                              child: Text("No tasks for now"),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: taskList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: DelayedDisplay(
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
                                            taskList[index]['taskTitle'],
                                            style: headingLarge.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TaskDetailWidget(
                                            icon: "assets/icons/home/date.png",
                                            title: "Date",
                                            data: DateFormat('yyyy-MM-dd')
                                                .format(taskList[index]
                                                        ['taskDate']
                                                    .toDate())),
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
                                            icon:
                                                "assets/icons/home/duration.png",
                                            title: "Task Duration",
                                            data: "08 hours"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TaskDetailWidget(
                                            icon:
                                                "assets/icons/home/points.png",
                                            title: "Task Score Points",
                                            data: taskList[index]['taskScore']),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            taskList[index]['assignMembers']
                                                        .length >
                                                    0
                                                ? Text(
                                                    "Task assigned to:",
                                                    style:
                                                        headingSmall.copyWith(
                                                            color:
                                                                Colors.white),
                                                  )
                                                : SizedBox.shrink(),
                                            taskList[index]['assignMembers']
                                                        .length >
                                                    0
                                                ? SizedBox(
                                                    width: 74,
                                                    child: AvatarStack(
                                                      height: 34,
                                                      avatars: [
                                                        for (var n = 0;
                                                            n <
                                                                taskList[index][
                                                                        'assignMembers']
                                                                    .length;
                                                            n++)
                                                          AssetImage(
                                                              "assets/images/man1.jpg"),
                                                      ],
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                        for (var n = 0;
                                            n <
                                                taskList[index]['assignMembers']
                                                    .length;
                                            n++)
                                          LikeBarWidget(
                                              image: "assets/images/man1.jpg",
                                              count: "5/15",
                                              percent: 0.6),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: ZoomTapAnimation(
                                                  onTap: () {},
                                                  onLongTap: () {},
                                                  enableLongTapRepeatEvent:
                                                      false,
                                                  longTapRepeatDuration:
                                                      const Duration(
                                                          milliseconds: 100),
                                                  begin: 1.0,
                                                  end: 0.93,
                                                  beginDuration: const Duration(
                                                      milliseconds: 20),
                                                  endDuration: const Duration(
                                                      milliseconds: 120),
                                                  beginCurve: Curves.decelerate,
                                                  endCurve:
                                                      Curves.fastOutSlowIn,
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Center(
                                                        child: Text("Start",
                                                            style: bodyLarge.copyWith(
                                                                color: AppColors
                                                                    .buttonColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
                                                child: ZoomTapAnimation(
                                                  onTap: () {},
                                                  onLongTap: () {},
                                                  enableLongTapRepeatEvent:
                                                      false,
                                                  longTapRepeatDuration:
                                                      const Duration(
                                                          milliseconds: 100),
                                                  begin: 1.0,
                                                  end: 0.93,
                                                  beginDuration: const Duration(
                                                      milliseconds: 20),
                                                  endDuration: const Duration(
                                                      milliseconds: 120),
                                                  beginCurve: Curves.decelerate,
                                                  endCurve:
                                                      Curves.fastOutSlowIn,
                                                  child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20),
                                                      width: double.infinity,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      child: Center(
                                                        child: Text("Finish",
                                                            style: bodyLarge.copyWith(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
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
                            );
                          },
                        ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Get.to(() => CreateNewGroupTask(
                groupID: widget.groupID,
                groupTitle: widget.groupTitle,
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
