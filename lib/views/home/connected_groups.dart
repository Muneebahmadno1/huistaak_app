import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/connect_new_group.dart';
import 'package:huistaak/views/home/widgets/connected_group_widget.dart';
import 'package:huistaak/views/notification/notifications.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import '../../models/connected_group_model.dart';
import '../../widgets/text_form_fields.dart';

class ConnectedGroupScreen extends StatefulWidget {
  @override
  _ConnectedGroupScreenState createState() => _ConnectedGroupScreenState();
}

class _ConnectedGroupScreenState extends State<ConnectedGroupScreen> {
  List<ConnectedGroup> chatUsers = [
    ConnectedGroup(
        name: "Household tasks",
        desc: "James posted a new task",
        imageURL: "assets/images/man1.jpg",
        time: "06:00 PM"),
    ConnectedGroup(
        name: "Daily tasks",
        desc: "Leslie posted a new task",
        imageURL: "assets/images/man1.jpg",
        time: "04:40 PM"),
  ];
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
                        "Leslie Alexander",
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
            Expanded(
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
                      name: chatUsers[index].name,
                      desc: chatUsers[index].desc,
                      imageUrl: chatUsers[index].imageURL,
                      time: chatUsers[index].time,
                      isOpened: (index == 0 || index == 3) ? true : false,
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
