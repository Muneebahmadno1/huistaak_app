import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../constants/app_images.dart';
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
        CircleAvatar(
          radius: 20, // Adjust the radius as needed
          backgroundColor:
              Colors.grey, // You can set a default background color
          child: ClipOval(
            child: SizedBox(
              height: 20 * 2,
              width: 20 * 2,
              child: widget.image == ""
                  ? Image.asset(
                      AppImages.profileImage,
                      // Replace with your asset image path
                      fit: BoxFit.cover,
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.image,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 7.0,
            percent: widget.percent >= 1.0 ? 1.0 : widget.percent,
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
