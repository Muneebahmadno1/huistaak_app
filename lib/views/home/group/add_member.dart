import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/home/widgets/add_members_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/data_helper.dart';
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
  final DataHelper _dataController = Get.find<DataHelper>();

  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("userID", isNotEqualTo: userData.userID)
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
                : userList.isEmpty
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
                                          ? _dataController.groupMembers.any(
                                              (map) =>
                                                  map['userID'] ==
                                                  userList[i]['userID'])
                                          : _dataController.groupAdmins.any(
                                              (map) =>
                                                  map['userID'] ==
                                                  userList[i]['userID']))) {
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
                                        ? _dataController.groupMembers.add({
                                            'userID': userList[i]['userID'],
                                            'displayName': userList[i]
                                                ['displayName'],
                                            'imageUrl': userList[i]['imageUrl']
                                          })
                                        : _dataController.groupAdmins.add({
                                            'userID': userList[i]['userID'],
                                            'displayName': userList[i]
                                                ['displayName'],
                                            'imageUrl': userList[i]['imageUrl']
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
                      ),
          ],
        ),
      ),
    );
  }
}
