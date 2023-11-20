import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
  late PickedFile pickedFile;
  String? imageUrl;
  File? imageFile;
  final picker = ImagePicker();
  bool processingStatus = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? pickedImage;

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
        "imageUrl": map['imageUrl'],
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

  reSendVerificationEmail(context) async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    successPopUp(
        context, const LoginScreen(), 'Verification link sent to your email.');
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
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  contentPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13)),
                  // title: Text("Notice"),
                  // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
                  actions: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: AppColors.buttonColor,
                                    size: 5.h,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: Text(
                                      "User not verified yet, Want to resend verification mail",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1.4,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: ZoomTapAnimation(
                                          onTap: () async {
                                            HapticFeedback.heavyImpact();
                                            await FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: email.toString(),
                                                    password:
                                                        password.toString());
                                            FirebaseAuth.instance.currentUser
                                                ?.sendEmailVerification();
                                            Get.back();
                                            successPopUp(context, "",
                                                'Verification link sent to your email.');
                                          },
                                          onLongTap: () {},
                                          enableLongTapRepeatEvent: false,
                                          longTapRepeatDuration:
                                              const Duration(milliseconds: 100),
                                          begin: 1.0,
                                          end: 0.93,
                                          beginDuration:
                                              const Duration(milliseconds: 20),
                                          endDuration:
                                              const Duration(milliseconds: 120),
                                          beginCurve: Curves.decelerate,
                                          endCurve: Curves.fastOutSlowIn,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.buttonColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Center(
                                                child: Text("Yes",
                                                    style: bodyLarge.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: ZoomTapAnimation(
                                          onTap: () {
                                            HapticFeedback.heavyImpact();
                                            Navigator.pop(context);
                                          },
                                          onLongTap: () {},
                                          enableLongTapRepeatEvent: false,
                                          longTapRepeatDuration:
                                              const Duration(milliseconds: 100),
                                          begin: 1.0,
                                          end: 0.93,
                                          beginDuration:
                                              const Duration(milliseconds: 20),
                                          endDuration:
                                              const Duration(milliseconds: 120),
                                          beginCurve: Curves.decelerate,
                                          endCurve: Curves.fastOutSlowIn,
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: AppColors.buttonColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Center(
                                                child: Text("No",
                                                    style: bodyLarge.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ],
                );
              });
            });
        // errorPopUp(context, "User not verified yet,\n Try again");
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

  Future<bool> upload(String inputSource) async {
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      processingStatus = true;

      final String fileName = path.basename(pickedImage!.path);
      try {
        // Uploading the selected image with some custom meta data
        {
          imageFile = File(pickedImage!.path);
          await storage.ref(fileName).putFile(imageFile!).then((p0) async {
            imageUrl = await p0.ref.getDownloadURL();
            if (p0.state == TaskState.success) {
              processingStatus = false;
            }
          });
        }
        // Refresh the UI
        return true;
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
        return false;
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }
}
