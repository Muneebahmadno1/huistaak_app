import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/global_variables.dart';

class CustomCard extends StatefulWidget {
  final String cardText;
  final Function onTap;
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  const CustomCard({
    Key? key,
    required this.cardText,
    required this.onTap,
    this.leadingIcon = const SizedBox.shrink(),
    this.suffixIcon = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: Duration(milliseconds: 400),
      slidingBeginOffset: Offset(0, 0),
      child: Padding(
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
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Color(0xfff4f4f4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: AppColors.buttonColor.withOpacity(0.3),
                            shape: BoxShape.circle),
                        child: widget.suffixIcon!,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text(
                        widget.cardText,
                        style: bodyNormal.copyWith(
                            fontFamily: "MontserratSemiBold",
                            color: AppColors.buttonColor),
                      ),
                    ],
                  ),
                ),
                widget.leadingIcon!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
