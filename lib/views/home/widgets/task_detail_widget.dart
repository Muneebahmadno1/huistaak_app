import 'package:flutter/material.dart';
import 'package:huistaak/constants/global_variables.dart';

class TaskDetailWidget extends StatelessWidget {
  String icon;
  String title;
  String data;
  TaskDetailWidget(
      {super.key, required this.icon, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Image.asset(icon),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: bodySmall.copyWith(color: Colors.white70),
            ),
            Text(
              data,
              style: headingSmall.copyWith(color: Colors.white, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}
