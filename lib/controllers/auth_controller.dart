import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../helper/page_navigation.dart';
import '../models/user_model.dart';
import '../views/auth/login_screen.dart';
import '../views/home/bottom_nav_bar.dart';
import '../widgets/custom_widgets.dart';
import 'general_controller.dart';

class AuthController extends GetxController {
  bool isEmailVerified = false;
  final loggedInGlobal = ValueNotifier(false);

  registerUser(context, emails, pass, map) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emails, password: pass);
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(map['displayName']);
      Random random = new Random();
      int randomNumber = random.nextInt(5);
      Collections.USERS.doc(user.user!.uid).set({
        "userID": user.user!.uid,
        "displayName": map['displayName'].trim().toString(),
        "email": emails,
        "imageUrl": randomNumber == 1
            ? "https://firebasestorage.googleapis.com/v0/b/huistaak-b26cd.appspot.com/o/Ellipse%20425.png?alt=media&token=39ef01fd-faeb-4237-aad0-229a71531287"
            : randomNumber == 2
                ? "https://firebasestorage.googleapis.com/v0/b/huistaak-b26cd.appspot.com/o/Ellipse%20426.png?alt=media&token=7d6999f8-71bd-4c2c-88ab-7da3cc00acdf"
                : randomNumber == 3
                    ? "https://firebasestorage.googleapis.com/v0/b/huistaak-b26cd.appspot.com/o/Ellipse%20427.png?alt=media&token=636deb05-21b2-4cac-92e1-3f803a0c109e"
                    : randomNumber == 4
                        ? "https://firebasestorage.googleapis.com/v0/b/huistaak-b26cd.appspot.com/o/Ellipse%20429.png?alt=media&token=51d206a1-2158-49cf-8821-5a79c644907b"
                        : "https://firebasestorage.googleapis.com/v0/b/huistaak-b26cd.appspot.com/o/Ellipse%20428.png?alt=media&token=2f6c1518-fbd1-4a81-ad9d-8ca89809f896",
        "points": [],
        "postalCode": map['postalCode'].toString(),
        "fcmToken": fcmToken.value,
      });
      FirebaseAuth.instance.currentUser?.sendEmailVerification();
      Get.back();
      //setState(() {});
      successPopUp(context, const LoginScreen(),
          'Successfully registered,\n Verification link sent to your email.');
    } catch (error) {
      Get.back();
      //setState(() {});
      errorPopUp(
        context,
        error.toString().replaceRange(0, 14, '').split(']')[1],
      );
    }
  }

  validateUser(context, email, password) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userDocId.value = user.user!.uid;

      await FirebaseAuth.instance.currentUser?.reload();

      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
      if (isEmailVerified) {
        Collections.USERS.doc(user.user!.uid).get().then((value) async {
          userData = UserModel.fromDocument(value.data());
          saveUserData(userID: userDocId.value);
          setUserLoggedIn(true);
          loggedInGlobal.value = true;
          Get.back();
          Get.find<GeneralController>().onBottomBarTapped(0);
          PageTransition.pageProperNavigation(page: CustomBottomNavBar());
        });
        await Collections.USERS
            .doc(userDocId.value)
            .update({"fcmToken": fcmToken.value});
      } else {
        Get.back();
        errorPopUp(context, "User not verified yet,\n Try again");
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      errorPopUp(
        context,
        e.code == 'user-not-found'
            ? "User not found"
            : (e.code == 'INVALID_LOGIN_CREDENTIALS')
                ? "Your Email or Password is incorrect. Please try again."
                : e.toString().replaceRange(0, 14, '').split(']')[1],
      );
    }
  }

  resetPassword(context, email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      successPopUp(context, LoginScreen(),
          'To change password an email send to your email account.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorPopUp(context, "There is no record of this email");
      }
    }
  }

  editProfile(name, image, age, phone) async {
    await Collections.USERS.doc(userDocId.value).update({
      "displayName": name,
      "imageUrl": image,
      'postalCode': age,
      'phoneNumber': phone
    });
    await Collections.USERS.doc(userDocId.value).get().then((value) async {
      userData = UserModel.fromDocument(value.data());
    });
    return;
  }

  changePassword(context, currentPassword, newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: userData.email, password: currentPassword);

    user?.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        //Success, do something
        Get.back();
        successPopUp(
            context, CustomBottomNavBar(), 'Password Changed Successfully');
      }).catchError((error) {
        //Error, show something
        Get.back();
        errorPopUp(
            context, 'Error occurred while changing password! Try Again ');
      });
    }).catchError((err) {
      Get.back();
      // setState(() {});
      errorPopUp(context, 'Error occurred while changing password! Try Again ');
    });
  }
}
