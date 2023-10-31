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

import '../../helper/data_helper.dart';

class NewGoalsScreen extends StatefulWidget {
  const NewGoalsScreen({super.key});

  @override
  State<NewGoalsScreen> createState() => _NewGoalsScreenState();
}

class _NewGoalsScreenState extends State<NewGoalsScreen> {
  final DataHelper _dataController = Get.find<DataHelper>();
  bool isLoading = false;
  List<dynamic> groupList = [];
  List<dynamic> groupWithUserList = [];
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
    QuerySnapshot querySnapshot2 =
        await FirebaseFirestore.instance.collection('groups').get();
    for (QueryDocumentSnapshot documentSnapshot1 in querySnapshot2.docs) {
      Map<String, dynamic> groupsData =
          documentSnapshot1.data() as Map<String, dynamic>;
      List<dynamic> mamberArray = groupsData['membersList'];
      for (var userMap in mamberArray)
        if (userMap['userID'] == userData.userID) {
          setState(() {
            groupWithUserList.add({
              "groupID": groupsData['groupID'],
              "groupImage": groupsData['groupImage'],
              "groupName": groupsData['groupName'],
              "id": documentSnapshot1.id,
            });
          });
        }
    }

    for (int i = 0; i < groupWithUserList.length; i++) {
      QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupWithUserList[i]['groupID'])
          .collection("Goals")
          .get();
      for (int i = 0; i < querySnapshot1.docs.length; i++) {
        var a = querySnapshot1.docs[i].data() as Map;
        setState(() {
          goalList.add({
            "goalTitle": a['goalTitle'],
            "goalDate": a['goalDate'],
            "goalTime": a['goalTime'],
            "goalID": a['goalID'],
          });
        });
      }
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
                      buttonText: "Set Goal for your Group",
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
