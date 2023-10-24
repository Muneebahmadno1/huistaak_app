import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/global_variables.dart';
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
                            Icon(
                              Icons.account_tree_rounded,
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
                                setState(() {});
                                Navigator.pop(context);
                                PageTransition.pageProperNavigation(page: page);
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
