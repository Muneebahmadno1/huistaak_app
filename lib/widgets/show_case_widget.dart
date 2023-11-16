import 'package:flutter/material.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView(
      {Key? key,
      required this.globalKey,
      required this.title,
      required this.description,
      required this.child,
      this.shapeBorder = const CircleBorder()})
      : super(key: key);

  final GlobalKey globalKey;
  final String title;
  final String description;
  final Widget child;
  final ShapeBorder shapeBorder;
  @override
  Widget build(BuildContext context) {
    return Showcase(
        key: globalKey,
        title: title,
        titleTextStyle: TextStyle(color: AppColors.buttonColor),
        description: description,
        targetShapeBorder: shapeBorder,
        child: child);
  }
}
