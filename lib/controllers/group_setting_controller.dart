import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/user_model.dart';
import 'notification_controller.dart';

class GroupSettingController extends GetxController {
  final NotificationController _notiController =
      Get.find<NotificationController>();
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> groupInfo = [];

  late PickedFile pickedFile;
  String? imageUrl;
  File? imageFile;
  final picker = ImagePicker();
  bool processingStatus = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? pickedImage;

  getGroupTaskList(groupID) async {
    taskList.clear();
    QuerySnapshot querySnapshot = await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;

      taskList.add({
        "taskTitle": a['taskTitle'],
        "taskScore": a['taskScore'],
        "taskDate": a['taskDate'],
        "startTime": a['startTime'],
        "endTime": a['endTime'],
        "assignMembers": List.from(a['assignMembers']),
        "id": a['id'],
      });
    }
  }

  getGroupInfo(groupID) async {
    groupInfo.clear();
    var querySnapshot = await Collections.GROUPS.doc(groupID).get();
    groupInfo.add({
      "groupCode": querySnapshot['groupCode'],
      "groupImage": querySnapshot['groupImage'],
      "groupName": querySnapshot['groupName'],
      "adminsList": List.from(querySnapshot['adminsList']),
      "membersList": List.from(querySnapshot['membersList']),
    });
  }

  leaveGroup(groupID, groupTitle) async {
    if (groupInfo[0]['membersList'].isNotEmpty) {
      groupInfo[0]['membersList']
          .removeWhere((map) => map['userID'] == userData.userID.toString());

      if (groupInfo[0]['membersList'].isNotEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': groupInfo[0]['membersList']});
      } else {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': groupInfo[0]['membersList']});
      }
    }
    if (groupInfo[0]['adminsList'].isNotEmpty) {
      groupInfo[0]['adminsList']
          .removeWhere((map) => map['userID'] == userData.userID.toString());
      QuerySnapshot querySnapshot = await Collections.USERS
          .doc(userData.userID)
          .collection(Collections.MYGROUPS)
          .where("groupID", isEqualTo: groupID.toString())
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          await document.reference.delete();
        }
      }

      if (groupInfo[0]['adminsList'].isNotEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'adminsList': groupInfo[0]['adminsList']});
      } else if (groupInfo[0]['membersList'].isNotEmpty) {
        // Remove the first element from membersList and store it in a variable.
        Map<String, dynamic> removedMember =
            groupInfo[0]['membersList'].removeAt(0);

        // Add the removed member to adminsList.
        groupInfo[0]['adminsList'].add(removedMember);

        // Now you can update the Firestore document with the modified groupInfo.
        Collections.GROUPS.doc(groupID.toString()).update({
          'membersList': groupInfo[0]['membersList'],
          'adminsList': groupInfo[0]['adminsList'],
        });
        var notiID = Collections.USERS
            .doc(removedMember['userID'].toString())
            .collection(Collections.NOTIFICATIONS)
            .doc();
        notiID.set({
          "read": false,
          "notificationType": 4,
          "notification":
              "you have been made admin of " + groupTitle.toString() + " group",
          "Time": DateTime.now(),
          "notiID": notiID.id,
          "userToJoin": FieldValue.arrayUnion([]),
          "groupID": groupID.toString(),
          "groupName": groupTitle.toString(),
        });
        Collections.USERS
            .doc(removedMember['userID'].toString())
            .get()
            .then((value) async {
          UserModel notiUserData = UserModel.fromDocument(value.data());
          var data = {
            'type': "request",
            'end_time': DateTime.now().toString(),
          };
          _notiController.sendNotifications(
              notiUserData.fcmToken.toString(),
              "You have been made admin of " + groupTitle.toString() + " group",
              data);
        });
      } else if (groupInfo[0]['adminsList'].isEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'adminsList': groupInfo[0]['adminsList']});
      }
    }

    final userDocRef = Collections.USERS.doc(userData.userID.toString());

    final userDoc = await userDocRef.get();

    if (userDoc.exists) {
      final List<Map<String, dynamic>> pointsList =
          List<Map<String, dynamic>>.from(userDoc.get('points') ?? []);

      final groupIDToRemove =
          groupID.toString(); // The 'groupID' you want to remove

      // Remove items where 'groupID' matches
      pointsList.removeWhere((pointEntry) {
        return pointEntry['groupID'] == groupIDToRemove;
      });

      // Update the Firestore document with the modified array
      await userDocRef.update({'points': pointsList});
      Collections.USERS
          .doc(userData.userID.toString())
          .get()
          .then((value) async {
        userData = UserModel.fromDocument(value.data());
      });
    }
  }

  removeMember(memberID, groupID) {
    if (groupInfo[0]['membersList'].isNotEmpty) {
      groupInfo[0]['membersList']
          .removeWhere((map) => map['userID'] == memberID.toString());

      if (groupInfo[0]['membersList'].isNotEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': groupInfo[0]['membersList']});
      } else {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': groupInfo[0]['membersList']});
      }
    }
  }

  makeAdmin(memberID, groupID, groupTitle) {
    late Map<String, dynamic> removedMember;
    List<dynamic> membersList = groupInfo[0]['membersList'];

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['userID'] == memberID) {
        removedMember = membersList.removeAt(i);
        break; // Exit the loop after the first match is removed
      }
    }

    // Add the removed member to adminsList.
    groupInfo[0]['adminsList'].add(removedMember);

    // Now you can update the Firestore document with the modified groupInfo.
    Collections.GROUPS.doc(groupID.toString()).update({
      'membersList': groupInfo[0]['membersList'],
      'adminsList': groupInfo[0]['adminsList'],
    });
    var notiID = Collections.USERS
        .doc(removedMember['userID'].toString())
        .collection(Collections.NOTIFICATIONS)
        .doc();
    notiID.set({
      "read": false,
      "notificationType": 4,
      "notification": "you have been made admin of " + groupTitle.toString(),
      "Time": DateTime.now(),
      "notiID": notiID.id,
      "userToJoin": FieldValue.arrayUnion([]),
      "groupID": groupID.toString(),
      "groupName": groupTitle.toString(),
    });
    Collections.USERS
        .doc(removedMember['userID'].toString())
        .get()
        .then((value) async {
      UserModel notiUserData = UserModel.fromDocument(value.data());
      var data = {
        'type': "request",
        'end_time': DateTime.now().toString(),
      };
      _notiController.sendNotifications(notiUserData.fcmToken.toString(),
          "You have been made admin of " + groupTitle.toString(), data);
    });
  }

  fetchUser(userID) async {
    var document = await Collections.USERS.doc(userID.toString()).get();
    if (document.exists) {
      final UserModel user = UserModel.fromDocument(document.data()!);
      return user;
    }
  }

  Future<bool> upload(String inputSource, groupID) async {
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
        await Collections.GROUPS.doc(groupID).update({
          "groupImage": imageUrl,
        });
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
