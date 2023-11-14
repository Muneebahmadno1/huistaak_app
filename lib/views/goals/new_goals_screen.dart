import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/goals/create_new_task.dart';
import 'package:huistaak/views/goals/widgets/goal_detail_widget.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/goal_controller.dart';
import '../../widgets/like_bar_widget.dart';
import 'edit_goal.dart';

class NewGoalsScreen extends StatefulWidget {
  const NewGoalsScreen({super.key});

  @override
  State<NewGoalsScreen> createState() => _NewGoalsScreenState();
}

class _NewGoalsScreenState extends State<NewGoalsScreen> {
  final GoalController _goalController = Get.find<GoalController>();
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    await _goalController.getGoalPageData();
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
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            DelayedDisplay(
              delay: Duration(milliseconds: 300),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "New Goals",
                  style: headingLarge.copyWith(color: AppColors.buttonColor),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CircularProgressIndicator(),
                  ))
                : _goalController.goalList.isEmpty
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h),
                          child: Container(
                            child: Text("No goal for now"),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _goalController.goalList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 16),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            int achievedPoints = 0;
                            for (int indexJ = 0;
                                indexJ < userData.points.length;
                                indexJ++)
                              for (int index = 0;
                                  index < _goalController.goalList.length;
                                  index++) {
                                if (userData.points[indexJ]['groupID'] ==
                                    _goalController.goalList[index]
                                        ['goalGroup']) {
                                  userData.points[indexJ]['point'].toString() ==
                                          "[]"
                                      ? achievedPoints = 0
                                      : achievedPoints = int.parse(userData
                                          .points[indexJ]['point']
                                          .toString());
                                  break; // Stop searching once a match is found
                                }
                              }
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: DelayedDisplay(
                                    delay: Duration(milliseconds: 500),
                                    slidingBeginOffset: Offset(0, -1),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _goalController.goalList[index]
                                                    ['goalTitle'],
                                                style: headingMedium.copyWith(
                                                    color: Colors.white),
                                                maxLines: 2,
                                              ),
                                            ),
                                            _goalController.groupList.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      Get.to(() => EditGoal(
                                                            goalDetail:
                                                                _goalController
                                                                        .goalList[
                                                                    index],
                                                          ));
                                                    },
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            _goalController.groupList.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      confirmPopUp(context,
                                                          "Are you sure, you want to delete goal?",
                                                          () {
                                                        _goalController
                                                            .deleteGoal(
                                                          _goalController
                                                              .goalList[index]
                                                                  ['goalGroup']
                                                              .toString(),
                                                          _goalController
                                                              .goalList[index]
                                                                  ['goalID']
                                                              .toString(),
                                                        );
                                                        getData();
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : SizedBox.shrink()
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GoalDetailWidget(
                                            icon: "assets/icons/home/date.png",
                                            title: "Date",
                                            data: DateFormat('yyyy-MM-dd')
                                                .format(_goalController
                                                    .goalList[index]['goalDate']
                                                    .toDate())),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GoalDetailWidget(
                                            icon: "assets/icons/coin.png",
                                            title: "Points to achieve",
                                            data:
                                                _goalController.goalList[index]
                                                        ['goalPoints'] ??
                                                    "0"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LikeBarWidget(
                                            image: "assets/images/man1.png",
                                            count: achievedPoints.toString(),
                                            percent: (achievedPoints /
                                                int.parse(_goalController
                                                    .goalList[index]
                                                        ['goalPoints']
                                                    .toString())),
                                            TotalCount: _goalController
                                                .goalList[index]['goalPoints']
                                                .toString()),
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
                      ),
            _goalController.goalList.isEmpty
                ? Expanded(child: SizedBox())
                : SizedBox.shrink(),
            _goalController.groupList.isNotEmpty
                ? _goalController.goalList.isEmpty
                    ? DelayedDisplay(
                        delay: Duration(milliseconds: 600),
                        slidingBeginOffset: Offset(0, 0),
                        child: CustomButton(
                          onTap: () {
                            Get.to(() => CreateNewTask());
                          },
                          buttonText: "Set Goal for your Group",
                        ),
                      )
                    : SizedBox.shrink()
                : SizedBox.shrink(),
            _goalController.goalList.isEmpty
                ? Expanded(child: SizedBox())
                : SizedBox.shrink(),
          ],
        ),
      ),
      floatingActionButton: isLoading
          ? null
          : _goalController.groupList.isNotEmpty
              ? _goalController.goalList.isEmpty
                  ? null
                  : FloatingActionButton(
                      backgroundColor: AppColors.buttonColor,
                      onPressed: () {
                        Get.to(() => CreateNewTask());
                      },
                      child: Icon(Icons.add),
                    )
              : null,
    );
  }
}
