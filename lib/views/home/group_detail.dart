import 'package:avatar_stack/avatar_stack.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_setting.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import '../../controllers/data_controller.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/group_controller.dart';
import '../../helper/page_navigation.dart';
import '../../widgets/like_bar_widget.dart';
import 'bottom_nav_bar.dart';
import 'group/create_new_group_task.dart';

class GroupDetail extends StatefulWidget {
  final String groupID;
  final String groupTitle;

  const GroupDetail(
      {super.key, required this.groupID, required this.groupTitle});

  @override
  State<GroupDetail> createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  final GroupController _groupController = Get.find<GroupController>();
  final HomeController _dataController = Get.find<HomeController>();
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    await _groupController.getGroupDetails(
        widget.groupID.toString(), widget.groupTitle.toString());
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
        backgroundColor: AppColors.buttonColor,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
              child: Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: CircularProgressIndicator(),
            ))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: AppColors.buttonColor,
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 300),
                    slidingBeginOffset: Offset(0, -1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 18.0, left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              ZoomTapAnimation(
                                onTap: () {
                                  Get.find<GeneralController>()
                                      .onBottomBarTapped(0);
                                  PageTransition.pageProperNavigation(
                                      page: CustomBottomNavBar(
                                    pageIndex: 0,
                                  ));
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: _groupController.groupInfo[0]
                                            ['groupImage'] ==
                                        null
                                    ? AssetImage("assets/images/man1.jpg")
                                    : NetworkImage(_groupController.groupInfo[0]
                                        ['groupImage']) as ImageProvider,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.groupTitle,
                                    style: headingMedium.copyWith(
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  _groupController.groupInfo[0]['membersList']
                                              .length >
                                          0
                                      ? _groupController
                                                  .groupInfo[0]['membersList']
                                                  .length >
                                              1
                                          ? SizedBox(
                                              width: 150,
                                              child: Text(
                                                "You, " +
                                                    _groupController
                                                                .groupInfo[0]
                                                            ['membersList'][0]
                                                        ['displayName'] +
                                                    " , " +
                                                    _groupController
                                                                .groupInfo[0]
                                                            ['membersList'][1]
                                                        ['displayName'] +
                                                    "...",
                                                style: bodySmall.copyWith(
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          : SizedBox(
                                              width: 150,
                                              child: Text(
                                                "You, " +
                                                    _groupController
                                                                .groupInfo[0]
                                                            ['membersList'][0]
                                                        ['displayName'],
                                                style: bodySmall.copyWith(
                                                    color: Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            )
                                      : SizedBox(
                                          width: 150,
                                          child: Text(
                                            "You ",
                                            style: bodySmall.copyWith(
                                                color: Colors.white),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                          ZoomTapAnimation(
                            onTap: () {
                              Get.to(() => GroupSetting(
                                    groupID: widget.groupID,
                                  ));
                            },
                            child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Image.asset(
                                  "assets/icons/home/setting.png",
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        // DelayedDisplay(
                        //   delay: Duration(milliseconds: 400),
                        //   slidingBeginOffset: Offset(0, 0),
                        //   child: Align(
                        //     alignment: Alignment.center,
                        //     child: Text(
                        //       "Today's Task",
                        //       style: bodyNormal.copyWith(color: Colors.black54),
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 6,
                        // ),
                        _groupController.taskList.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 25.h),
                                  child: Container(
                                    child: Text("No tasks for now"),
                                  ),
                                ),
                              )
                            : Container(
                                height: 74.h,
                                child: ListView.builder(
                                  itemCount: _groupController.taskList.length,
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
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: DelayedDisplay(
                                            delay: Duration(milliseconds: 600),
                                            slidingBeginOffset: Offset(0, -1),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    _groupController
                                                            .taskList[index]
                                                        ['taskTitle'],
                                                    style:
                                                        headingLarge.copyWith(
                                                            color:
                                                                Colors.white),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TaskDetailWidget(
                                                    icon:
                                                        "assets/icons/home/date.png",
                                                    title: "Date",
                                                    data: DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(_groupController
                                                            .taskList[index]
                                                                ['taskDate']
                                                            .toDate())),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TaskDetailWidget(
                                                    icon:
                                                        "assets/icons/home/time.png",
                                                    title: "Time",
                                                    data: _groupController
                                                                .taskList[index]
                                                            ['startTime'] +
                                                        " to " +
                                                        _groupController
                                                                .taskList[index]
                                                            ['endTime']),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TaskDetailWidget(
                                                    icon:
                                                        "assets/icons/home/duration.png",
                                                    title: "Task Duration",
                                                    data: _groupController
                                                                .taskList[index]
                                                            ['duration'] +
                                                        " hours"),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TaskDetailWidget(
                                                    icon:
                                                        "assets/icons/home/points.png",
                                                    title: "Task Score Points",
                                                    data: _groupController
                                                            .taskList[index]
                                                        ['taskScore']),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    _groupController
                                                                .taskList[index]
                                                                    [
                                                                    'assignMembers']
                                                                .length >
                                                            0
                                                        ? Text(
                                                            "Task assigned to:",
                                                            style: headingSmall
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white),
                                                          )
                                                        : SizedBox.shrink(),
                                                    _groupController
                                                                .taskList[index]
                                                                    [
                                                                    'assignMembers']
                                                                .length >
                                                            0
                                                        ? SizedBox(
                                                            width: 74,
                                                            child: AvatarStack(
                                                              height: 34,
                                                              avatars: [
                                                                for (var n = 0;
                                                                    n <
                                                                        _groupController
                                                                            .taskList[index][
                                                                                'assignMembers']
                                                                            .length;
                                                                    n++)
                                                                  AssetImage(
                                                                      "assets/images/man1.jpg"),
                                                              ],
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                  ],
                                                ),
                                                for (int i = 0;
                                                    i <
                                                        _groupController
                                                            .taskList[index][
                                                                'assignMembers']
                                                            .length;
                                                    i++)
                                                  !_groupController
                                                          .taskList[index]
                                                              ['assignMembers']
                                                              [i]
                                                          .containsKey(
                                                              "endTask")
                                                      ? SizedBox.shrink()
                                                      : LikeBarWidget(
                                                          image:
                                                              "assets/images/man1.jpg",
                                                          count: _groupController
                                                                              .taskList[
                                                                          index]
                                                                      [
                                                                      'assignMembers'][i]
                                                                  [
                                                                  'pointsEarned'] ??
                                                              "0",
                                                          percent: (double.parse(
                                                                  _groupController
                                                                              .taskList[index]
                                                                          ['assignMembers'][i]
                                                                      [
                                                                      'pointsEarned']) /
                                                              double.parse(
                                                                  _groupController
                                                                              .taskList[
                                                                          index]
                                                                      [
                                                                      'taskScore'])),
                                                          TotalCount:
                                                              _groupController
                                                                          .taskList[
                                                                      index]
                                                                  ['taskScore'],
                                                        ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                _groupController.taskList[index]
                                                            ['assignMembers']
                                                        .any((user) =>
                                                            user["userID"]
                                                                .toString() ==
                                                            userData.userID
                                                                .toString())
                                                    ? _groupController
                                                            .taskList[index][
                                                                'assignMembers']
                                                            .any((map) =>
                                                                map['endTask'] ==
                                                                null)
                                                        ? Row(
                                                            children: [
                                                              _groupController
                                                                      .taskList[
                                                                          index]
                                                                          [
                                                                          'assignMembers']
                                                                      .any((map) =>
                                                                          map['startTask'] !=
                                                                          null)
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                8),
                                                                        child:
                                                                            ZoomTapAnimation(
                                                                          onTap:
                                                                              () async {
                                                                            await _groupController.startTask(
                                                                                widget.groupID.toString(),
                                                                                _groupController.taskList[index]['id'].toString(),
                                                                                widget.groupTitle);
                                                                            getData();
                                                                          },
                                                                          onLongTap:
                                                                              () {},
                                                                          enableLongTapRepeatEvent:
                                                                              false,
                                                                          longTapRepeatDuration:
                                                                              const Duration(milliseconds: 100),
                                                                          begin:
                                                                              1.0,
                                                                          end:
                                                                              0.93,
                                                                          beginDuration:
                                                                              const Duration(milliseconds: 20),
                                                                          endDuration:
                                                                              const Duration(milliseconds: 120),
                                                                          beginCurve:
                                                                              Curves.decelerate,
                                                                          endCurve:
                                                                              Curves.fastOutSlowIn,
                                                                          child: Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              width: double.infinity,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(50),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text("Start", style: bodyLarge.copyWith(color: AppColors.buttonColor, fontWeight: FontWeight.bold)),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              _groupController
                                                                      .taskList[
                                                                          index]
                                                                          [
                                                                          'assignMembers']
                                                                      .any((map) =>
                                                                          map['startTask'] ==
                                                                          null)
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : Expanded(
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            vertical:
                                                                                8),
                                                                        child:
                                                                            ZoomTapAnimation(
                                                                          onTap:
                                                                              () async {
                                                                            await _groupController.endTask(
                                                                                widget.groupID.toString(),
                                                                                _groupController.taskList[index]['id'].toString(),
                                                                                _groupController.taskList[index]['assignMembers'],
                                                                                double.parse(_groupController.taskList[index]['duration'].toString()) * 60,
                                                                                _groupController.taskList[index]['taskScore'],
                                                                                widget.groupTitle);
                                                                            getData();
                                                                          },
                                                                          onLongTap:
                                                                              () {},
                                                                          enableLongTapRepeatEvent:
                                                                              false,
                                                                          longTapRepeatDuration:
                                                                              const Duration(milliseconds: 100),
                                                                          begin:
                                                                              1.0,
                                                                          end:
                                                                              0.93,
                                                                          beginDuration:
                                                                              const Duration(milliseconds: 20),
                                                                          endDuration:
                                                                              const Duration(milliseconds: 120),
                                                                          beginCurve:
                                                                              Curves.decelerate,
                                                                          endCurve:
                                                                              Curves.fastOutSlowIn,
                                                                          child: Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              width: double.infinity,
                                                                              height: 50,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white.withOpacity(0.5),
                                                                                borderRadius: BorderRadius.circular(50),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text("Finish", style: bodyLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ),
                                                            ],
                                                          )
                                                        : SizedBox.shrink()
                                                    : SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: isLoading
          ? SizedBox.shrink()
          : _groupController.groupInfo[0]['adminsList'].any((user) =>
                  user["userID"].toString() == userData.userID.toString())
              ? FloatingActionButton(
                  backgroundColor: AppColors.buttonColor,
                  onPressed: () {
                    Get.to(() => CreateNewGroupTask(
                          groupID: widget.groupID,
                          groupTitle: widget.groupTitle,
                        ));
                  },
                  child: Icon(Icons.add),
                )
              : SizedBox.shrink(),
    );
  }
}
