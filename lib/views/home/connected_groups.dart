import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/connect_new_group.dart';
import 'package:huistaak/views/home/widgets/connected_group_widget.dart';
import 'package:huistaak/views/notification/notifications.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import '../../widgets/text_form_fields.dart';

class ConnectedGroupScreen extends StatefulWidget {
  @override
  _ConnectedGroupScreenState createState() => _ConnectedGroupScreenState();
}

class _ConnectedGroupScreenState extends State<ConnectedGroupScreen> {
  List<dynamic> chatUsers = [];
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId.value)
        .collection("myGroups")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      setState(() {
        chatUsers.add({
          "groupImage": a['groupImage'],
          "groupName": a['groupName'],
          "id": a['groupID'],
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
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage("assets/images/man1.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        userData.displayName,
                        style: headingMedium,
                      ),
                    ],
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      Get.to(() => Notifications());
                    },
                    child: SizedBox(
                      width: 22,
                      child: Stack(
                        children: [
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(
                                  "assets/icons/home/notification.png")),
                          Positioned(
                            right: 1,
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 300),
              slidingBeginOffset: Offset(0, 0),
              child: AuthTextField(
                hintText: "Search your chats",
                prefixIcon: "assets/icons/home/search.png",
              ),
            ),
            SizedBox(
              height: 30,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 400),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Connected Groups",
                  style: bodyNormal,
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
                : chatUsers.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 25.h),
                          child: Container(
                            child: Text("No Connected Group"),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: chatUsers.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return DelayedDisplay(
                              delay: Duration(milliseconds: 400),
                              slidingBeginOffset: Offset(0, -1),
                              child: ConnectedGroupList(
                                name: chatUsers[index]['groupName'],
                                desc: chatUsers[index]['groupName'],
                                imageUrl: chatUsers[index]['groupImage'] ??
                                    "assets/images/man1.jpg",
                                time: DateTime.now(),
                                groupID: chatUsers[index]['id'],
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Get.to(() => ConnectNewGroup());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
