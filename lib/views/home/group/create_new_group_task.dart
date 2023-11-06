import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/helper/page_navigation.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../constants/custom_validators.dart';
import '../../../constants/global_variables.dart';
import '../../../controllers/data_controller.dart';
import '../../../controllers/group_controller.dart';
import '../../../controllers/notification_controller.dart';
import '../../../widgets/date_picker.dart';
import '../../../widgets/text_form_fields.dart';
import '../group_detail.dart';
import 'assign_task_member.dart';

class CreateNewGroupTask extends StatefulWidget {
  final groupID;
  final groupTitle;

  const CreateNewGroupTask(
      {super.key, required this.groupID, required this.groupTitle});

  @override
  State<CreateNewGroupTask> createState() => _CreateNewGroupTaskState();
}

class _CreateNewGroupTaskState extends State<CreateNewGroupTask> {
  final GroupController _groupController = Get.find<GroupController>();
  final HomeController _dataController = Get.find<HomeController>();
  final NotificationController _notiController =
      Get.find<NotificationController>();
  TextEditingController taskNameEditingController = TextEditingController();
  int points = 1;
  bool timeError = false;
  bool isLoading = false;
  final GlobalKey<FormState> taskFormField = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Create a new group task",
          onTap: () {
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
                      "Date for task",
                      style:
                          headingSmall.copyWith(color: AppColors.buttonColor),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DelayedDisplay(
                    delay: Duration(milliseconds: 600),
                    slidingBeginOffset: Offset(0, 0),
                    child: DatePickerWidget(
                      from: 'task',
                    )),
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
                              child: CustomDropDown(
                                dropDownTitle: "Start Time",
                              ),
                            ),
                          ],
                        ),
                        // TimePickerWidget(
                        //   index: 1,
                        //   title: 'Start Time',
                        // ),
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
                              child: CustomDropDown(
                                dropDownTitle: "End Time",
                              ),
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
                timeError
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              "Start and End Time can't be same",
                              style:
                                  TextStyle(color: Colors.red[800], height: 3),
                            ),
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                const SizedBox(height: 10),
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
                DelayedDisplay(
                  delay: Duration(milliseconds: 1200),
                  slidingBeginOffset: Offset(1, 0),
                  child: Obx(
                    () => Row(
                      children: [
                        for (int a = 0;
                            a < _dataController.assignTaskMember.length;
                            a++)
                          InkWell(
                            onTap: () {
                              _dataController.assignTaskMember.removeAt(a);
                            },
                            child: SizedBox(
                              height: 70,
                              width: 70,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/man1.jpg"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        ZoomTapAnimation(
                          onTap: () {
                            Get.to(() => AssignMember(
                                  from: 'groupTask',
                                  groupID: widget.groupID,
                                ));
                          },
                          child: Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/dotted_border.png"))),
                              child: Icon(
                                Icons.add,
                                color: AppColors.buttonColor,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1300),
                  slidingBeginOffset: Offset(0, 0),
                  child: ZoomTapAnimation(
                    onTap: () async {
                      if (taskFormField.currentState!.validate()) {
                        if (_dataController.startTime.value ==
                            _dataController.endTime.value) {
                          setState(() {
                            timeError = true;
                          });
                        } else {
                          setState(() {
                            timeError = false;
                            isLoading = true;
                          });
                          await _groupController.addGroupTask(
                              widget.groupID,
                              taskNameEditingController.text,
                              _dataController.selectedDate,
                              _dataController.startTime.toString(),
                              _dataController.endTime.toString(),
                              points.toString(),
                              _dataController.assignTaskMember);
                          for (int i = 0;
                              i < _dataController.assignTaskMember.length;
                              i++) {
                            await _notiController.sendNotification(
                                _dataController.assignTaskMember[i]['userID']
                                    .toString(),
                                _dataController.endTime.toString(),
                                widget.groupTitle);
                          }

                          _dataController.assignTaskMember.clear();
                          PageTransition.pageBackNavigation(
                              page: GroupDetail(
                            groupTitle: widget.groupTitle,
                            groupID: widget.groupID,
                          ));
                          setState(() {
                            isLoading = false;
                          });
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
                                  "Add Task",
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
}
