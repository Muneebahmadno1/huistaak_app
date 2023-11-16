import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../controllers/data_controller.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/goal_controller.dart';
import '../../helper/collections.dart';
import '../../helper/page_navigation.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/text_form_fields.dart';
import '../home/bottom_nav_bar.dart';

class EditGoal extends StatefulWidget {
  final goalDetail;

  const EditGoal({super.key, required this.goalDetail});

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  final GoalController _goalController = Get.find<GoalController>();
  final HomeController _dataController = Get.find<HomeController>();
  TextEditingController goalNameEditingController = TextEditingController();
  TextEditingController goalPointsEditingController = TextEditingController();
  final GlobalKey<FormState> goalFormField = GlobalKey();
  int points = 1;
  List<dynamic> groupList = [];
  late String _dropDownValue;
  bool isLoading = false;
  bool editLoading = false;

  getDataGoal() async {
    setState(() {
      isLoading = true;
      goalNameEditingController.text =
          widget.goalDetail['goalTitle'].toString();
      goalPointsEditingController.text =
          widget.goalDetail['goalPoints'].toString();
      _dataController.goalSelectedDate = widget.goalDetail['goalDate'].toDate();
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
        _dropDownValue = widget.goalDetail['goalGroup'].toString();
        ;
      } else {
        _dropDownValue = "567guhjk67";
      }
      print("_dropDownValue");
      print(_dropDownValue);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataGoal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Edit goal",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Form(
              key: goalFormField,
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
                            "Goal Title",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 400),
                        slidingBeginOffset: Offset(0, 0),
                        child: AuthTextField(
                          controller: goalNameEditingController,
                          validator: (value) =>
                              CustomValidator.isEmptyUserName(value),
                          hintText: "Going to the cinema",
                        ),
                      ),
                      const SizedBox(height: 20),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 500),
                        slidingBeginOffset: Offset(0, -1),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Date for goal",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DelayedDisplay(
                          delay: Duration(milliseconds: 600),
                          slidingBeginOffset: Offset(0, 0),
                          child: DatePickerWidget(
                            from: "goal",
                          )),
                      const SizedBox(height: 20),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 300),
                        slidingBeginOffset: Offset(0, -1),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Goal Points",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 400),
                        slidingBeginOffset: Offset(0, 0),
                        child: AuthTextField(
                          isNumber: true,
                          controller: goalPointsEditingController,
                          validator: (value) => CustomValidator.isEmpty(value),
                          hintText: "No. of points to achieve goal",
                        ),
                      ),
                      // DelayedDisplay(
                      //   delay: Duration(milliseconds: 1000),
                      //   slidingBeginOffset: Offset(0, 0),
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(horizontal: 50),
                      //     width: double.infinity,
                      //     height: 60,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(50),
                      //       color: AppColors.buttonColor.withOpacity(0.2),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         ZoomTapAnimation(
                      //           onTap: () {
                      //             if (points >= 10) {
                      //               setState(() {
                      //                 points = points - 10;
                      //               });
                      //             }
                      //           },
                      //           child: SizedBox(
                      //             height: 40,
                      //             width: 40,
                      //             child: Icon(
                      //               Icons.arrow_back_ios_new,
                      //               color: AppColors.buttonColor,
                      //             ),
                      //           ),
                      //         ),
                      //         Text(
                      //           "$points Points",
                      //           style: headingSmall,
                      //         ),
                      //         ZoomTapAnimation(
                      //           onTap: () {
                      //             setState(() {
                      //               points = points + 10;
                      //             });
                      //           },
                      //           child: SizedBox(
                      //             height: 40,
                      //             width: 40,
                      //             child: Icon(
                      //               Icons.arrow_forward_ios,
                      //               color: AppColors.buttonColor,
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      // DelayedDisplay(
                      //   delay: Duration(milliseconds: 500),
                      //   slidingBeginOffset: Offset(0, -1),
                      //   child: Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       "Goal for group",
                      //       style: headingSmall.copyWith(
                      //           color: AppColors.buttonColor),
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 10),
                      //
                      // DelayedDisplay(
                      //   delay: Duration(milliseconds: 500),
                      //   slidingBeginOffset: Offset(0, -1),
                      //   child: Container(
                      //     height: 56,
                      //     decoration: BoxDecoration(
                      //       color: AppColors.buttonColor.withOpacity(0.2),
                      //       borderRadius: BorderRadius.circular(40),
                      //     ),
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(
                      //           left: 20.0, right: 20.0, top: 3),
                      //       child: DropdownButton(
                      //         borderRadius: BorderRadius.circular(20),
                      //         underline: SizedBox(),
                      //         hint: Text(
                      //           _dropDownValue,
                      //           style: bodyNormal,
                      //         ),
                      //         value: _dropDownValue,
                      //         isExpanded: true,
                      //         iconSize: 30.0,
                      //         style: bodyNormal,
                      //         items: groupList.map(
                      //           (val) {
                      //             return DropdownMenuItem<String>(
                      //               value: val['groupID'],
                      //               child: Text(val['groupName']),
                      //             );
                      //           },
                      //         ).toList(),
                      //         onChanged: (val) async {
                      //           setState(
                      //             () {
                      //               _dropDownValue = val!;
                      //               print(val);
                      //               print(_dropDownValue);
                      //             },
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 15.h,
                      ),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 1100),
                        slidingBeginOffset: Offset(0, 0),
                        child: ZoomTapAnimation(
                          onTap: () async {
                            HapticFeedback.heavyImpact();
                            if (goalFormField.currentState!.validate()) {
                              setState(() {
                                editLoading = true;
                              });
                              await _goalController.editGroupGoal(
                                widget.goalDetail['goalID'].toString(),
                                _dropDownValue.toString(),
                                goalNameEditingController.text,
                                _dataController.goalSelectedDate,
                                _dataController.startTime.toString(),
                                _dataController.assignGoalMember,
                                goalPointsEditingController.text.toString(),
                              );
                              _dataController.assignGoalMember.clear();
                              Get.find<GeneralController>()
                                  .onBottomBarTapped(1);
                              PageTransition.pageProperNavigation(
                                  page: CustomBottomNavBar(
                                pageIndex: 1,
                              ));
                            }
                            setState(() {
                              editLoading = false;
                            });
                          },
                          onLongTap: () {},
                          enableLongTapRepeatEvent: false,
                          longTapRepeatDuration:
                              const Duration(milliseconds: 100),
                          begin: 1.0,
                          end: 0.93,
                          beginDuration: const Duration(milliseconds: 20),
                          endDuration: const Duration(milliseconds: 120),
                          beginCurve: Curves.decelerate,
                          endCurve: Curves.fastOutSlowIn,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: editLoading
                                  ? Center(
                                      child: Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    ))
                                  : Center(
                                      child: Text("Save Changes",
                                          style: bodyLarge.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    )),
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
