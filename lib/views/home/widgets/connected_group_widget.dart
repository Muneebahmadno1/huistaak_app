import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/home/group_detail.dart';

import '../../../constants/global_variables.dart';

class ConnectedGroupList extends StatefulWidget {
  final String name;
  final String desc;
  final String imageUrl;
  final String time;
  final bool isOpened;
  ConnectedGroupList(
      {required this.name,
      required this.desc,
      required this.imageUrl,
      required this.time,
      required this.isOpened});
  @override
  _ConnectedGroupListState createState() => _ConnectedGroupListState();
}

class _ConnectedGroupListState extends State<ConnectedGroupList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GroupDetail());
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
                    backgroundImage: AssetImage(widget.imageUrl),
                    maxRadius: 28,
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
                                fontFamily: "MontserratSemiBold", fontSize: 16),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.desc,
                            style: bodyNormal.copyWith(
                                fontFamily: widget.isOpened
                                    ? "MontserratRegular"
                                    : "MontserratSemiBold",
                                fontSize: 12,
                                color: widget.isOpened
                                    ? Colors.black54
                                    : Colors.black),
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
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: AppColors.buttonColor, shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        "1",
                        style: bodySmall.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    widget.time,
                    style: bodySmall.copyWith(
                        fontFamily: widget.isOpened
                            ? "MontserratRegular"
                            : "MontserratSemiBold",
                        fontSize: 12,
                        color: widget.isOpened ? Colors.black54 : Colors.black),
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
