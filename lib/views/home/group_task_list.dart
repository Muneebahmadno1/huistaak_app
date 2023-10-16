import 'package:avatar_stack/avatar_stack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:huistaak/widgets/like_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';
import '../../widgets/custom_widgets.dart';

class GroupTaskList extends StatefulWidget {
  final groupID;
  const GroupTaskList({super.key, required this.groupID});

  @override
  State<GroupTaskList> createState() => _GroupTaskListState();
}

class _GroupTaskListState extends State<GroupTaskList> {
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
                                          data: DateFormat('yyyy-MM-dd').format(
                                              taskList[index]['taskDate']
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
                                          icon: "assets/icons/home/points.png",
                                          title: "Task Score Points",
                                          data: taskList[index]['taskScore']),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Task assigned to:",
                                            style: headingSmall.copyWith(
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 74,
                                            child: AvatarStack(
                                              height: 34,
                                              avatars: [
                                                for (var n = 0;
                                                    n <
                                                        taskList[0][
                                                                'assignMembers']
                                                            .length;
                                                    n++)
                                                  AssetImage(
                                                      "assets/images/man1.jpg"),
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
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
