import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/helper/page_navigation.dart';
import 'package:intl/intl.dart';

import '../constants/global_variables.dart';
import '../controllers/general_controller.dart';
import '../models/user_model.dart';
import '../views/auth/login_screen.dart';
import '../views/home/bottom_nav_bar.dart';
import '../views/home/connected_groups.dart';
import '../widgets/custom_widgets.dart';
import 'collections.dart';

class DataHelper extends GetxController {
  DateTime? selectedDate = DateTime.now();
  DateTime? goalSelectedDate = DateTime.now();
  RxString startTime = '09:00 AM'.obs;
  RxString endTime = '10:00 AM'.obs;
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

      Collections.USERS.doc(user.user!.uid).set({
        "userID": user.user!.uid,
        "displayName": map['displayName'].toString(),
        "email": emails,
        "imageUrl": "",
        "points": "0",
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
        Collections.USERS.doc(user.user!.uid).get().then((value) async {
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
    var groupID = Collections.GROUPS.doc().id;
    await Collections.GROUPS.doc(groupID).set({
      "groupName": groupName,
      "groupImage": groupImage,
      "groupID": groupID.toString(),
      "adminsList": adminsList,
      "membersList": membersList
    });
    await Collections.USERS
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

  joinGroupRequest(groupID) async {
    final newMap = {
      'displayName': userData.displayName.toString(),
      'imageUrl': userData.imageUrl.toString(),
      'userID': userData.userID.toString(),
    };

    var querySnapshot2 = await Collections.GROUPS.doc(groupID.toString()).get();
    adminList.add({
      "adminsList": List.from(querySnapshot2['adminsList']),
      "membersList": List.from(querySnapshot2['membersList']),
    });

    var notiID = Collections.USERS
        .doc(adminList[0]['adminsList'][0]['userID'])
        .collection("notifications")
        .doc();
    notiID.set({
      "notificationType": 1,
      "notification":
          userData.displayName.toString() + " requested to join group",
      "userToJoin": FieldValue.arrayUnion([newMap]),
      "groupToJoinID": groupID,
      "Time": DateTime.now(),
      "notiID": notiID.id,
    });
    return;
  }

  joinGroup(groupID, Map<String, dynamic> newMap) async {
    await Collections.GROUPS.doc(groupID).update({
      "membersList": FieldValue.arrayUnion([newMap])
    });
  }

  deleteNotification(notiID) async {
    await Collections.USERS
        .doc(userData.userID.toString())
        .collection("notifications")
        .doc(notiID)
        .delete();
  }

  sendNotification(docID) {
    var notiID = Collections.USERS
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

  addGroupTask(groupID, taskTitle, taskDate, String startTimeT, String endTimeT,
      taskScore, assignMembers) async {
    final DateFormat format = DateFormat('hh:mm a');

    // Parse the time strings into DateTime objects
    DateTime startTime = format.parse(startTimeT);
    DateTime endTime = format.parse(endTimeT);

    // Check if end time is before start time (i.e., end time is on the next day)
    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(Duration(days: 1));
    }

    // Calculate the time difference in hours
    Duration difference = endTime.difference(startTime);
    double hours = difference.inMinutes / 60;

    CollectionReference ref =
        await Collections.GROUPS.doc(groupID).collection("tasks");

    String docId = ref.doc().id;
    await Collections.GROUPS.doc(groupID).collection("tasks").doc(docId).set({
      "taskTitle": taskTitle,
      "taskDate": taskDate,
      "startTime": startTimeT,
      "endTime": endTimeT,
      "Duration": hours < 0 ? (-hours).toString() : (hours).toString(),
      "taskScore": taskScore,
      "assignMembers": assignMembers,
      "id": docId,
    });
    return;
  }

  startTask(groupID, taskID, groupTitle) {
    final DocumentReference documentReference =
        Collections.GROUPS.doc(groupID).collection("tasks").doc(taskID);

    Map<String, dynamic> newVariable = {
      'startTask': DateTime.now(), // Add the 4th variable here
    };

// Fetch the existing data from the document
    documentReference.get().then((documentSnapshot) {
      if (documentSnapshot.exists) {
        dynamic data = documentSnapshot.data();
        List<Map<String, dynamic>> existingArray =
            List<Map<String, dynamic>>.from(data['assignMembers'] ?? []);

        // Find the index of the map with a matching userID
        int index = existingArray
            .indexWhere((map) => map['userID'] == userData.userID.toString());

        if (index != -1) {
          // If a match is found, add the new variable to that map
          existingArray[index]['startTask'] = newVariable['startTask'];

          // Update the document with the modified array
          documentReference.update({
            'assignMembers': existingArray,
          }).then((_) {
            print('Document updated successfully');
          }).catchError((error) {
            print('Error updating document: $error');
          });
        } else {
          print('No matching userID found.');
        }
        Get.off(() => ConnectedGroupScreen(
            // groupID: groupID,
            // groupTitle: groupTitle,
            ));
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  endTask(groupID, taskID, StartTime, taskDurationInMin, points, groupTitle) {
    final DocumentReference documentReference =
        Collections.GROUPS.doc(groupID).collection("tasks").doc(taskID);

// Fetch the existing data from the document
    documentReference.get().then((documentSnapshot) async {
      if (documentSnapshot.exists) {
        dynamic data = documentSnapshot.data();
        List<Map<String, dynamic>> existingArray =
            List<Map<String, dynamic>>.from(data['assignMembers'] ?? []);

        // Find the index of the map with a matching userID
        int index = existingArray
            .indexWhere((map) => map['userID'] == userData.userID.toString());
        bool containsStartTask =
            existingArray.any((map) => map['startTask'] != null);

        if (index != -1 && containsStartTask == true) {
          // If a match is found, add the new variable to that map
          int differenceInMinutes = DateTime.now()
              .difference(StartTime[index]['startTask'].toDate())
              .inMinutes;
          print("differenceInMinutes");
          print(differenceInMinutes);
          var pointPerMinute = taskDurationInMin / double.parse(points);
          print("pointPerMinute");
          print(pointPerMinute);
          var userPoint;
          for (int i = 0; i < int.parse(points); i++) {
            if (differenceInMinutes < pointPerMinute * (i + 1)) {
              print("dd");
              userPoint = double.parse(points) - double.parse(i.toString());
              break;
            }
          }
          print("userPoint");
          print(userPoint);
          print(userPoint.ceil());
          Map<String, dynamic> newVariable = {
            'endTask': DateTime.now(),
            'pointsEarned':
                userPoint.ceil().toString(), // Add the 4th variable here
          };

          existingArray[index]['endTask'] = newVariable['endTask'];
          existingArray[index]['pointsEarned'] = newVariable['pointsEarned'];
          // Update the document with the modified array

          String newValue = (int.parse(userData.points.toString()) +
                  int.parse(userPoint.ceil().toString()))
              .toString();

          await Collections.USERS
              .doc(userData.userID.toString())
              .update({'points': newValue});
          Collections.USERS
              .doc(userData.userID.toString())
              .get()
              .then((value) async {
            userData = UserModel.fromDocument(value.data());
          });
          documentReference.update({
            'assignMembers': existingArray,
          }).then((_) {
            print('Document updated successfully');
          }).catchError((error) {
            print('Error updating document: $error');
          });
        } else {
          print("Task haven't started yet");
        }
        Get.off(() => ConnectedGroupScreen(
            // groupID: groupID,
            // groupTitle: groupTitle,
            ));
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  addGroupGoal(groupID, goalTitle, goalDate, time, goalMembers) async {
    var doc = await Collections.GROUPS
        .doc(groupID.toString())
        .collection("Goals")
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
