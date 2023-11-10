import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_detail.dart';
import 'package:intl/intl.dart';

import '../../../constants/global_variables.dart';

class ConnectedGroupList extends StatefulWidget {
  final String name;
  final String desc;
  final String imageUrl;
  final DateTime time;
  final String groupID;

  ConnectedGroupList(
      {required this.name,
      required this.desc,
      required this.imageUrl,
      required this.time,
      required this.groupID});

  @override
  _ConnectedGroupListState createState() => _ConnectedGroupListState();
}

class _ConnectedGroupListState extends State<ConnectedGroupList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GroupDetail(
              groupID: widget.groupID,
              groupTitle: widget.name,
            ));
      },
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
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
                        child: widget.imageUrl == "assets/images/man1.png"
                            ? Image.asset(
                                widget
                                    .imageUrl, // Replace with your asset image path
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.imageUrl,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.fill,
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
                  SizedBox(
                    height: 6,
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
    );
  }
}
