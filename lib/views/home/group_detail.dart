import 'dart:async';

import 'package:avatar_stack/avatar_stack.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_setting.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/group_controller.dart';
import '../../helper/page_navigation.dart';
import '../../models/member_model.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/like_bar_widget.dart';
import 'bottom_nav_bar.dart';
import 'group/create_new_group_task.dart';
import 'group/edit_group_task.dart';

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
  bool isLoading = false;
  bool isFinish = false;
  int selectedContainer = 0;
  int selectedIndex = 0;
  int achievedPoints = 0;

  getData() async {
    setState(() {
      isLoading = true;
    });
    _progressValue.clear();
    await _groupController.getGroupDetails(
        widget.groupID.toString(), widget.groupTitle.toString());
    for (int index = 0; index < userData.points.length; index++) {
      if (userData.points[index]['groupID'] == widget.groupID) {
        achievedPoints = int.parse(userData.points[index]['point'].toString());
        break; // Stop searching once a match is found
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void _onContainerTap(int index) {
    setState(() {
      selectedContainer = index;
    });
  }

  Widget buildContainer(int index, text) {
    bool isSelected = selectedContainer == index;
    Color containerColor = isSelected ? AppColors.buttonColor : Colors.white;
    Color borderColor =
        isSelected ? AppColors.primaryColor : AppColors.buttonColor;
    Color textColor = isSelected ? Colors.white : AppColors.buttonColor;
    return GestureDetector(
      onTap: () {
        _onContainerTap(index);
        selectedIndex = index;
      },
      child: Container(
        width: 25.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: Center(
          child: Icon(
            text,
            color: isSelected ? AppColors.primaryColor : AppColors.buttonColor,
          ),
        ),
      ),
    );
  }

  List<double> _progressValue = [];
  List<DateTime> _startTime = [];
  List<DateTime> _endTime = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  late Timer _timer;

  void _updateProgress(index, startTimeList, endTimeList) {
    DateTime now = DateTime.now();
    double progress = now.difference(startTimeList[index]).inMilliseconds /
        endTimeList[index].difference(startTimeList[index]).inMilliseconds;

    // Ensure progress is between 0.0 and 1.0
    if (progress > 1.0) {
      progress = 1.0;
      // Optionally, you can stop the timer here if needed
      // timer.cancel();
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _progressValue[index] = progress;
    });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _timer.cancel();
  //   super.dispose();
  // }

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
              padding: EdgeInsets.only(top: 20.h),
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
                                radius: 20, // Adjust the radius as needed
                                backgroundColor: Colors
                                    .grey, // You can set a default background color
                                child: ClipOval(
                                  child: SizedBox(
                                    height: 20 * 2,
                                    width: 20 * 2,
                                    child: _groupController
                                                .groupInfo[0].groupImage ==
                                            null
                                        ? Image.asset(
                                            AppImages.groupIcon,
                                            // Replace with your asset image path
                                            fit: BoxFit.fitHeight,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: _groupController
                                                .groupInfo[0].groupImage,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                            fit: BoxFit.fitHeight,
                                          ),
                                  ),
                                ),
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
                                  Row(
                                    children: [
                                      Text(
                                        "Group Id : ",
                                        style: bodySmall.copyWith(
                                            color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Container(
                                        width: 40.w,
                                        child: SelectableText(
                                            _groupController
                                                .groupInfo[0].groupCode
                                                .toString(),
                                            maxLines: 1,
                                            style: bodySmall.copyWith(
                                                color: Colors.white,
                                                fontFamily:
                                                    "MontserratSemiBold")),
                                      ),
                                    ],
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
                userData.points.toString() == "[]"
                    ? SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Achieved points : " + achievedPoints.toString(),
                            maxLines: 1,
                            style: bodyNormal.copyWith(
                                color: AppColors.buttonColor),
                          ),
                        ),
                      ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 10.0.w, right: 10.0.w, top: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildContainer(0, Icons.alarm),
                      buildContainer(1, Icons.check),
                      buildContainer(2, Icons.close),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            selectedContainer == 0
                                ? _groupController.toBeCompletedTaskList.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 25.h),
                                          child: Container(
                                            child: Text("No tasks for now"),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: 67.h,
                                        child: ListView.builder(
                                          itemCount: _groupController
                                              .toBeCompletedTaskList.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(top: 16),
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            _progressValue.add(0.0);

                                            List<MemberModel> assignMembers =
                                                _groupController
                                                    .toBeCompletedTaskList[
                                                        index]
                                                    .assignMembers;

                                            String assignedMembersString =
                                                assignMembers
                                                    .map((member) =>
                                                        member.displayName)
                                                    .join(', ');

                                            var a = double.parse(
                                                _groupController
                                                    .toBeCompletedTaskList[
                                                        index]
                                                    .duration
                                                    .toString());
                                            _startTime.add(
                                                DateFormat('yyyy-MM-dd HH:mm')
                                                    .parse(_groupController
                                                        .toBeCompletedTaskList[
                                                            index]
                                                        .startTime
                                                        .toString()));

                                            _endTime.add(_startTime[index].add(
                                                Duration(
                                                    hours: a
                                                        .toInt()))); // Adjust the duration as needed

                                            if (_startTime[index]
                                                .isBefore(DateTime.now())) {
                                              // Start the timer to update the progress
                                              _timer = Timer.periodic(
                                                  Duration(seconds: 5),
                                                  (Timer _timer) {
                                                _updateProgress(index,
                                                    _startTime, _endTime);
                                              });
                                            }
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 15.0),
                                              child: DelayedDisplay(
                                                delay:
                                                    Duration(milliseconds: 400),
                                                slidingBeginOffset:
                                                    Offset(0, 0),
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        AppColors.buttonColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: DelayedDisplay(
                                                    delay: Duration(
                                                        milliseconds: 600),
                                                    slidingBeginOffset:
                                                        Offset(0, -1),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Container(
                                                                width: 60.w,
                                                                child: Tooltip(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              30,
                                                                          right:
                                                                              30),
                                                                  message: _groupController
                                                                      .toBeCompletedTaskList[
                                                                          index]
                                                                      .taskTitle,
                                                                  child: Text(
                                                                    _groupController
                                                                        .toBeCompletedTaskList[
                                                                            index]
                                                                        .taskTitle,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: headingLarge
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                _groupController
                                                                        .groupInfo[
                                                                            0]
                                                                        .adminsList
                                                                        .any((user) =>
                                                                            user.userID.toString() ==
                                                                            userData.userID
                                                                                .toString())
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Get.to(() =>
                                                                              EditGroupTask(
                                                                                groupID: widget.groupID,
                                                                                groupTitle: widget.groupTitle,
                                                                                taskDetails: _groupController.toBeCompletedTaskList[index],
                                                                              ));
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                                SizedBox(
                                                                  width: 1.w,
                                                                ),
                                                                _groupController
                                                                        .groupInfo[
                                                                            0]
                                                                        .adminsList
                                                                        .any((user) =>
                                                                            user.userID.toString() ==
                                                                            userData.userID
                                                                                .toString())
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          confirmPopUp(
                                                                              context,
                                                                              "Are you sure, you want to delete task?",
                                                                              () {
                                                                            _groupController.deleteTask(
                                                                              widget.groupID.toString(),
                                                                              _groupController.toBeCompletedTaskList[index].id.toString(),
                                                                            );
                                                                            getData();
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TaskDetailWidget(
                                                            icon:
                                                                "assets/icons/home/date.png",
                                                            title: "Date",
                                                            data: DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(_groupController
                                                                    .toBeCompletedTaskList[
                                                                        index]
                                                                    .taskDate
                                                                    .toDate())),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TaskDetailWidget(
                                                            icon:
                                                                "assets/icons/home/time.png",
                                                            title: "Time",
                                                            data: DateFormat(
                                                                        'dd-MM-yyyy HH:mm')
                                                                    .format(DateTime.parse(_groupController
                                                                        .toBeCompletedTaskList[
                                                                            index]
                                                                        .startTime)) +
                                                                " to " +
                                                                DateFormat(
                                                                        'dd-MM-yyyy HH:mm')
                                                                    .format(DateTime.parse(_groupController
                                                                        .toBeCompletedTaskList[
                                                                            index]
                                                                        .endTime))),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TaskDetailWidget(
                                                            icon:
                                                                "assets/icons/home/duration.png",
                                                            title:
                                                                "Task Duration",
                                                            data: _groupController
                                                                    .toBeCompletedTaskList[
                                                                        index]
                                                                    .duration +
                                                                " hours"),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        TaskDetailWidget(
                                                            icon:
                                                                "assets/icons/home/points.png",
                                                            title:
                                                                "Task Score Points",
                                                            data: _groupController
                                                                .toBeCompletedTaskList[
                                                                    index]
                                                                .taskScore),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        _startTime[index]
                                                                .isBefore(
                                                                    DateTime
                                                                        .now())
                                                            ? Row(
                                                                children: [
                                                                  Container(
                                                                    width: 65.w,
                                                                    child:
                                                                        LinearProgressIndicator(
                                                                      value: _progressValue[
                                                                          index],
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .green),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        1.5.w,
                                                                  ),
                                                                  Text(
                                                                    (_progressValue[index] *
                                                                                100)
                                                                            .toStringAsFixed(0)
                                                                            .toString() +
                                                                        "%",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                ],
                                                              )
                                                            : SizedBox.shrink(),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            _groupController
                                                                        .toBeCompletedTaskList[
                                                                            index]
                                                                        .assignMembers
                                                                        .length >
                                                                    0
                                                                ? Text(
                                                                    "Task assigned to:",
                                                                    style: headingSmall
                                                                        .copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                            _groupController
                                                                        .toBeCompletedTaskList[
                                                                            index]
                                                                        .assignMembers
                                                                        .length >
                                                                    0
                                                                ? SizedBox(
                                                                    width: 74,
                                                                    child:
                                                                        Tooltip(
                                                                      message:
                                                                          assignedMembersString,
                                                                      child:
                                                                          AvatarStack(
                                                                        height:
                                                                            34,
                                                                        avatars: [
                                                                          for (var n = 0;
                                                                              n < _groupController.toBeCompletedTaskList[index].assignMembers.length;
                                                                              n++)
                                                                            _groupController.toBeCompletedTaskList[index].assignMembers[n].imageUrl == "" ? AssetImage("assets/images/man1.png") : NetworkImage(_groupController.toBeCompletedTaskList[index].assignMembers[n].imageUrl.toString()) as ImageProvider,
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox
                                                                    .shrink(),
                                                          ],
                                                        ),
                                                        for (int i = 0;
                                                            i <
                                                                _groupController
                                                                    .toBeCompletedTaskList[
                                                                        index]
                                                                    .assignMembers
                                                                    .length;
                                                            i++)
                                                          _groupController
                                                                      .toBeCompletedTaskList[
                                                                          index]
                                                                      .assignMembers[
                                                                          i]
                                                                      .endTask ==
                                                                  null
                                                              ? SizedBox
                                                                  .shrink()
                                                              : LikeBarWidget(
                                                                  image: _groupController
                                                                      .toBeCompletedTaskList[
                                                                          index]
                                                                      .assignMembers[
                                                                          i]
                                                                      .imageUrl,
                                                                  count: _groupController
                                                                          .toBeCompletedTaskList[
                                                                              index]
                                                                          .assignMembers[
                                                                              i]
                                                                          .pointsEarned ??
                                                                      "0",
                                                                  percent: (double.parse(_groupController
                                                                          .toBeCompletedTaskList[
                                                                              index]
                                                                          .assignMembers[
                                                                              i]
                                                                          .pointsEarned) /
                                                                      double.parse(_groupController
                                                                          .toBeCompletedTaskList[
                                                                              index]
                                                                          .taskScore)),
                                                                  TotalCount: _groupController
                                                                      .toBeCompletedTaskList[
                                                                          index]
                                                                      .taskScore,
                                                                ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        _startTime[index]
                                                                .isBefore(
                                                                    DateTime
                                                                        .now())
                                                            ? _groupController
                                                                    .toBeCompletedTaskList[
                                                                        index]
                                                                    .assignMembers
                                                                    .any((map) =>
                                                                        map.userID.toString() ==
                                                                            userData.userID
                                                                                .toString() &&
                                                                        map.endTask ==
                                                                            null)
                                                                ? Row(
                                                                    children: [
                                                                      // _groupController.toBeCompletedTaskList[index].assignMembers.any((map) =>
                                                                      //         map.userID.toString() == userData.userID.toString() &&
                                                                      //         map.startTask !=
                                                                      //             null)
                                                                      //     ? SizedBox
                                                                      //         .shrink()
                                                                      //     : Expanded(
                                                                      //         child: Padding(
                                                                      //           padding: const EdgeInsets.symmetric(vertical: 8),
                                                                      //           child: ZoomTapAnimation(
                                                                      //             onTap: () async {
                                                                      //               await _groupController.startTask(widget.groupID.toString(), _groupController.toBeCompletedTaskList[index].id.toString(), widget.groupTitle);
                                                                      //               getData();
                                                                      //             },
                                                                      //             onLongTap: () {},
                                                                      //             enableLongTapRepeatEvent: false,
                                                                      //             longTapRepeatDuration: const Duration(milliseconds: 100),
                                                                      //             begin: 1.0,
                                                                      //             end: 0.93,
                                                                      //             beginDuration: const Duration(milliseconds: 20),
                                                                      //             endDuration: const Duration(milliseconds: 120),
                                                                      //             beginCurve: Curves.decelerate,
                                                                      //             endCurve: Curves.fastOutSlowIn,
                                                                      //             child: Container(
                                                                      //                 padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                      //                 width: double.infinity,
                                                                      //                 height: 50,
                                                                      //                 decoration: BoxDecoration(
                                                                      //                   color: Colors.white,
                                                                      //                   borderRadius: BorderRadius.circular(50),
                                                                      //                 ),
                                                                      //                 child: Center(
                                                                      //                   child: Text("Start", style: bodyLarge.copyWith(color: AppColors.buttonColor, fontWeight: FontWeight.bold)),
                                                                      //                 )),
                                                                      //           ),
                                                                      //         ),
                                                                      //       ),
                                                                      // SizedBox(
                                                                      //   width:
                                                                      //       10,
                                                                      // ),
                                                                      _groupController.toBeCompletedTaskList[index].assignMembers.any((map) =>
                                                                              map.userID.toString() == userData.userID.toString() &&
                                                                              map.startTask ==
                                                                                  null)
                                                                          ? SizedBox
                                                                              .shrink()
                                                                          : Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                child: ZoomTapAnimation(
                                                                                  onTap: () async {
                                                                                    setState(() {
                                                                                      isLoading = true;
                                                                                    });
                                                                                    await _groupController.endTask(widget.groupID.toString(), _groupController.toBeCompletedTaskList[index].id.toString(), _groupController.toBeCompletedTaskList[index].assignMembers, double.parse(_groupController.toBeCompletedTaskList[index].duration.toString()) * 60, _groupController.toBeCompletedTaskList[index].taskScore, widget.groupTitle, _groupController.groupInfo[0].adminsList, achievedPoints.toString());
                                                                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                                                                      setState(() {
                                                                                        isFinish = false;
                                                                                      });
                                                                                    });
                                                                                    Future.delayed(const Duration(milliseconds: 3000), () async {
                                                                                      setState(() {});
                                                                                      await getData();
                                                                                      setState(() {
                                                                                        isFinish = true;
                                                                                      });
                                                                                      Future.delayed(const Duration(milliseconds: 3000), () async {
                                                                                        setState(() {
                                                                                          isFinish = false;
                                                                                        });
                                                                                      });
                                                                                    });
                                                                                  },
                                                                                  onLongTap: () {},
                                                                                  enableLongTapRepeatEvent: false,
                                                                                  longTapRepeatDuration: const Duration(milliseconds: 100),
                                                                                  begin: 1.0,
                                                                                  end: 0.93,
                                                                                  beginDuration: const Duration(milliseconds: 20),
                                                                                  endDuration: const Duration(milliseconds: 120),
                                                                                  beginCurve: Curves.decelerate,
                                                                                  endCurve: Curves.fastOutSlowIn,
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
                                                                : SizedBox
                                                                    .shrink()
                                                            : SizedBox.shrink(),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                : selectedContainer == 1
                                    ? _groupController.completedTaskList.isEmpty
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 25.h),
                                              child: Container(
                                                child: Text("No tasks for now"),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 67.h,
                                            child: ListView.builder(
                                              itemCount: _groupController
                                                  .completedTaskList.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(top: 16),
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                List<MemberModel>
                                                    assignMembers =
                                                    _groupController
                                                        .completedTaskList[
                                                            index]
                                                        .assignMembers;

                                                String assignedMembersString =
                                                    assignMembers
                                                        .map((member) =>
                                                            member.displayName)
                                                        .join(', ');

                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15.0),
                                                  child: DelayedDisplay(
                                                    delay: Duration(
                                                        milliseconds: 400),
                                                    slidingBeginOffset:
                                                        Offset(0, 0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.green[900],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: DelayedDisplay(
                                                        delay: Duration(
                                                            milliseconds: 600),
                                                        slidingBeginOffset:
                                                            Offset(0, -1),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Container(
                                                                    width: 60.w,
                                                                    child:
                                                                        Tooltip(
                                                                      message: _groupController
                                                                          .completedTaskList[
                                                                              index]
                                                                          .taskTitle,
                                                                      child:
                                                                          Text(
                                                                        _groupController
                                                                            .completedTaskList[index]
                                                                            .taskTitle,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: headingLarge.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                _groupController
                                                                        .groupInfo[
                                                                            0]
                                                                        .adminsList
                                                                        .any((user) =>
                                                                            user.userID.toString() ==
                                                                            userData.userID
                                                                                .toString())
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          confirmPopUp(
                                                                              context,
                                                                              "Are you sure, you want to delete task?",
                                                                              () {
                                                                            _groupController.deleteTask(
                                                                              widget.groupID.toString(),
                                                                              _groupController.completedTaskList[index].id.toString(),
                                                                            );
                                                                            getData();
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink()
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/date.png",
                                                                title: "Date",
                                                                data: DateFormat(
                                                                        'dd-MM-yyyy')
                                                                    .format(_groupController
                                                                        .completedTaskList[
                                                                            index]
                                                                        .taskDate
                                                                        .toDate())),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/time.png",
                                                                title: "Time",
                                                                data: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(_groupController
                                                                        .completedTaskList[
                                                                            index]
                                                                        .startTime)) +
                                                                    " to " +
                                                                    DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(_groupController
                                                                        .completedTaskList[
                                                                            index]
                                                                        .endTime))),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/duration.png",
                                                                title:
                                                                    "Task Duration",
                                                                data: _groupController
                                                                        .completedTaskList[
                                                                            index]
                                                                        .duration +
                                                                    " hours"),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/points.png",
                                                                title:
                                                                    "Task Score Points",
                                                                data: _groupController
                                                                    .completedTaskList[
                                                                        index]
                                                                    .taskScore),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                _groupController
                                                                            .completedTaskList[
                                                                                index]
                                                                            .assignMembers
                                                                            .length >
                                                                        0
                                                                    ? Text(
                                                                        "Task assigned to:",
                                                                        style: headingSmall.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                                _groupController
                                                                            .completedTaskList[
                                                                                index]
                                                                            .assignMembers
                                                                            .length >
                                                                        0
                                                                    ? SizedBox(
                                                                        width:
                                                                            74,
                                                                        child:
                                                                            Tooltip(
                                                                          message:
                                                                              assignedMembersString,
                                                                          child:
                                                                              AvatarStack(
                                                                            height:
                                                                                34,
                                                                            avatars: [
                                                                              for (var n = 0; n < _groupController.completedTaskList[index].assignMembers.length; n++)
                                                                                _groupController.completedTaskList[index].assignMembers[n].imageUrl == "" ? AssetImage("assets/images/man1.png") : NetworkImage(_groupController.completedTaskList[index].assignMembers[n].imageUrl.toString()) as ImageProvider,
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                              ],
                                                            ),
                                                            for (int i = 0;
                                                                i <
                                                                    _groupController
                                                                        .completedTaskList[
                                                                            index]
                                                                        .assignMembers
                                                                        .length;
                                                                i++)
                                                              _groupController
                                                                          .completedTaskList[
                                                                              index]
                                                                          .assignMembers[
                                                                              i]
                                                                          .endTask ==
                                                                      null
                                                                  ? SizedBox
                                                                      .shrink()
                                                                  : LikeBarWidget(
                                                                      image: _groupController
                                                                          .completedTaskList[
                                                                              index]
                                                                          .assignMembers[
                                                                              i]
                                                                          .imageUrl,
                                                                      count: _groupController
                                                                              .completedTaskList[index]
                                                                              .assignMembers[i]
                                                                              .pointsEarned ??
                                                                          "0",
                                                                      percent: (double.parse(_groupController.completedTaskList[index].assignMembers[i].pointsEarned ??
                                                                              "0") /
                                                                          double.parse(_groupController
                                                                              .completedTaskList[index]
                                                                              .taskScore)),
                                                                      TotalCount: _groupController
                                                                          .completedTaskList[
                                                                              index]
                                                                          .taskScore,
                                                                    ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            _groupController
                                                                    .completedTaskList[
                                                                        index]
                                                                    .assignMembers
                                                                    .any((map) =>
                                                                        map.userID.toString() ==
                                                                            userData.userID
                                                                                .toString() &&
                                                                        map.endTask ==
                                                                            null)
                                                                ? Row(
                                                                    children: [
                                                                      _groupController.completedTaskList[index].assignMembers.any((map) =>
                                                                              map.userID.toString() == userData.userID.toString() &&
                                                                              map.startTask !=
                                                                                  null)
                                                                          ? SizedBox
                                                                              .shrink()
                                                                          : Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                child: ZoomTapAnimation(
                                                                                  onTap: () async {
                                                                                    await _groupController.startTask(widget.groupID.toString(), _groupController.completedTaskList[index].id.toString(), widget.groupTitle);
                                                                                    getData();
                                                                                  },
                                                                                  onLongTap: () {},
                                                                                  enableLongTapRepeatEvent: false,
                                                                                  longTapRepeatDuration: const Duration(milliseconds: 100),
                                                                                  begin: 1.0,
                                                                                  end: 0.93,
                                                                                  beginDuration: const Duration(milliseconds: 20),
                                                                                  endDuration: const Duration(milliseconds: 120),
                                                                                  beginCurve: Curves.decelerate,
                                                                                  endCurve: Curves.fastOutSlowIn,
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
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      _groupController.completedTaskList[index].assignMembers.any((map) =>
                                                                              map.userID.toString() == userData.userID.toString() &&
                                                                              map.startTask ==
                                                                                  null)
                                                                          ? SizedBox
                                                                              .shrink()
                                                                          : Expanded(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                                                child: ZoomTapAnimation(
                                                                                  onTap: () async {
                                                                                    setState(() {
                                                                                      isLoading = true;
                                                                                    });
                                                                                    await _groupController.endTask(widget.groupID.toString(), _groupController.completedTaskList[index].id.toString(), _groupController.completedTaskList[index].assignMembers, double.parse(_groupController.completedTaskList[index].duration.toString()) * 60, _groupController.completedTaskList[index].taskScore, widget.groupTitle, _groupController.groupInfo[0].adminsList, achievedPoints.toString());
                                                                                    Future.delayed(const Duration(milliseconds: 1000), () {
                                                                                      print(_groupController.completedTaskList[index].assignMembers.any((map) => map.startTask == null));
                                                                                      print(widget.groupTitle.toString());
                                                                                      setState(() {
                                                                                        isFinish = false;
                                                                                      });
                                                                                    });
                                                                                    Future.delayed(const Duration(milliseconds: 3000), () async {
                                                                                      setState(() {});
                                                                                      await getData();
                                                                                      setState(() {
                                                                                        isFinish = true;
                                                                                      });
                                                                                      successPopUp(context, "", "Task completed");
                                                                                      Future.delayed(const Duration(milliseconds: 3000), () async {
                                                                                        setState(() {
                                                                                          isFinish = false;
                                                                                        });
                                                                                      });
                                                                                    });
                                                                                  },
                                                                                  onLongTap: () {},
                                                                                  enableLongTapRepeatEvent: false,
                                                                                  longTapRepeatDuration: const Duration(milliseconds: 100),
                                                                                  begin: 1.0,
                                                                                  end: 0.93,
                                                                                  beginDuration: const Duration(milliseconds: 20),
                                                                                  endDuration: const Duration(milliseconds: 120),
                                                                                  beginCurve: Curves.decelerate,
                                                                                  endCurve: Curves.fastOutSlowIn,
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
                                                                : SizedBox
                                                                    .shrink(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                    : _groupController
                                            .notCompletedTaskList.isEmpty
                                        ? Center(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(top: 25.h),
                                              child: Container(
                                                child: Text("No tasks for now"),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 67.h,
                                            child: ListView.builder(
                                              itemCount: _groupController
                                                  .notCompletedTaskList.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.only(top: 16),
                                              physics: BouncingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                List<MemberModel>
                                                    assignMembers =
                                                    _groupController
                                                        .notCompletedTaskList[
                                                            index]
                                                        .assignMembers;

                                                String assignedMembersString =
                                                    assignMembers
                                                        .map((member) =>
                                                            member.displayName)
                                                        .join(', ');

                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 15.0),
                                                  child: DelayedDisplay(
                                                    delay: Duration(
                                                        milliseconds: 400),
                                                    slidingBeginOffset:
                                                        Offset(0, 0),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red[900],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: DelayedDisplay(
                                                        delay: Duration(
                                                            milliseconds: 600),
                                                        slidingBeginOffset:
                                                            Offset(0, -1),
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child:
                                                                      Container(
                                                                    width: 60.w,
                                                                    child:
                                                                        Tooltip(
                                                                      message: _groupController
                                                                          .notCompletedTaskList[
                                                                              index]
                                                                          .taskTitle,
                                                                      child:
                                                                          Text(
                                                                        _groupController
                                                                            .notCompletedTaskList[index]
                                                                            .taskTitle,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: headingLarge.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                _groupController
                                                                        .groupInfo[
                                                                            0]
                                                                        .adminsList
                                                                        .any((user) =>
                                                                            user.userID.toString() ==
                                                                            userData.userID
                                                                                .toString())
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          confirmPopUp(
                                                                              context,
                                                                              "Are you sure, you want to delete task?",
                                                                              () {
                                                                            _groupController.deleteTask(
                                                                              widget.groupID.toString(),
                                                                              _groupController.notCompletedTaskList[index].id.toString(),
                                                                            );
                                                                            getData();
                                                                            Navigator.pop(context);
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink()
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/date.png",
                                                                title: "Date",
                                                                data: DateFormat(
                                                                        'dd-MM-yyyy')
                                                                    .format(_groupController
                                                                        .notCompletedTaskList[
                                                                            index]
                                                                        .taskDate
                                                                        .toDate())),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/time.png",
                                                                title: "Time",
                                                                data: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(_groupController
                                                                        .notCompletedTaskList[
                                                                            index]
                                                                        .startTime)) +
                                                                    " to " +
                                                                    DateFormat('dd-MM-yyyy HH:mm').format(DateTime.parse(_groupController
                                                                        .notCompletedTaskList[
                                                                            index]
                                                                        .endTime))),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/duration.png",
                                                                title:
                                                                    "Task Duration",
                                                                data: _groupController
                                                                        .notCompletedTaskList[
                                                                            index]
                                                                        .duration +
                                                                    " hours"),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TaskDetailWidget(
                                                                icon:
                                                                    "assets/icons/home/points.png",
                                                                title:
                                                                    "Task Score Points",
                                                                data: _groupController
                                                                    .notCompletedTaskList[
                                                                        index]
                                                                    .taskScore),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                _groupController
                                                                            .notCompletedTaskList[
                                                                                index]
                                                                            .assignMembers
                                                                            .length >
                                                                        0
                                                                    ? Text(
                                                                        "Task assigned to:",
                                                                        style: headingSmall.copyWith(
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                                _groupController
                                                                            .notCompletedTaskList[
                                                                                index]
                                                                            .assignMembers
                                                                            .length >
                                                                        0
                                                                    ? SizedBox(
                                                                        width:
                                                                            74,
                                                                        child:
                                                                            Tooltip(
                                                                          message:
                                                                              assignedMembersString,
                                                                          child:
                                                                              AvatarStack(
                                                                            height:
                                                                                34,
                                                                            avatars: [
                                                                              for (var n = 0; n < _groupController.notCompletedTaskList[index].assignMembers.length; n++)
                                                                                _groupController.notCompletedTaskList[index].assignMembers[n].imageUrl == "" ? AssetImage("assets/images/man1.png") : NetworkImage(_groupController.notCompletedTaskList[index].assignMembers[n].imageUrl.toString()) as ImageProvider,
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ), //notCompletedTaskList is not assigned and worked on
                            _groupController.groupInfo[0].adminsList.any(
                                    (user) =>
                                        user.userID.toString() ==
                                        userData.userID.toString())
                                ? _groupController
                                            .toBeCompletedTaskList.isEmpty &&
                                        _groupController
                                            .completedTaskList.isEmpty &&
                                        _groupController
                                            .notCompletedTaskList.isEmpty
                                    ? SizedBox(
                                        height: 20.h,
                                      )
                                    : SizedBox.shrink()
                                : SizedBox.shrink(),
                            _groupController.groupInfo[0].adminsList.any(
                                    (user) =>
                                        user.userID.toString() ==
                                        userData.userID.toString())
                                ? _groupController
                                            .toBeCompletedTaskList.isEmpty &&
                                        _groupController
                                            .completedTaskList.isEmpty &&
                                        _groupController
                                            .notCompletedTaskList.isEmpty
                                    ? DelayedDisplay(
                                        delay: Duration(milliseconds: 600),
                                        slidingBeginOffset: Offset(0, 0),
                                        child: CustomButton(
                                          onTap: () async {
                                            bool available =
                                                await _groupController
                                                    .isGoalAvailable(
                                                        widget.groupID);
                                            available
                                                ? Get.to(() =>
                                                    CreateNewGroupTask(
                                                      groupID: widget.groupID,
                                                      groupTitle:
                                                          widget.groupTitle,
                                                    ))
                                                : errorPopUp(context,
                                                    "No goal has been set for this group. To create a new task in this group, you have to create a goal first.");
                                          },
                                          buttonText: "Create a new task",
                                        ),
                                      )
                                    : SizedBox.shrink()
                                : SizedBox.shrink(),
                            _groupController.groupInfo[0].adminsList.any(
                                    (user) =>
                                        user.userID.toString() ==
                                        userData.userID.toString())
                                ? _groupController
                                            .toBeCompletedTaskList.isEmpty &&
                                        _groupController
                                            .completedTaskList.isEmpty &&
                                        _groupController
                                            .notCompletedTaskList.isEmpty
                                    ? SizedBox()
                                    : SizedBox.shrink()
                                : SizedBox.shrink(),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    isFinish
                        ? Lottie.asset("assets/icons/partyPoppers.json",
                            repeat: false)
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
      floatingActionButton: isLoading
          ? SizedBox.shrink()
          : _groupController.groupInfo[0].adminsList.any((user) =>
                  user.userID.toString() == userData.userID.toString())
              ? _groupController.toBeCompletedTaskList.isNotEmpty ||
                      _groupController.completedTaskList.isNotEmpty ||
                      _groupController.notCompletedTaskList.isNotEmpty
                  ? FloatingActionButton(
                      backgroundColor: AppColors.buttonColor,
                      onPressed: () async {
                        bool available = await _groupController
                            .isGoalAvailable(widget.groupID);
                        available
                            ? Get.to(() => CreateNewGroupTask(
                                  groupID: widget.groupID,
                                  groupTitle: widget.groupTitle,
                                ))
                            : errorPopUp(context,
                                "No goal has been set for this group. To create a new task in this group, you have to create a goal first.");
                      },
                      child: Icon(Icons.add),
                    )
                  : SizedBox.shrink()
              : SizedBox.shrink(),
    );
  }
}
