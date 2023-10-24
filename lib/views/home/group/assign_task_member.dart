import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/widgets/add_members_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/data_helper.dart';
import '../../../widgets/custom_widgets.dart';

class AssignMember extends StatefulWidget {
  final String from;
  final groupID;

  const AssignMember({super.key, required this.from, required this.groupID});

  @override
  State<AssignMember> createState() => _AssignMemberState();
}

class _AssignMemberState extends State<AssignMember> {
  List<int> selectedIndex = [];
  final DataHelper _dataController = Get.find<DataHelper>();

  List<Map<String, dynamic>> userList = [];
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
      userList.add({
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
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: CustomAppBar(
          pageTitle: "Add Member",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            isLoading
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: CircularProgressIndicator(),
                  ))
                : userList[0]['membersList'].isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 25.h),
                          child: Container(
                            child: Text("No member Available"),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            itemCount: userList[0]['membersList'].length,
                            itemBuilder: (c, i) {
                              return InkWell(
                                onTap: () {
                                  if (selectedIndex.contains(i) &&
                                      (widget.from == "groupTask"
                                          ? _dataController.assignTaskMember
                                              .any((map) =>
                                                  map['userID'] ==
                                                  userList[0]['membersList'][i]
                                                      ['userID'])
                                          : _dataController.assignGoalMember
                                              .any((map) =>
                                                  map['userID'] ==
                                                  userList[0]['membersList'][i]
                                                      ['userID']))) {
                                    selectedIndex.remove(i);
                                    widget.from == "groupTask"
                                        ? _dataController.assignTaskMember
                                            .removeWhere((map) =>
                                                map['userID'] ==
                                                userList[0]['membersList'][i]
                                                    ['userID'])
                                        : _dataController.assignGoalMember
                                            .removeWhere((map) =>
                                                map['userID'] ==
                                                userList[0]['membersList'][i]
                                                    ['userID']);
                                  } else {
                                    selectedIndex.add(i);
                                    widget.from == "groupTask"
                                        ? _dataController.assignTaskMember.add({
                                            'userID': userList[0]['membersList']
                                                [i]['userID'],
                                            'displayName': userList[0]
                                                    ['membersList'][i]
                                                ['displayName'],
                                            'imageUrl': userList[0]
                                                ['membersList'][i]['imageUrl']
                                          })
                                        : _dataController.assignGoalMember.add({
                                            'userID': userList[0]['membersList']
                                                [i]['userID'],
                                            'displayName': userList[0]
                                                    ['membersList'][i]
                                                ['displayName'],
                                            'imageUrl': userList[0]
                                                ['membersList'][i]['imageUrl']
                                          });
                                  }
                                  setState(() {
                                    print(selectedIndex);
                                    print(widget.from == "groupTask"
                                        ? _dataController.assignTaskMember
                                        : _dataController.assignGoalMember);
                                  });
                                },
                                child: AddMemberWidget(
                                  suffixIcon: "assets/images/man1.jpg",
                                  isActive: selectedIndex.contains(i),
                                  title: userList[0]['membersList'][i]
                                      ['displayName'],
                                ),
                              );
                            }),
                      ),
          ],
        ),
      ),
    );
  }
}
