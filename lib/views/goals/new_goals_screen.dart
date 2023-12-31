import 'package:cached_network_image/cached_network_image.dart';
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
  bool anyGroupWithNoGoal = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    await _goalController.getGoalPageData();
    anyGroupWithNoGoal = await _goalController.groupWithNoGoal();
    setState(() {
      anyGroupWithNoGoal;
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
    _goalController.goalList
        .sort((a, b) => b.goalAddedTime.compareTo(a.goalAddedTime));
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
                                indexJ++) {
                              if (userData.points[indexJ]['groupID'] ==
                                  _goalController.goalList[index].goalGroup) {
                                userData.points[indexJ]['point'].toString() ==
                                        "[]"
                                    ? achievedPoints = 0
                                    : achievedPoints = int.parse(userData
                                        .points[indexJ]['point']
                                        .toString());
                                break; // Stop searching once a match is found
                              }
                            }
                            Duration daysLeft;
                            daysLeft = _goalController.goalList[index].goalDate
                                .toDate()
                                .difference(DateTime.now());
                            bool expired = _goalController
                                .goalList[index].goalDate
                                .toDate()
                                .isBefore(DateTime.now());

                            _goalController.goalList[index].goalDate
                                    .toDate()
                                    .isBefore(DateTime.now())
                                ? _goalController.resetGroupPoints(
                                    _goalController.goalList[index].goalGroup)
                                : null;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: DelayedDisplay(
                                delay: Duration(milliseconds: 400),
                                slidingBeginOffset: Offset(0, 0),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: _goalController
                                            .goalList[index].goalDate
                                            .toDate()
                                            .isBefore(DateTime.now())
                                        ? Colors.red
                                        : (achievedPoints /
                                                    int.parse(_goalController
                                                        .goalList[index]
                                                        .goalPoints
                                                        .toString())) >=
                                                1.0
                                            ? Colors.green[900]
                                            : AppColors.buttonColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: DelayedDisplay(
                                    delay: Duration(milliseconds: 500),
                                    slidingBeginOffset: Offset(0, -1),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              // Adjust the radius as needed
                                              backgroundColor: Colors.grey,
                                              // You can set a default background color
                                              child: ClipOval(
                                                child: SizedBox(
                                                  height: 20 * 2,
                                                  width: 20 * 2,
                                                  child: _goalController
                                                              .goalList[index]
                                                              .goalGroupImage ==
                                                          null
                                                      ? Image.asset(
                                                          "assets/images/groupIcon.png",
                                                          // Replace with your asset image path
                                                          fit: BoxFit.fitHeight,
                                                        )
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              _goalController
                                                                  .goalList[
                                                                      index]
                                                                  .goalGroupImage
                                                                  .toString(),
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Text(
                                              _goalController
                                                  .goalList[index].goalGroupName
                                                  .toString(),
                                              style: headingMedium.copyWith(
                                                  color: Colors.white),
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _goalController
                                                    .goalList[index].goalTitle,
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
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            _goalController.groupList.isNotEmpty
                                                ? InkWell(
                                                    onTap: () {
                                                      confirmPopUp(context,
                                                          "Are you sure, you want to delete goal?",
                                                          () {
                                                        _goalController
                                                            .resetGroupPoints(
                                                                _goalController
                                                                    .goalList[
                                                                        index]
                                                                    .goalGroup);
                                                        _goalController
                                                            .deleteGoal(
                                                          _goalController
                                                              .goalList[index]
                                                              .goalGroup
                                                              .toString(),
                                                          _goalController
                                                              .goalList[index]
                                                              .goalID
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
                                            data: DateFormat('dd-MM-yyyy')
                                                .format(_goalController
                                                    .goalList[index].goalDate
                                                    .toDate())),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GoalDetailWidget(
                                            icon: "assets/icons/coin.png",
                                            title: "Points to achieve",
                                            data: _goalController
                                                    .goalList[index]
                                                    .goalPoints ??
                                                "0"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        expired
                                            ? SizedBox.shrink()
                                            : GoalDetailWidget(
                                                icon: "assets/icons/coin1.png",
                                                title: daysLeft.inDays < 1
                                                    ? "Hours remaining for achieving goal"
                                                    : "Days remaining for achieving goal",
                                                data: calculateDaysAndHours(
                                                    daysLeft)
                                                // daysLeft.inDays < 1
                                                //     ? daysLeft.inHours
                                                //         .toString()
                                                //     : daysLeft.inDays
                                                //             .toString() +
                                                //         " day " +
                                                //         daysLeft.inHours
                                                //             .toString() +
                                                //         " hours"
                                                ),
                                        expired
                                            ? SizedBox.shrink()
                                            : SizedBox(
                                                height: 10,
                                              ),
                                        expired
                                            ? SizedBox.shrink()
                                            : LikeBarWidget(
                                                image: userData.imageUrl,
                                                count:
                                                    achievedPoints.toString(),
                                                percent: (achievedPoints /
                                                    int.parse(_goalController
                                                        .goalList[index]
                                                        .goalPoints
                                                        .toString())),
                                                TotalCount: _goalController
                                                    .goalList[index].goalPoints
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
                            anyGroupWithNoGoal
                                ? Get.to(() => CreateNewTask())
                                : errorPopUp(context,
                                    "Goals are created for all current groups. To create a new goal, you have to create a new group first.");
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
                        anyGroupWithNoGoal
                            ? Get.to(() => CreateNewTask())
                            : errorPopUp(context,
                                "Goals are created for all current groups. To create a new goal, you have to create a new group first.");
                      },
                      child: Icon(Icons.add),
                    )
              : null,
    );
  }
}

String calculateDaysAndHours(Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours.remainder(24);

  String result = '';

  if (days > 0) {
    result += '$days day${days > 1 ? 's' : ''}';
    if (hours > 0) {
      result += ' and ';
    }
  }

  if (hours > 0) {
    result += '$hours hour${hours > 1 ? 's' : ''}';
  }

  return result.isNotEmpty
      ? result
      : 'Less than an hour'; // If duration is less than an hour
}
