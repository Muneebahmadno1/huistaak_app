import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'app_images.dart';
import 'global_variables.dart';

Future<void> showCustomDialog(
  BuildContext context,
  String title,
  String desc,
  String buttonText,
  final Function onTap,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Color(0xff333333),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.black,
                child: Image.asset(
                  AppImages.successIcon,
                  height: 22,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Text(
                  title,
                  style: headingMedium.copyWith(
                      color: Colors.white, fontFamily: "InterSemiBold"),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  desc,
                  style: bodyLarge.copyWith(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                child: ZoomTapAnimation(
                  onTap: () {
                    onTap();
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
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(buttonText,
                            style: bodyLarge.copyWith(color: Colors.white)),
                      )),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      );
    },
  );
}
