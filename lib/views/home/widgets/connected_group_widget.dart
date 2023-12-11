import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_detail.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/global_variables.dart';
import '../../../controllers/group_controller.dart';

class ConnectedGroupList extends StatefulWidget {
  final String name;
  final String desc;
  final String imageUrl;
  final DateTime time;
  final String groupID;
  final String unreadCount;

  ConnectedGroupList(
      {required this.name,
      required this.desc,
      required this.imageUrl,
      required this.time,
      required this.groupID,
      required this.unreadCount});

  @override
  _ConnectedGroupListState createState() => _ConnectedGroupListState();
}

class _ConnectedGroupListState extends State<ConnectedGroupList> {
  final GroupController _groupController = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _groupController.updateCounter(userData.userID, widget.groupID,
            clearCounter: true);
        Get.to(() => GroupDetail(
              groupID: widget.groupID,
              groupTitle: widget.name,
            ));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: (widget.unreadCount == "0" || widget.unreadCount == "null")
              ? Colors.transparent
              : AppColors.buttonColor.withOpacity(0.2), // k Grey color
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 28, // Adjust the radius as needed
                      backgroundColor:
                          Colors.grey, // You can set a default background color
                      child: ClipOval(
                        child: SizedBox(
                          height: 28 * 2,
                          width: 28 * 2,
                          child:
                              widget.imageUrl == "assets/images/groupIcon.png"
                                  ? Image.asset(
                                      widget
                                          .imageUrl, // Replace with your asset image path
                                      fit: BoxFit.fitHeight,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: widget.imageUrl,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.fitHeight,
                                    ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: bodyNormal.copyWith(
                                  color: AppColors.buttonColor,
                                  fontFamily: "MontserratSemiBold",
                                  fontSize: 16),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.desc,
                              style: bodyNormal.copyWith(
                                  fontFamily: "MontserratRegular",
                                  fontSize: 12,
                                  color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (widget.unreadCount == "0" || widget.unreadCount == "null")
                        ? SizedBox(
                            height: 6,
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                size: 4.h,
                                color: AppColors.buttonColor,
                              ),
                              Text(
                                widget.unreadCount,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                    Text(
                      DateFormat('HH:mm a').format(widget.time),
                      style: bodySmall.copyWith(
                          fontFamily: "MontserratRegular",
                          fontSize: 12,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
