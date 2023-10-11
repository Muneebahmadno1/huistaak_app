import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/widgets/custom_widgets.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../constants/global_variables.dart';
import '../../../widgets/date_picker.dart';
import '../../../widgets/text_form_fields.dart';
import '../../../widgets/time_picker.dart';
import 'add_member.dart';

class CreateNewGroupTask extends StatefulWidget {
  const CreateNewGroupTask({super.key});

  @override
  State<CreateNewGroupTask> createState() => _CreateNewGroupTaskState();
}

class _CreateNewGroupTaskState extends State<CreateNewGroupTask> {
  int points = 1;

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
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                  style: headingSmall,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DelayedDisplay(
              delay: Duration(milliseconds: 400),
              slidingBeginOffset: Offset(0, 0),
              child: AuthTextField(
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
                  style: headingSmall,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DelayedDisplay(
                delay: Duration(milliseconds: 600),
                slidingBeginOffset: Offset(0, 0),
                child: DatePickerWidget()),
            const SizedBox(height: 20),
            DelayedDisplay(
              delay: Duration(milliseconds: 700),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Time for task",
                  style: headingSmall,
                ),
              ),
            ),
            const SizedBox(height: 10),
            DelayedDisplay(
              delay: Duration(milliseconds: 800),
              slidingBeginOffset: Offset(0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TimePickerWidget(
                      index: 1,
                      title: 'Start Time',
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TimePickerWidget(
                      index: 2,
                      title: 'End Time',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DelayedDisplay(
              delay: Duration(milliseconds: 900),
              slidingBeginOffset: Offset(0, -1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Task Score",
                  style: headingSmall,
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
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black26)),
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
              child: Row(
                children: [
                  SizedBox(
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
                                image: AssetImage("assets/images/man1.jpg"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 2,
                          bottom: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white)),
                            child: Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      Get.to(() => AddMember());
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
            SizedBox(
              height: 30,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: 1300),
              slidingBeginOffset: Offset(0, 0),
              child: CustomButton(
                onTap: () {},
                buttonText: "Add task",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
