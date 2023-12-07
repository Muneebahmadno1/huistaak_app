import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/group_details_model.dart';
import '../models/member_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import 'notification_controller.dart';

class GroupSettingController extends GetxController {
  final NotificationController _notiController =
      Get.find<NotificationController>();
  List<TaskModel> taskList = [];
  List<GroupDetailsModel> groupInfo = [];

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
      taskList.add(TaskModel(
        taskTitle: a['taskTitle'],
        taskScore: a['taskScore'],
        taskDate: a['taskDate'],
        startTime: a['startTime'],
        endTime: a['endTime'],
        duration: "",
        assignMembers: (a['assignMembers'] as List).map((memberData) {
          return MemberModel(
            displayName: memberData['displayName'],
            imageUrl: memberData['imageUrl'],
            userID: memberData['userID'],
            startTask: memberData['startTask'] ?? null,
            endTask: memberData['endTask'] ?? null,
            pointsEarned: memberData['pointsEarned'] ?? null,
          );
        }).toList(),
        id: a['id'],
      ));
    }
  }

  getGroupInfo(groupID) async {
    groupInfo.clear();
    var querySnapshot = await Collections.GROUPS.doc(groupID).get();
    groupInfo.add(GroupDetailsModel(
      adminsList: (querySnapshot['adminsList'] as List).map((memberData) {
        return MemberModel(
          displayName: memberData['displayName'],
          imageUrl: memberData['imageUrl'],
          userID: memberData['userID'],
        );
      }).toList(),
      membersList: (querySnapshot['membersList'] as List).map((memberData) {
        return MemberModel(
          displayName: memberData['displayName'],
          imageUrl: memberData['imageUrl'],
          userID: memberData['userID'],
        );
      }).toList(),
      groupImage: querySnapshot['groupImage'],
      groupName: querySnapshot['groupName'],
      groupCode: querySnapshot['groupCode'],
    ));
  }

  leaveGroup(groupID, groupTitle, groupCode, groupImage) async {
    if (groupInfo[0].membersList.isNotEmpty) {
      groupInfo[0]
          .membersList
          .removeWhere((map) => map.userID == userData.userID.toString());
      List<Map<String, dynamic>> memberListData = groupInfo[0]
          .membersList
          .map((member) => {
                'displayName': member.displayName,
                'imageUrl': member.imageUrl,
                'userID': member.userID,
              })
          .toList();
      if (groupInfo[0].membersList.isNotEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': memberListData});
      } else {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': memberListData});
      }
    }
    if (groupInfo[0].adminsList.isNotEmpty) {
      groupInfo[0]
          .adminsList
          .removeWhere((map) => map.userID == userData.userID.toString());
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

      if (groupInfo[0].adminsList.isNotEmpty) {
        List<Map<String, dynamic>> adminListData = groupInfo[0]
            .adminsList
            .map((member) => {
                  'displayName': member.displayName,
                  'imageUrl': member.imageUrl,
                  'userID': member.userID,
                })
            .toList();
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'adminsList': adminListData});
      } else if (groupInfo[0].adminsList.isNotEmpty) {
        // Remove the first element from membersList and store it in a variable.
        MemberModel removedMember = groupInfo[0].membersList.removeAt(0);

        // Add the removed member to adminsList.
        groupInfo[0].adminsList.add(removedMember);

        List<Map<String, dynamic>> adminListData = groupInfo[0]
            .adminsList
            .map((member) => {
                  'displayName': member.displayName,
                  'imageUrl': member.imageUrl,
                  'userID': member.userID,
                })
            .toList();
        List<Map<String, dynamic>> memberListData = groupInfo[0]
            .membersList
            .map((member) => {
                  'displayName': member.displayName,
                  'imageUrl': member.imageUrl,
                  'userID': member.userID,
                })
            .toList();
        // Now you can update the Firestore document with the modified groupInfo.
        Collections.GROUPS.doc(groupID.toString()).update({
          'membersList': memberListData,
          'adminsList': adminListData,
        });
        Collections.USERS
            .doc(removedMember.userID.toString())
            .collection("myGroups")
            .doc()
            .update({
          "groupCode": groupCode.toString(),
          "groupID": groupID.toString(),
          "groupName": groupTitle.toString(),
          "groupImage": groupImage.toString()
        });
        var notiID = Collections.USERS
            .doc(removedMember.userID.toString())
            .collection(Collections.NOTIFICATIONS)
            .doc();
        notiID.set({
          "read": false,
          "notificationType": 4,
          "notification": "you have been made admin of ",
          "Time": DateTime.now(),
          "notiID": notiID.id,
          "notiImage": userData.imageUrl.toString(),
          "userToJoin": FieldValue.arrayUnion([]),
          "groupID": groupID.toString(),
          "groupName": groupTitle.toString(),
        });
        Collections.USERS
            .doc(removedMember.userID.toString())
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
      } else if (groupInfo[0].adminsList.isEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'adminsList': groupInfo[0].adminsList});
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
    if (groupInfo[0].membersList.isNotEmpty) {
      groupInfo[0]
          .membersList
          .removeWhere((map) => map.userID == memberID.toString());
      List<Map<String, dynamic>> memberListData = groupInfo[0]
          .membersList
          .map((member) => {
                'displayName': member.displayName,
                'imageUrl': member.imageUrl,
                'userID': member.userID,
              })
          .toList();
      if (groupInfo[0].membersList.isNotEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': memberListData});
      } else {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': memberListData});
      }
    }
  }

  makeAdmin(memberID, groupID, groupTitle, groupCode, groupImage) {
    late MemberModel removedMember;
    List<MemberModel> membersList = groupInfo[0].membersList;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i].userID == memberID) {
        removedMember = membersList.removeAt(i);
        break; // Exit the loop after the first match is removed
      }
    }

    // Add the removed member to adminsList.
    groupInfo[0].adminsList.add(removedMember);
    List<Map<String, dynamic>> memberListData = groupInfo[0]
        .membersList
        .map((member) => {
              'displayName': member.displayName,
              'imageUrl': member.imageUrl,
              'userID': member.userID,
            })
        .toList();
    List<Map<String, dynamic>> adminListData = groupInfo[0]
        .adminsList
        .map((member) => {
              'displayName': member.displayName,
              'imageUrl': member.imageUrl,
              'userID': member.userID,
            })
        .toList();
    // Now you can update the Firestore document with the modified groupInfo.
    Collections.GROUPS.doc(groupID.toString()).update({
      'membersList': memberListData,
      'adminsList': adminListData,
    });
    Collections.USERS
        .doc(memberID.toString())
        .collection("myGroups")
        .doc()
        .update({
      "groupCode": groupCode.toString(),
      "groupID": groupID.toString(),
      "groupName": groupTitle.toString(),
      "groupImage": groupImage.toString()
    });
    var notiID = Collections.USERS
        .doc(removedMember.userID.toString())
        .collection(Collections.NOTIFICATIONS)
        .doc();
    notiID.set({
      "read": false,
      "notificationType": 4,
      "notification": " has made you admin of ",
      "userName": userData.displayName.toString(),
      "Time": DateTime.now(),
      "notiID": notiID.id,
      "notiImage": groupImage.toString(),
      "userToJoin": FieldValue.arrayUnion([]),
      "groupID": groupID.toString(),
      "groupName": groupTitle.toString(),
    });
    Collections.USERS
        .doc(removedMember.userID.toString())
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
