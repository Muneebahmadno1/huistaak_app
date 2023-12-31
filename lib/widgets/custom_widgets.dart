import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/app_images.dart';
import '../constants/global_variables.dart';
import '../controllers/data_controller.dart';
import '../helper/page_navigation.dart';

class CustomButton extends StatefulWidget {
  final String? buttonText;
  final Function onTap;

  const CustomButton({Key? key, this.buttonText, required this.onTap})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ZoomTapAnimation(
        onTap: () {
          HapticFeedback.heavyImpact();
          widget.onTap();
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
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.buttonColor,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(widget.buttonText.toString(),
                  style: bodyLarge.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            )),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  final String pageTitle;
  final Function onTap;
  final Widget? leadingButton;

  const CustomAppBar(
      {Key? key,
      required this.pageTitle,
      required this.onTap,
      this.leadingButton})
      : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ZoomTapAnimation(
            onTap: () {
              widget.onTap();
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
            child:
                Container(height: 30, width: 30, child: widget.leadingButton),
          ),
          Text(
            widget.pageTitle,
            style: headingMedium.copyWith(
                fontFamily: "MontserratBold", color: AppColors.buttonColor),
          ),
          SizedBox(
            width: 40,
          ),
        ],
      ),
    );
  }
}

class CustomDropDown extends StatefulWidget {
  final DateTime dateForTime;
  final String dropDownTitle;

  const CustomDropDown(
      {Key? key, required this.dropDownTitle, required this.dateForTime})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final HomeController _dataController = Get.find<HomeController>();

  String? selectedValue;

  List<String> timeItems = [];
  getTimesDropDownData() {
    for (int i = 0; i < 24; i++)
      timeItems.add(DateFormat('yyyy-MM-dd HH:mm')
          .format(DateTime.now().add(Duration(hours: i))));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimesDropDownData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              (widget.dropDownTitle == 'Start Time' ||
                      widget.dropDownTitle == 'End Time')
                  ? Icon(Icons.access_time_outlined)
                  : SizedBox.shrink(),
              (widget.dropDownTitle == 'Start Time' ||
                      widget.dropDownTitle == 'End Time')
                  ? SizedBox(
                      width: 8,
                    )
                  : SizedBox.shrink(),
              Text(widget.dropDownTitle,
                  style: bodyNormal.copyWith(
                      fontSize: 12, color: Colors.grey[700])),
            ],
          ),
          items: timeItems
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                      child: Text(
                        item,
                        style: bodyNormal,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              if (widget.dropDownTitle == 'Start Time') {
                _dataController.startTime.value = value!;
              } else {
                _dataController.endTime.value = value!;
              }
              selectedValue = value as String;
            });
          },
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black,
            ),
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(left: 5, right: 10),
            elevation: 2,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: null,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white24)),
            maxHeight: 135,
            elevation: 8,
            offset: const Offset(-1, -3),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'MontserratRegular'),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ),
    );
  }
}

confirmPopUp(BuildContext context, message, VoidCallback? yesTap) {
  // set up the AlertDialog
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            // title: Text("Notice"),
            // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.delete,
                              color: AppColors.buttonColor,
                              size: 5.h,
                            ),
                            // Image.asset(
                            //   AppImages.logo1,
                            //   color: AppColors.buttonColor,
                            //   height: 5.h,
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Text(
                                message.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  child: Text(
                                    "No",
                                    style: bodyNormal.copyWith(
                                        color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    "Yes",
                                    style:
                                        bodyNormal.copyWith(color: Colors.red),
                                  ),
                                  onPressed: yesTap,
                                ),
                              ],
                            )
                            // CustomButton(
                            //   buttonText: 'yes',
                            //   onTap: () {
                            //     setState(() {});
                            //     yesTap;
                            //     Navigator.pop(context);
                            //   },
                            // )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          );
        });
      });
}

successPopUp(BuildContext context, page, message) {
  // set up the AlertDialog
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            // title: Text("Notice"),
            // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Image.asset(
                              AppImages.logo1,
                              color: AppColors.buttonColor,
                              height: 5.h,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Text(
                                message.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              buttonText: 'Done',
                              onTap: () {
                                setState(() {});
                                Navigator.pop(context);
                                page == ""
                                    ? null
                                    : PageTransition.pageProperNavigation(
                                        page: page);
                              },
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          );
        });
      });
}

errorPopUp(BuildContext context, String message) {
  // set up the AlertDialog
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            // title: Text("Notice"),
            // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.buttonColor,
                              size: 5.h,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              child: Text(
                                message.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: 1.4,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              buttonText: 'Done',
                              onTap: () {
                                Navigator.pop(context);
                                // PageTransition.pageNavigation(page: page);
                              },
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ],
          );
        });
      });
}
