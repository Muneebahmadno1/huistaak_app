import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/helper/page_navigation.dart';

import '../constants/global_variables.dart';
import '../controllers/general_controller.dart';
import '../models/user_model.dart';
import '../views/auth/login_screen.dart';
import '../views/home/bottom_nav_bar.dart';
import '../widgets/custom_widgets.dart';

class DataHelper extends GetxController {
  DateTime? selectedDate = DateTime.now();
  DateTime? goalSelectedDate = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isEmailVerified = false;
  List<Map<String, dynamic>> adminList = [];
  RxList<Map<String, dynamic>> groupAdmins = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> groupMembers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignTaskMember = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignGoalMember = <Map<String, dynamic>>[].obs;

  final loggedInGlobal = ValueNotifier(false);

  registerUser(context, emails, pass, map) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emails, password: pass);
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(map['displayName']);

      FirebaseFirestore.instance.collection('users').doc(user.user!.uid).set({
        "userID": user.user!.uid,
        "displayName": map['displayName'].toString(),
        "email": emails,
        "imageUrl": "",
        "postalCode": map['postalCode'].toString(),
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
        FirebaseFirestore.instance
            .collection('users')
            .doc(user.user!.uid)
            .get()
            .then((value) async {
          userData = UserModel.fromDocument(value.data());
          saveUserData(userID: userDocId.value);
          setUserLoggedIn(true);
          loggedInGlobal.value = true;
          Get.back();
          Get.find<GeneralController>().onBottomBarTapped(0);
          PageTransition.pageProperNavigation(page: CustomBottomNavBar());
        });
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
            : (e.code == 'wrong-password')
                ? "The Password you have entered is not correct"
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId.value)
        .update({
      "displayName": name,
      "imageUrl": image,
      'postalCode': age,
      'phoneNumber': phone
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId.value)
        .get()
        .then((value) async {
      userData = UserModel.fromDocument(value.data());
    });
    return;
  }

  void changePassword(context, currentPassword, newPassword) async {
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

  createGroup(groupName, groupImage, adminsList, membersList) async {
    var groupID = FirebaseFirestore.instance.collection('groups').doc().id;
    await FirebaseFirestore.instance.collection('groups').doc(groupID).set({
      "groupName": groupName,
      "groupImage": groupImage,
      "adminsList": adminsList,
      "membersList": membersList
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId.value)
        .collection("myGroups")
        .doc()
        .set({
      "groupID": groupID,
      "groupName": groupName,
      "groupImage": groupImage,
    });

    return;
  }

  joinGroup(groupID) async {
    final newMap = {
      'displayName': userData.displayName.toString(),
      'imageUrl': userData.imageUrl.toString(),
      'userID': userData.userID.toString(),
    };

    var querySnapshot2 = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID.toString())
        .get();
    adminList.add({
      "adminsList": List.from(querySnapshot2['adminsList']),
      "membersList": List.from(querySnapshot2['membersList']),
    });

    var notiID = FirebaseFirestore.instance
        .collection("users")
        .doc(adminList[0]['adminsList'][0]['userID'])
        .collection("notifications")
        .doc();
    notiID.set({
      "notificationType": 1,
      "notification":
          userData.displayName.toString() + "requested to join group",
      "userToJoin": FieldValue.arrayUnion([newMap]),
      "Time": DateTime.now(),
      "notiID": notiID,
    });

    // await FirebaseFirestore.instance.collection('groups').doc(groupID).update({
    //   "membersList": FieldValue.arrayUnion([newMap])
    // });
    return;
  }

  sendNotification(docID) {
    var notiID = FirebaseFirestore.instance
        .collection("users")
        .doc(docID.toString())
        .collection("notifications")
        .doc();
    notiID.set({
      "notificationType": 2,
      "notification": userData.displayName.toString() + " assigned you a task ",
      "userToJoin": FieldValue.arrayUnion([]),
      "Time": DateTime.now(),
      "notiID": notiID,
    });
  }

  addGroupTask(groupID, taskTitle, taskDate, startTime, endTime, taskScore,
      assignMembers) async {
    CollectionReference ref = await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection("tasks");

    String docId = ref.doc().id;
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupID)
        .collection("tasks")
        .doc(docId)
        .set({
      "taskTitle": taskTitle,
      "taskDate": taskDate,
      "startTime": startTime,
      "endTime": endTime,
      "taskScore": taskScore,
      "assignMembers": assignMembers,
      "id": docId,
    });
    return;
  }

  addGroupGoal(goalTitle, goalDate, time, goalMembers) async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId.value)
        .collection("myGoals")
        .doc();
    doc.set({
      "goalID": doc.id,
      "goalTitle": goalTitle,
      "goalDate": goalDate,
      "goalTime": time,
      "goalMembers": goalMembers,
    });
    return;
  }
}
