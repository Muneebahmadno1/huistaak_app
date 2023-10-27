import 'package:avatar_stack/avatar_stack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/goals/create_new_task.dart';
import 'package:huistaak/views/goals/widgets/goal_detail_widget.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../helper/data_helper.dart';
import '../../widgets/like_bar_widget.dart';

class NewGoalsScreen extends StatefulWidget {
  const NewGoalsScreen({super.key});

  @override
  State<NewGoalsScreen> createState() => _NewGoalsScreenState();
}

class _NewGoalsScreenState extends State<NewGoalsScreen> {
  final DataHelper _dataController = Get.find<DataHelper>();
  bool isLoading = false;
  List<dynamic> groupList = [];
  List<Map<String, dynamic>> goalList = [];
  getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userID)
        .collection("myGroups")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      setState(() {
        groupList.add({
          "groupName": a['groupName'],
          "groupImage": a['groupImage'],
          "groupID": a['groupID'],
        });
      });
    }

    QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userID)
        .collection("myGoals")
        .get();
    for (int i = 0; i < querySnapshot1.docs.length; i++) {
      var a = querySnapshot1.docs[i].data() as Map;
      print(a['goalTitle']);
      print(a['goalTitle']);
      setState(() {
        goalList.add({
          "goalTitle": a['goalTitle'],
          "goalDate": a['goalDate'],
          "goalTime": a['goalTime'],
          "endTime": a['endTime'],
          "goalMembers": List.from(a['goalMembers']),
          "goalID": a['goalID'],
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
                  style: headingLarge.copyWith(color: AppColors.buttonColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CircularProgressIndicator(),
                  ))
                : goalList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h),
                          child: Container(
                            child: Text("No goal for now"),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: goalList.length,
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
                                  delay: Duration(milliseconds: 500),
                                  slidingBeginOffset: Offset(0, -1),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: AssetImage(
                                                "assets/images/man1.jpg"),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              goalList[index]['goalTitle'],
                                              style: headingMedium.copyWith(
                                                  color: Colors.white),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GoalDetailWidget(
                                          icon: "assets/icons/home/date.png",
                                          title: "Date",
                                          data: DateFormat('yyyy-MM-dd').format(
                                              goalList[index]['goalDate']
                                                  .toDate())),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "This goal is set for:",
                                            style: headingSmall.copyWith(
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 34,
                                            child: AvatarStack(
                                              height: 34,
                                              avatars: [
                                                for (var n = 0;
                                                    n <
                                                        goalList[0]
                                                                ['goalMembers']
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
                                        count: "10",
                                        percent: 0.8,
                                        TotalCount: "15",
                                      ),
                                      SizedBox(
                                        height: 20,
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
                                                enableLongTapRepeatEvent: false,
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
                                                endCurve: Curves.fastOutSlowIn,
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20),
                                                    width: double.infinity,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
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
                                                enableLongTapRepeatEvent: false,
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
                                                endCurve: Curves.fastOutSlowIn,
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
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Center(
                                                      child: Text("Finish",
                                                          style: bodyLarge
                                                              .copyWith(
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
            Expanded(child: SizedBox()),
            groupList.isNotEmpty
                ? DelayedDisplay(
                    delay: Duration(milliseconds: 600),
                    slidingBeginOffset: Offset(0, 0),
                    child: CustomButton(
                      onTap: () {
                        Get.to(() => CreateNewTask());
                      },
                      buttonText: "Set Goal for your group members",
                    ),
                  )
                : SizedBox.shrink(),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
