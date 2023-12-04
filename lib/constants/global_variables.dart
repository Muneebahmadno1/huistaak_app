import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

///---------App Colors

class AppColors {
  static const Color primaryColor = Color(0xffffffff);
  static const Color secondaryColor = Color(0xff000000);
  static const Color scaffoldColor = Color(0xffffffff);
  static const Color buttonColor = Color(0xff108CD1);
  static const Color textFieldColor = Color(0xffE3BD66);
}

///---------App Texts
TextStyle headingLarge = const TextStyle(
    fontSize: 26,
    color: Colors.black,
    fontFamily: 'PoppinsBold',
    fontWeight: FontWeight.w700);
TextStyle headingMedium = const TextStyle(
    fontSize: 18, color: Colors.black, fontFamily: 'MontserratSemiBold');
TextStyle headingSmall = const TextStyle(
    fontSize: 16, color: Colors.black, fontFamily: 'MontserratSemiBold');
TextStyle bodyLarge = const TextStyle(
    fontSize: 16, color: Colors.black, fontFamily: 'MontserratSemiBold');
TextStyle bodyNormal = const TextStyle(
    fontSize: 15, color: Colors.black, fontFamily: 'MontserratSemiBold');
TextStyle authSubHeading = const TextStyle(
    fontSize: 15,
    color: Colors.black87,
    fontFamily: 'PoppinsRegular',
    fontWeight: FontWeight.bold);
TextStyle bodySmall = const TextStyle(
    fontSize: 10,
    color: Colors.black,
    fontFamily: 'PoppinsRegular',
    height: 1.5);

TextStyle title = const TextStyle(
    fontSize: 12, color: Colors.black12, fontFamily: "MontserratSemiBold");
TextStyle hintText =
    const TextStyle(fontSize: 12, color: Colors.black12, fontFamily: 'Inter');

///----------App variables

final userDocId = ValueNotifier("");
RxString fcmToken = ''.obs;
UserModel userData = UserModel(
    points: "",
    postalCode: "",
    phoneNumber: "",
    userID: "",
    displayName: "",
    email: "",
    imageUrl: "",
    fcmToken: "");

void setUserLoggedIn(bool key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("isLoggedIn", key);
}

Future getUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getBool("isLoggedIn") ?? false;
  return log;
}

void setUserFirstTime(bool key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool("FirstTime", key);
}

Future getUserFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var log = prefs.getBool("FirstTime") ?? false;
  return log;
}

void saveUserData({@required userID}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  await pref.setString("userID", userID);
}

Future getUserData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? result = pref.getString("userID");
  return result;
}
