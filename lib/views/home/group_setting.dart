import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/home/group_task_list.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../widgets/custom_widgets.dart';

class GroupSetting extends StatefulWidget {
  final groupID;
  const GroupSetting({super.key, required this.groupID});

  @override
  State<GroupSetting> createState() => _GroupSettingState();
}

class _GroupSettingState extends State<GroupSetting> {
  List<Map<String, dynamic>> groupInfo = [];
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    var querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.groupID)
        .get();
    setState(() {
      groupInfo.add({
        "groupImage": querySnapshot['groupImage'],
        "groupName": querySnapshot['groupName'],
        "adminsList": List.from(querySnapshot['adminsList']),
        "membersList": List.from(querySnapshot['membersList']),
      });
    });
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
          pageTitle: "Group Detail",
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
          child: isLoading
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: CircularProgressIndicator(),
                ))
              : Column(
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
                      child: TextFormField(
                        readOnly: true,
                        style: bodyNormal.copyWith(
                            fontFamily: "MontserratSemiBold"),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            hintText: groupInfo[0]['groupName'],
                            hintStyle: bodyNormal.copyWith(
                                color: Colors.black,
                                fontFamily: "MontserratSemiBold"),
                            prefixIconColor: Colors.white,
                            prefixIconConstraints: const BoxConstraints(
                              maxHeight: 30,
                              minHeight: 30,
                            )),
                      ),
                      // CustomTextField(
                      //     hintText: groupInfo[0]['groupName'])
                    ),
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
                            Get.to(() => GroupTaskList(
                                  groupID: widget.groupID,
                                ));
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                        itemCount: groupInfo[0]['adminsList'].length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 16),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, i) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        groupInfo[0]['adminsList'][i]
                                            ['displayName'],
                                        style: headingMedium,
                                      ),
                                      Text(
                                        "Group Admin",
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
                        itemCount: groupInfo[0]['membersList'].length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 16),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, j) {
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
                                      groupInfo[0]['membersList'][j]
                                          ['displayName'],
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
                            // _showPopup(context);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                thickness: 1.2,
                                color: AppColors.buttonColor,
                              )),
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
