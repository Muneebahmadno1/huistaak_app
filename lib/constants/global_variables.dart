import 'package:flutter/material.dart';

///---------App Colors

class AppColors {
  static const Color primaryColor = Color(0xffffffff);
  static const Color secondaryColor = Color(0xff000000);
  static const Color scaffoldColor = Color(0xffffffff);
  static const Color buttonColor = Color(0xff108DD0);
  static const Color textFieldColor = Color(0xffE3BD66);
}

///---------App Texts
TextStyle headingLarge = const TextStyle(
    fontSize: 26,
    color: Colors.black,
    fontFamily: 'PoppinsBold',
    fontWeight: FontWeight.w700);
TextStyle headingMedium = const TextStyle(
    fontSize: 18, color: Colors.black, fontFamily: 'PoppinsSemiBold');
TextStyle headingSmall = const TextStyle(
    fontSize: 16, color: Colors.black, fontFamily: 'PoppinsSemiBold');
TextStyle bodyLarge = const TextStyle(
    fontSize: 16, color: Colors.black, fontFamily: 'PoppinsRegular');
TextStyle bodyNormal = const TextStyle(
    fontSize: 15, color: Colors.black, fontFamily: 'PoppinsRegular');
TextStyle authSubHeading = const TextStyle(
    fontSize: 15, color: Colors.black54, fontFamily: 'PoppinsRegular');
TextStyle bodySmall = const TextStyle(
    fontSize: 10,
    color: Colors.black,
    fontFamily: 'PoppinsRegular',
    height: 1.5);

TextStyle title =
    const TextStyle(fontSize: 12, color: Colors.black12, fontFamily: 'Inter');
TextStyle hintText =
    const TextStyle(fontSize: 12, color: Colors.black12, fontFamily: 'Inter');
