import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../constants/global_variables.dart';

class LikeBarWidget extends StatefulWidget {
  String TotalCount;
  String image;
  String count;
  double percent;
  LikeBarWidget(
      {super.key,
      required this.TotalCount,
      required this.image,
      required this.count,
      required this.percent});

  @override
  State<LikeBarWidget> createState() => _LikeBarWidgetState();
}

class _LikeBarWidgetState extends State<LikeBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(widget.image), fit: BoxFit.cover)),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 7.0,
            percent: widget.percent,
            barRadius: Radius.circular(10),
            backgroundColor: Colors.white70,
            progressColor: AppColors.primaryColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          widget.count + "/" + widget.TotalCount,
          style: headingSmall.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
