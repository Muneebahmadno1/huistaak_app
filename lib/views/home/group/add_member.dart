import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/home/widgets/add_members_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../controllers/data_controller.dart';
import '../../../helper/collections.dart';
import '../../../widgets/custom_widgets.dart';

class AddMember extends StatefulWidget {
  final String from;

  const AddMember({super.key, required this.from});

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  List<int> selectedIndex = [];
  List<dynamic> userList = [];
  List<dynamic> groupList = [];
  List<dynamic> groupMemberList = [];
  final DataController _dataController = Get.find<DataController>();
  late String _dropDownValue;
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await Collections.USERS
        .where("userID", isNotEqualTo: userData.userID.toString())
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      setState(() {
        userList.add({
          "displayName": a['displayName'],
          "imageUrl": a['imageUrl'],
          "userID": a['userID'],
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  getDataGoal() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await Collections.USERS
        .doc(userData.userID)
        .collection(Collections.MYGROUPS)
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
    setState(() {
      if (groupList.isNotEmpty) {
        _dropDownValue = groupList[0]['groupID'];
      } else {
        _dropDownValue = "567guhjk67";
      }
      print("_dropDownValue");
      print(_dropDownValue);
    });
    await groupMembers(_dropDownValue);
    setState(() {
      isLoading = false;
    });
  }

  groupMembers(groupID) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .get();
    setState(() {
      groupMemberList.add({
        "membersList": List.from(querySnapshot['membersList']),
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.from == "groupGoal" ? getDataGoal() : getData();
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
            color: AppColors.buttonColor,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: isLoading
            ? Center(
                child: Padding(
                padding: EdgeInsets.only(top: 25.h),
                child: CircularProgressIndicator(),
              ))
            : Column(
                children: [
                  widget.from == "groupGoal" && groupList.isNotEmpty
                      ? DropdownButton(
                          hint: Text(
                            _dropDownValue,
                            style: TextStyle(color: Colors.blue),
                          ),
                          value: _dropDownValue,
                          isExpanded: true,
                          iconSize: 30.0,
                          style: TextStyle(color: Colors.blue),
                          items: groupList.map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val['groupID'],
                                child: Text(val['groupName']),
                              );
                            },
                          ).toList(),
                          onChanged: (val) async {
                            setState(
                              () {
                                _dropDownValue = val!;
                                print(val);
                                print(_dropDownValue);
                              },
                            );
                            setState(() {
                              isLoading = true;
                            });
                            await groupMembers(_dropDownValue);
                            setState(() {
                              isLoading = false;
                            });
                          },
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 10,
                  ),
                  widget.from != "groupGoal"
                      ? userList.isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 25.h),
                                child: Container(
                                  child: Text("No User Available"),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount: userList.length,
                                  itemBuilder: (c, i) {
                                    return InkWell(
                                      onTap: () {
                                        if (selectedIndex.contains(i) &&
                                            (widget.from == "member"
                                                ? _dataController.groupMembers
                                                    .any((map) =>
                                                        map['userID'] ==
                                                        userList[i]['userID'])
                                                : _dataController.groupAdmins
                                                    .any((map) =>
                                                        map['userID'] ==
                                                        userList[i]
                                                            ['userID']))) {
                                          selectedIndex.remove(i);
                                          widget.from == "member"
                                              ? _dataController.groupMembers
                                                  .removeWhere((map) =>
                                                      map['userID'] ==
                                                      userList[i]['userID'])
                                              : _dataController.groupAdmins
                                                  .removeWhere((map) =>
                                                      map['userID'] ==
                                                      userList[i]['userID']);
                                        } else {
                                          selectedIndex.add(i);
                                          widget.from == "member"
                                              ? _dataController.groupMembers
                                                  .add({
                                                  'userID': userList[i]
                                                      ['userID'],
                                                  'displayName': userList[i]
                                                      ['displayName'],
                                                  'imageUrl': userList[i]
                                                      ['imageUrl']
                                                })
                                              : _dataController.groupAdmins
                                                  .add({
                                                  'userID': userList[i]
                                                      ['userID'],
                                                  'displayName': userList[i]
                                                      ['displayName'],
                                                  'imageUrl': userList[i]
                                                      ['imageUrl']
                                                });
                                        }
                                        setState(() {
                                          print(selectedIndex);
                                          print(widget.from == "member"
                                              ? _dataController.groupMembers
                                              : _dataController.groupAdmins);
                                        });
                                      },
                                      child: AddMemberWidget(
                                        suffixIcon: "assets/images/man1.jpg",
                                        isActive: selectedIndex.contains(i),
                                        title: userList[i]['displayName'],
                                      ),
                                    );
                                  }),
                            )
                      : groupMemberList[0]['membersList'].isEmpty
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 25.h),
                                child: Container(
                                  child: Text("No User Available"),
                                ),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  itemCount:
                                      groupMemberList[0]['membersList'].length,
                                  itemBuilder: (c, i) {
                                    return InkWell(
                                      onTap: () {
                                        if (selectedIndex.contains(i) &&
                                            (_dataController.assignGoalMember
                                                .any((map) =>
                                                    map['userID'] ==
                                                    groupMemberList[0]
                                                            ['membersList'][i]
                                                        ['userID']))) {
                                          selectedIndex.remove(i);
                                          _dataController.assignGoalMember
                                              .removeWhere((map) =>
                                                  map['userID'] ==
                                                  groupMemberList[0]
                                                          ['membersList'][i]
                                                      ['userID']);
                                        } else {
                                          selectedIndex.add(i);
                                          _dataController.assignGoalMember.add({
                                            'userID': groupMemberList[0]
                                                ['membersList'][i]['userID'],
                                            'displayName': groupMemberList[0]
                                                    ['membersList'][i]
                                                ['displayName'],
                                            'imageUrl': groupMemberList[0]
                                                ['membersList'][i]['imageUrl']
                                          });
                                        }
                                        setState(() {
                                          print(selectedIndex);
                                          print(
                                              _dataController.assignGoalMember);
                                        });
                                      },
                                      child: AddMemberWidget(
                                        suffixIcon: "assets/images/man1.jpg",
                                        isActive: selectedIndex.contains(i),
                                        title: groupMemberList[0]['membersList']
                                            [i]['displayName'],
                                      ),
                                    );
                                  })),
                ],
              ),
      ),
    );
  }
}
