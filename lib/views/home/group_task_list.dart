import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/widgets/task_detail_widget.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';
import '../../controllers/group_setting_controller.dart';
import '../../widgets/custom_widgets.dart';

class GroupTaskList extends StatefulWidget {
  final groupID;
  const GroupTaskList({super.key, required this.groupID});

  @override
  State<GroupTaskList> createState() => _GroupTaskListState();
}

class _GroupTaskListState extends State<GroupTaskList> {
  final GroupSettingController _groupSettingController =
      Get.find<GroupSettingController>();
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    await _groupSettingController.getGroupTaskList(widget.groupID.toString());
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
        title: CustomAppBar(
          pageTitle: "Group Task List",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.buttonColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 6,
              ),
              isLoading
                  ? Center(
                      child: Padding(
                      padding: EdgeInsets.only(top: 35.h),
                      child: CircularProgressIndicator(color: Colors.white),
                    ))
                  : _groupSettingController.taskList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 35.h),
                            child: Container(
                              child: Text("No tasks for now"),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _groupSettingController.taskList.length,
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: DelayedDisplay(
                                    delay: Duration(milliseconds: 600),
                                    slidingBeginOffset: Offset(0, -1),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _groupSettingController
                                                .taskList[index].taskTitle,
                                            style: headingLarge.copyWith(
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TaskDetailWidget(
                                            icon: "assets/icons/home/date.png",
                                            title: "Date",
                                            data: DateFormat('yyyy-MM-dd')
                                                .format(_groupSettingController
                                                    .taskList[index].taskDate
                                                    .toDate())),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TaskDetailWidget(
                                            icon: "assets/icons/home/time.png",
                                            title: "Time",
                                            data: _groupSettingController
                                                    .taskList[index].startTime +
                                                " to " +
                                                _groupSettingController
                                                    .taskList[index].endTime),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TaskDetailWidget(
                                            icon:
                                                "assets/icons/home/duration.png",
                                            title: "Task Duration",
                                            data: "08 hours"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TaskDetailWidget(
                                            icon:
                                                "assets/icons/home/points.png",
                                            title: "Task Score Points",
                                            data: _groupSettingController
                                                .taskList[index].taskScore),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
