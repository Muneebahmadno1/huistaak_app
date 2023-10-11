import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';

import '../../../constants/global_variables.dart';

class AddMemberWidget extends StatefulWidget {
  final String title;
  final String suffixIcon;
  final Widget? leadingIcon;
  final bool isActive;
  AddMemberWidget({
    Key? key,
    required this.suffixIcon,
    required this.isActive,
    required this.title,
    this.leadingIcon = const SizedBox.shrink(),
  }) : super(key: key);

  @override
  State<AddMemberWidget> createState() => _AddMemberWidgetState();
}

class _AddMemberWidgetState extends State<AddMemberWidget> {
  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: Duration(milliseconds: 400),
      slidingBeginOffset: Offset(0, 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 0.7),
                    shape: BoxShape.circle,
                    image:
                        DecorationImage(image: AssetImage(widget.suffixIcon))),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: headingMedium,
                    ),
                  ],
                ),
              ),
              Container(
                height: 34,
                width: 80,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: widget.isActive == false ? 2 : 1.2,
                        color: widget.isActive == true
                            ? AppColors.buttonColor
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(40),
                    color: widget.isActive != true
                        ? AppColors.buttonColor
                        : Colors.transparent),
                child: widget.isActive == true
                    ? Center(
                        child: Text(
                        "Added",
                        style: bodySmall.copyWith(
                            fontSize: 12, color: Colors.black),
                      ))
                    : Center(
                        child: Text(
                        "Add",
                        style: bodySmall.copyWith(
                            fontSize: 12, color: Colors.white),
                      )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
