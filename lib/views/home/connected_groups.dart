import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/connect_new_group.dart';
import 'package:huistaak/views/home/widgets/connected_group_widget.dart';
import 'package:huistaak/views/notification/notifications.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../controllers/data_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';

class ConnectedGroupScreen extends StatefulWidget {
  @override
  _ConnectedGroupScreenState createState() => _ConnectedGroupScreenState();
}

class _ConnectedGroupScreenState extends State<ConnectedGroupScreen> {
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  bool isUnreadNotificationPresent = false;
  final HomeController _dataController = Get.find<HomeController>();
  final NotificationController _notiController =
      Get.find<NotificationController>();

  getData() async {
    setState(() {
      isLoading = true;
    });
    await _dataController.getAllUserGroups();
    await _notiController.getNotifications();
    isUnreadNotificationPresent = _notiController.notificationList
        .any((element) => element["read"] == false);
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
      body: isLoading
          ? Center(
              child: Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: CircularProgressIndicator(color: Colors.white),
            ))
          : Padding(
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
                              backgroundImage: userData.imageUrl == ""
                                  ? AssetImage(
                                      AppImages.profileImage,
                                    )
                                  : NetworkImage(
                                      userData.imageUrl,
                                    ) as ImageProvider,
                              // AssetImage("assets/images/man1.jpg"),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              userData.displayName,
                              style: bodyNormal.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "MontserratSemiBold"),
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
                                isUnreadNotificationPresent
                                    ? Positioned(
                                        right: 1,
                                        child: Icon(
                                          Icons.circle,
                                          size: 10,
                                          color: AppColors.buttonColor,
                                        ),
                                      )
                                    : SizedBox.shrink(),
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
                    child: CustomTextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      hintText: 'Search your chats',
                      controller: searchController,
                      prefixIcon: "assets/icons/home/search.png",
                    ),
                    // child: AuthTextField(
                    //   controller: searchController,
                    //   hintText: "Search your chats",
                    //   prefixIcon: "assets/icons/home/search.png",
                    // ),
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
                        style:
                            bodyNormal.copyWith(color: AppColors.buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  _dataController.chatUsers.isEmpty
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
                            itemCount: _dataController.chatUsers.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 16),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return _dataController.chatUsers[index]
                                          ['groupName']
                                      .toLowerCase()
                                      .contains(searchController.text
                                          .toString()
                                          .toLowerCase())
                                  ? DelayedDisplay(
                                      delay: Duration(milliseconds: 400),
                                      slidingBeginOffset: Offset(0, -1),
                                      child: ConnectedGroupList(
                                        name: _dataController.chatUsers[index]
                                            ['groupName'],
                                        desc: _dataController.chatUsers[index]
                                            ['groupName'],
                                        imageUrl:
                                            _dataController.chatUsers[index]
                                                    ['groupImage'] ??
                                                "assets/images/man1.jpg",
                                        time: _dataController.chatUsers[index]
                                                    ['date'] ==
                                                null
                                            ? DateTime.now()
                                            : _dataController.chatUsers[index]
                                                    ['date']
                                                .toDate(),
                                        groupID: _dataController
                                            .chatUsers[index]['id'],
                                      ),
                                    )
                                  : SizedBox.shrink();
                            },
                          ),
                        ),
                  _dataController.chatUsers.isEmpty
                      ? Expanded(child: SizedBox())
                      : SizedBox.shrink(),
                  _dataController.chatUsers.isEmpty
                      ? DelayedDisplay(
                          delay: Duration(milliseconds: 600),
                          slidingBeginOffset: Offset(0, 0),
                          child: CustomButton(
                            onTap: () {
                              Get.to(() => ConnectNewGroup());
                            },
                            buttonText: "Create a new Group",
                          ),
                        )
                      : SizedBox.shrink(),
                  _dataController.chatUsers.isEmpty
                      ? Expanded(child: SizedBox())
                      : SizedBox.shrink(),
                ],
              ),
            ),
      floatingActionButton: isLoading
          ? null
          : _dataController.chatUsers.isEmpty
              ? null
              : FloatingActionButton(
                  backgroundColor: AppColors.buttonColor,
                  onPressed: () {
                    Get.to(() => ConnectNewGroup());
                  },
                  child: Icon(Icons.add),
                ),
    );
  }
}
