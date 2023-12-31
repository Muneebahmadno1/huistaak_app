import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../constants/app_images.dart';
import '../../../constants/custom_validators.dart';
import '../../../constants/global_variables.dart';
import '../../../controllers/data_controller.dart';
import '../../../controllers/group_controller.dart';
import '../../../controllers/group_setting_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../../helper/page_navigation.dart';
import '../../../models/member_model.dart';
import '../../../models/task_model.dart';
import '../../../models/user_model.dart';
import '../../../widgets/text_form_fields.dart';
import '../group_detail.dart';

class EditGroupTask extends StatefulWidget {
  final groupID;
  final groupTitle;
  final TaskModel taskDetails;

  const EditGroupTask(
      {super.key,
      required this.groupID,
      required this.groupTitle,
      required this.taskDetails});

  @override
  State<EditGroupTask> createState() => _EditGroupTaskState();
}

class _EditGroupTaskState extends State<EditGroupTask> {
  final GroupController _groupController = Get.find<GroupController>();
  final HomeController _dataController = Get.find<HomeController>();
  final NotificationController _notiController =
      Get.find<NotificationController>();
  final GroupSettingController _groupSettingController =
      Get.find<GroupSettingController>();
  TextEditingController taskNameEditingController = TextEditingController();
  int points = 1;
  bool timeError = false;
  bool visibility = false;
  bool endDateError = false;
  bool startTimeError = false;
  bool endTimeError = false;
  bool isLoading = false;
  List<UserModel> memberList = [];
  final GlobalKey<FormState> taskFormField = GlobalKey();

  bool loading = false;

  String? selectedValueStart;
  String? selectedValueEnd;

  List<String> timeItems = [];
  List<String> endTimeItems = [];

  getTimesDropDownData(DateTime date) {
    setState(() {
      timeItems.clear();
      selectedValueStart = null;
    });
    print(date);
    DateTime now = DateTime.now();

    // Check if the provided date is the current day
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      // Calculate the next quarter-hour from the current time
      int nextQuarter = ((now.minute / 15).ceil() * 15) % 60;
      DateTime startTime =
          DateTime(now.year, now.month, now.day, now.hour, nextQuarter);

      // Add times to the list until the end of the day
      while (startTime.day == now.day &&
          (startTime.hour < 23 || startTime.minute < 45)) {
        timeItems.add(DateFormat('yyyy-MM-dd HH:mm').format(startTime));
        startTime = startTime.add(Duration(minutes: 15));
      }
    } else {
      for (int i = 0; i < 1440; i += 15)
        timeItems.add(DateFormat('yyyy-MM-dd HH:mm')
            .format(date.add(Duration(minutes: i))));
    }
  }

  getEndTimesDropDownData(DateTime date) {
    setState(() {
      endTimeItems.clear();
      selectedValueEnd = null;
    });
    print(date);
    DateTime now = DateTime.now();

    // Check if the provided date is the current day
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      // Calculate the next quarter-hour from the current time
      int nextQuarter = ((now.minute / 15).ceil() * 15) % 60;
      DateTime startTime =
          DateTime(now.year, now.month, now.day, now.hour, nextQuarter);

      // Add times to the list until the end of the day
      while (startTime.day == now.day &&
          (startTime.hour < 23 || startTime.minute < 45)) {
        endTimeItems.add(DateFormat('yyyy-MM-dd HH:mm').format(startTime));
        startTime = startTime.add(Duration(minutes: 15));
      }
    } else {
      for (int i = 0; i < 1440; i += 15)
        endTimeItems.add(DateFormat('yyyy-MM-dd HH:mm')
            .format(date.add(Duration(minutes: i))));
    }
  }

  getData() async {
    setState(() {
      loading = true;
      taskNameEditingController.text = widget.taskDetails.taskTitle.toString();
      _dataController.selectedStartDate = widget.taskDetails.taskDate.toDate();
      _dataController.selectedEndDate =
          DateFormat('yyyy-MM-dd').parse(widget.taskDetails.endTime);
      points = int.parse(widget.taskDetails.taskScore);

      _dataController.startTime.value = widget.taskDetails.startTime.toString();
      _dataController.endTime.value = widget.taskDetails.endTime.toString();
      for (int i = 0; i < widget.taskDetails.assignMembers.length; i++)
        _dataController.assignTaskMember
            .addAll({widget.taskDetails.assignMembers[i]});
    });
    getTimesDropDownData(_dataController.selectedStartDate!);
    getEndTimesDropDownData(_dataController.selectedEndDate!);
    await _dataController.getTaskMember(widget.groupID);
    for (int i = 0; i < _dataController.userList.length; i++) {
      memberList.add(await _groupSettingController
          .fetchUser(_dataController.userList[i].userID.toString()));
    }
    setState(() {
      loading = false;
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
          pageTitle: "Edit Group Task",
          onTap: () {
            _dataController.assignTaskMember.clear();
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.buttonColor,
          ),
        ),
      ),
      body: Form(
        key: taskFormField,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 300),
                  slidingBeginOffset: Offset(0, -1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Task Title",
                      style:
                          headingSmall.copyWith(color: AppColors.buttonColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  slidingBeginOffset: Offset(0, 0),
                  child: AuthTextField(
                    validator: (value) =>
                        CustomValidator.isEmptyUserName(value),
                    controller: taskNameEditingController,
                    hintText: "Clean Garden",
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Start Date for task",
                      style:
                          headingSmall.copyWith(color: AppColors.buttonColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ListTile(
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      // Adjust padding
                      leading: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.buttonColor,
                      ),
                      // Add a calendar icon in the leading position
                      title: Text(
                        (_dataController.selectedStartDate) == null
                            ? 'Select start date'
                            : '${DateFormat.yMMMd().format((_dataController.selectedStartDate)!)}',
                        style: bodyNormal,
                      ),
                      // Format the date
                      trailing:
                          Icon(Icons.arrow_drop_down, color: Colors.black),
                      onTap: () async {
                        await _showDatePicker(context, "StartDate");
                        setState(() {
                          _dataController.selectedEndDate = null;
                          _dataController.endTime.value = "";
                          visibility = false;
                        });
                        getTimesDropDownData(
                            _dataController.selectedStartDate!);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "End Date for task",
                      style:
                          headingSmall.copyWith(color: AppColors.buttonColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: ListTile(
                      horizontalTitleGap: 0,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      // Adjust padding
                      leading: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.buttonColor,
                      ),
                      // Add a calendar icon in the leading position
                      title: Text(
                        (_dataController.selectedEndDate) == null
                            ? 'Select end date'
                            : '${DateFormat.yMMMd().format((_dataController.selectedEndDate)!)}',
                        style: bodyNormal,
                      ),
                      // Format the date
                      trailing:
                          Icon(Icons.arrow_drop_down, color: Colors.black),
                      onTap: () async {
                        _dataController.selectedStartDate == null
                            ? errorPopUp(context, "Select start date first")
                            : await _showDatePicker(context, "EndDate");
                        setState(() {
                          visibility = false;
                        });
                        getEndTimesDropDownData(
                            _dataController.selectedEndDate!);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: Duration(milliseconds: 800),
                  slidingBeginOffset: Offset(0, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "Start Time",
                              style: headingSmall.copyWith(
                                  color: AppColors.buttonColor),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Container(
                                height: 50,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        Icon(Icons.access_time_outlined),
                                        // : SizedBox.shrink(),
                                        // (widget.dropDownTitle == 'Start Time' ||
                                        //     widget.dropDownTitle == 'End Time')
                                        //     ?
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                            widget.taskDetails.startTime
                                                        .toString()
                                                        .split(' ')[1] ==
                                                    ""
                                                ? "End Time"
                                                : widget.taskDetails.startTime
                                                    .toString()
                                                    .split(' ')[1],
                                            style: bodyNormal),
                                      ],
                                    ),
                                    items: timeItems
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Center(
                                                child: Text(
                                                  item.split(' ')[1],
                                                  style: bodyNormal,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValueStart,
                                    onChanged: (value) {
                                      setState(() {
                                        // if (widget.dropDownTitle == 'Start Time') {
                                        _dataController.startTime.value =
                                            value!;
                                        // } else {
                                        //   _dataController.endTime.value = value!;
                                        // }
                                        selectedValueStart = value as String;
                                        visibility = false;
                                      });
                                    },
                                    iconStyleData: IconStyleData(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 10),
                                      elevation: 2,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      padding: null,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12)),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2, color: Colors.white24)),
                                      maxHeight: 135,
                                      elevation: 8,
                                      offset: const Offset(-1, -3),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            MaterialStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'MontserratRegular'),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "End Time",
                              style: headingSmall.copyWith(
                                  color: AppColors.buttonColor),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Container(
                                height: 50,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    isExpanded: true,
                                    hint: Row(
                                      children: [
                                        // (widget.dropDownTitle == 'Start Time' ||
                                        //     widget.dropDownTitle == 'End Time')
                                        //     ?
                                        Icon(Icons.access_time_outlined),
                                        // : SizedBox.shrink(),
                                        // (widget.dropDownTitle == 'Start Time' ||
                                        //     widget.dropDownTitle == 'End Time')
                                        //     ?
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                            widget.taskDetails.endTime
                                                        .toString()
                                                        .split(' ')[1] ==
                                                    ""
                                                ? "End Time"
                                                : widget.taskDetails.endTime
                                                    .toString()
                                                    .split(' ')[1],
                                            style: bodyNormal),
                                      ],
                                    ),
                                    items: endTimeItems
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Center(
                                                child: Text(
                                                  item.split(' ')[1],
                                                  style: bodyNormal,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValueEnd,
                                    onChanged: (value) {
                                      setState(() {
                                        // if (widget.dropDownTitle == 'Start Time') {
                                        _dataController.endTime.value = value!;
                                        // } else {
                                        //   _dataController.endTime.value = value!;
                                        // }
                                        selectedValueEnd = value as String;
                                      });
                                    },
                                    iconStyleData: IconStyleData(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.black,
                                      ),
                                    ),
                                    buttonStyleData: const ButtonStyleData(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 10),
                                      elevation: 2,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      padding: null,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(12)),
                                          color: Colors.white,
                                          border: Border.all(
                                              width: 2, color: Colors.white24)),
                                      maxHeight: 135,
                                      elevation: 8,
                                      offset: const Offset(-1, -3),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            MaterialStateProperty.all<double>(
                                                6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(
                                                true),
                                      ),
                                    ),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontFamily: 'MontserratRegular'),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                  ),
                                ),
                              ),
                              // CustomDropDown(
                              //   dateForTime: _dataController.selectedStartDate!,
                              //   dropDownTitle:
                              //       widget.taskDetails['endTime'].toString(),
                              // ),
                            ),
                          ],
                        ),
                        // TimePickerWidget(
                        //   index: 2,
                        //   title: 'End Time',
                        // ),
                      ),
                    ],
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 900),
                  slidingBeginOffset: Offset(0, -1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Task Score",
                      style:
                          headingSmall.copyWith(color: AppColors.buttonColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  slidingBeginOffset: Offset(0, 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.buttonColor.withOpacity(0.2),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ZoomTapAnimation(
                          onTap: () {
                            if (points >= 2) {
                              setState(() {
                                points = points - 1;
                              });
                            }
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ),
                        Text(
                          "$points Points",
                          style: headingSmall,
                        ),
                        ZoomTapAnimation(
                          onTap: () {
                            setState(() {
                              points = points + 1;
                            });
                          },
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.buttonColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1100),
                  slidingBeginOffset: Offset(0, -1),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Assign Task to Group Members:",
                      style: headingSmall,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                loading
                    ? SizedBox.shrink()
                    : Container(
                        height: 10.h,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _dataController.userList.length,
                            itemBuilder: (context, a) {
                              return InkWell(
                                onTap: () {
                                  // _dataController.assignTaskMember.removeAt(a);

                                  setState(() {
                                    if (_dataController.assignTaskMember.any(
                                        (map) =>
                                            map.userID ==
                                            _dataController
                                                .userList[a].userID)) {
                                      _dataController.assignTaskMember
                                          .removeWhere((map) =>
                                              map.userID ==
                                              _dataController
                                                  .userList[a].userID);
                                    } else {
                                      _dataController.assignTaskMember.add(
                                          MemberModel(
                                              displayName: _dataController
                                                  .userList[a].displayName,
                                              imageUrl: _dataController
                                                  .userList[a].imageUrl,
                                              userID: _dataController
                                                  .userList[a].userID));
                                    }
                                  });
                                },
                                child: SizedBox(
                                  height: 10.h,
                                  width: 20.w,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            // Adjust the radius as needed
                                            backgroundColor: Colors.grey,
                                            // You can set a default background color
                                            child: ClipOval(
                                              child: SizedBox(
                                                height: 30 * 2,
                                                width: 30 * 2,
                                                child: memberList[a].imageUrl ==
                                                        ""
                                                    ? Image.asset(
                                                        AppImages.profileImage,
                                                        // Replace with your asset image path
                                                        fit: BoxFit.fitHeight,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: memberList[a]
                                                            .imageUrl,
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Text(_dataController
                                              .userList[a].displayName
                                              .toString()),
                                        ],
                                      ),
                                      _dataController.assignTaskMember.any(
                                              (person) =>
                                                  person.userID ==
                                                  _dataController
                                                      .userList[a].userID)
                                          ? Positioned(
                                              right: 2,
                                              bottom: 20,
                                              child: Image.asset(
                                                "assets/images/added.png",
                                                height: 20,
                                              ),
                                            )
                                          : Positioned(
                                              right: 2,
                                              bottom: 20,
                                              child: Image.asset(
                                                "assets/images/addNow.png",
                                                height: 20,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                SizedBox(
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1300),
                  slidingBeginOffset: Offset(0, 0),
                  child: ZoomTapAnimation(
                    onTap: () async {
                      // String startTime = _dataController.startTime.value;
                      // String endTime = _dataController.endTime.value;
                      // bool pastTime = DateTime.parse(startTime)
                      //     .isAfter(DateTime.parse(endTime));
                      // print(_dataController.startTime.value);
                      // print(_dataController.endTime.value);
                      // print(pastTime);
                      // if (taskFormField.currentState!.validate()) {
                      //   if (_dataController.assignTaskMember.isNotEmpty) {
                      //     if (_dataController.startTime.value ==
                      //             _dataController.endTime.value ||
                      //         _dataController.startTime.value == "" ||
                      //         _dataController.endTime.value == "" ||
                      //         pastTime) {
                      //       setState(() {
                      //         timeError = true;
                      //       });
                      //     } else {
                      //       setState(() {
                      //         timeError = false;
                      //         isLoading = true;
                      //       });
                      //       await _groupController.editGroupTask(
                      //           widget.taskDetails.id.toString(),
                      //           widget.groupID,
                      //           taskNameEditingController.text,
                      //           _dataController.selectedStartDate,
                      //           _dataController.startTime.toString(),
                      //           _dataController.endTime.toString(),
                      //           points.toString(),
                      //           _dataController.assignTaskMember);
                      //
                      //       _dataController.assignTaskMember.clear();
                      //       PageTransition.pageBackNavigation(
                      //           page: GroupDetail(
                      //         groupTitle: widget.groupTitle,
                      //         groupID: widget.groupID,
                      //       ));
                      //       setState(() {
                      //         isLoading = false;
                      //       });
                      //     }
                      //   } else {
                      //     errorPopUp(context,
                      //         "Can't add task without assigning it to any member");
                      //   }
                      // }

                      setState(() {
                        visibility = true;
                      });
                      if (_dataController.startTime.value != "" &&
                          _dataController.endTime.value != "") {
                        String startTime = _dataController.startTime.value;
                        String endTime = _dataController.endTime.value;

                        setState(() {
                          endDateError = DateTime.parse(startTime)
                              .isAfter(DateTime.parse(endTime));
                          startTimeError = false;
                          endTimeError = false;
                        });
                        if (endDateError == false) {
                          if (_dataController.startTime.value != "") {
                            final now = DateTime.now();
                            String startTime = _dataController.startTime.value;
                            setState(() {
                              startTimeError =
                                  DateTime.parse(startTime).isBefore(now);
                            });
                          }
                          if (_dataController.endTime.value != "") {
                            final now = DateTime.now();
                            String endTime = _dataController.endTime.value;
                            setState(() {
                              endTimeError =
                                  DateTime.parse(endTime).isBefore(now);
                            });
                          }
                        }
                      }
                      if (taskFormField.currentState!.validate()) {
                        if (_dataController.selectedStartDate != null &&
                            _dataController.selectedEndDate != null &&
                            _dataController.startTime.value != "" &&
                            _dataController.endTime.value != "") {
                          if (_dataController.assignTaskMember.isNotEmpty) {
                            if (_dataController.startTime.value ==
                                    _dataController.endTime.value ||
                                _dataController.startTime.value == "" ||
                                _dataController.endTime.value == "" ||
                                endDateError ||
                                startTimeError ||
                                endTimeError) {
                              setState(() {
                                timeError = true;
                              });
                              errorPopUp(
                                  context,
                                  startTimeError
                                      ? "Start Time of task is already passed"
                                      : startTimeError
                                          ? "End Time of task is already passed"
                                          : endDateError
                                              ? "End time should be after start time"
                                              : "Start and End Time can't be same");
                            } else {
                              setState(() {
                                timeError = false;
                                isLoading = true;
                              });
                              // await _groupController.addGroupTask(
                              //     widget.groupID,
                              //     taskNameEditingController.text,
                              //     _dataController.selectedStartDate,
                              //     _dataController.startTime.toString(),
                              //     _dataController.endTime.toString(),
                              //     points.toString(),
                              //     _dataController.assignTaskMember);
                              await _groupController.editGroupTask(
                                  widget.taskDetails.id.toString(),
                                  widget.groupID,
                                  taskNameEditingController.text,
                                  _dataController.selectedStartDate,
                                  _dataController.startTime.toString(),
                                  _dataController.endTime.toString(),
                                  points.toString(),
                                  _dataController.assignTaskMember);
                              _dataController.assignTaskMember.clear();
                              _dataController.selectedEndDate = null;
                              _dataController.selectedStartDate = null;
                              PageTransition.pageBackNavigation(
                                  page: GroupDetail(
                                groupTitle: widget.groupTitle,
                                groupID: widget.groupID,
                              ));
                              setState(() {
                                isLoading = false;
                              });
                            }
                          } else {
                            errorPopUp(context,
                                "Can't add task without assigning it to any member");
                          }
                        } else {
                          errorPopUp(
                              context,
                              _dataController.selectedStartDate == null
                                  ? "Can't add task without selecting start date"
                                  : _dataController.selectedEndDate == null
                                      ? "Can't add task without selecting end date"
                                      : _dataController.startTime.value == ""
                                          ? "Can't add task without selecting start time"
                                          : "Can't add task without selecting end time");
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Text(
                                  "Save Changes",
                                  style: headingSmall.copyWith(
                                      color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context, from) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate: from == "EndDate"
          ? _dataController.selectedStartDate!
          : DateTime.now(),
      firstDate: from == "EndDate"
          ? _dataController.selectedStartDate!
          : DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.buttonColor, // Change primary color
            hintColor: AppColors.buttonColor, // Change accent color
            colorScheme: ColorScheme.light(
                primary: AppColors.buttonColor,
                background: Colors.black // Change background color
                ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null &&
        pickedDate !=
            (from == "EndDate"
                ? _dataController.selectedEndDate
                : _dataController.selectedStartDate)) {
      setState(() {
        (from == "EndDate"
            ? _dataController.selectedEndDate = pickedDate
            : _dataController.selectedStartDate = pickedDate);
      });
    }
  }
}
