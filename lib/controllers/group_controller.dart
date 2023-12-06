import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/group_details_model.dart';
import '../models/member_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';
import 'notification_controller.dart';

class GroupController extends GetxController {
  final NotificationController _notiController =
      Get.find<NotificationController>();
  List<TaskModel> taskList = [];
  List<TaskModel> toBeCompletedTaskList = [];
  List<TaskModel> completedTaskList = [];
  List<TaskModel> notCompletedTaskList = [];
  List<GroupDetailsModel> groupInfo = [];

  bool loader = false;
  late PickedFile pickedFile;
  String? imageUrl;
  File? imageFile;
  final picker = ImagePicker();
  bool processingStatus = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? pickedImage;

  getGroupDetails(groupID, groupTitle) async {
    groupInfo.clear();
    taskList.clear();
    toBeCompletedTaskList.clear();
    notCompletedTaskList.clear();
    completedTaskList.clear();
    var querySnapshot1 = await Collections.GROUPS.doc(groupID).get();
    groupInfo.add(GroupDetailsModel(
      adminsList: (querySnapshot1['adminsList'] as List).map((memberData) {
        return MemberModel(
          displayName: memberData['displayName'],
          imageUrl: memberData['imageUrl'],
          userID: memberData['userID'],
        );
      }).toList(),
      membersList: (querySnapshot1['membersList'] as List).map((memberData) {
        return MemberModel(
          displayName: memberData['displayName'],
          imageUrl: memberData['imageUrl'],
          userID: memberData['userID'],
        );
      }).toList(),
      groupImage: querySnapshot1['groupImage'],
      groupName: querySnapshot1['groupName'],
      groupCode: querySnapshot1['groupCode'],
    ));
    // QuerySnapshot querySnapshot = await Collections.GROUPS
    //     .doc(groupID)
    //     .collection(Collections.TASKS)
    //     .orderBy("taskDate", descending: true)
    //     .get();
    // for (int i = 0; i < querySnapshot.docs.length; i++) {
    //   var a = querySnapshot.docs[i].data() as Map;
    //   taskList.add(TaskModel(
    //     taskTitle: a['taskTitle'],
    //     taskScore: a['taskScore'],
    //     taskDate: a['taskDate'],
    //     startTime: a['startTime'],
    //     endTime: a['endTime'],
    //     duration: a['duration'],
    //     assignMembers: (a['assignMembers'] as List).map((memberData) {
    //       return MemberModel(
    //         displayName: memberData['displayName'],
    //         imageUrl: memberData['imageUrl'],
    //         userID: memberData['userID'],
    //         startTask: memberData['startTask'] ?? null,
    //         endTask: memberData['endTask'] ?? null,
    //         pointsEarned: memberData['pointsEarned'] ?? null,
    //       );
    //     }).toList(),
    //     id: a['id'],
    //   ));
    // }
    //..........................
    QuerySnapshot querySnapshot = await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .orderBy("taskDate", descending: true)
        .get();
    //
    // for (int i = 0; i < querySnapshot.docs.length; i++) {
    //   var a = querySnapshot.docs[i].data() as Map;
    //   List<String> userIds = List<String>.from(
    //       a['assignMembers'].map((memberData) => memberData['userID']));
    //   List<MemberModel> members = [];
    //   members.clear();
    //   for (String userId in userIds.take(2)) {
    //     DocumentSnapshot userDoc = await Collections.USERS.doc(userId).get();
    //     if (userDoc.exists) {
    //       members.add(MemberModel(
    //         displayName: userDoc['displayName'],
    //         imageUrl: userDoc['imageUrl'],
    //         userID: userDoc['userID'],
    //         startTask: a['startTask'] ?? null,
    //         endTask: a['endTask'] ?? null,
    //         pointsEarned: a['pointsEarned'] ?? null,
    //       ));
    //     }
    //   }
    //
    //   taskList.add(TaskModel(
    //     taskTitle: a['taskTitle'],
    //     taskScore: a['taskScore'],
    //     taskDate: a['taskDate'],
    //     startTime: a['startTime'],
    //     endTime: a['endTime'],
    //     duration: a['duration'],
    //     assignMembers: members,
    //     id: a['id'],
    //   ));
    // }
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;

      // Access 'assignedMembers' from the task data
      List<Map<String, dynamic>> assignedMembers =
          List<Map<String, dynamic>>.from(a['assignMembers']);

      List<MemberModel> members = [];

      for (var memberData in assignedMembers) {
        String userId = memberData['userID'];

        DocumentSnapshot userDoc = await Collections.USERS.doc(userId).get();

        if (userDoc.exists) {
          members.add(MemberModel(
            displayName: userDoc['displayName'],
            imageUrl: userDoc['imageUrl'],
            userID: userDoc['userID'],
            // Access 'startTask', 'endTask', 'pointsEarned' from memberData
            startTask: memberData['startTask'] ?? null,
            endTask: memberData['endTask'] ?? null,
            pointsEarned: memberData['pointsEarned'] ?? null,
          ));
        }
      }

      taskList.add(TaskModel(
        taskTitle: a['taskTitle'],
        taskScore: a['taskScore'],
        taskDate: a['taskDate'],
        startTime: a['startTime'],
        endTime: a['endTime'],
        duration: a['duration'],
        assignMembers: members,
        id: a['id'],
      ));
    }

    for (int j = 0; j < taskList.length; j++) {
      taskList[j].assignMembers.any((map) =>
              (map.userID.toString() == userData.userID.toString()) &&
              ((DateFormat('yyyy-MM-dd HH:mm')
                      .parse(taskList[j].endTime)
                      .isBefore((DateTime.now()))) &&
                  ((map.startTask != null && map.endTask == null) ||
                      (map.startTask == null && map.endTask == null))))
          ? notCompletedTaskList.add(taskList[j])
          : taskList[j].assignMembers.any((map) =>
                  map.userID.toString() == userData.userID.toString() &&
                  ((map.startTask != null && map.endTask == null) ||
                      (map.startTask == null && map.endTask == null)))
              ? toBeCompletedTaskList.add(taskList[j])
              : taskList[j].assignMembers.any((map) =>
                      map.userID.toString() == userData.userID.toString() &&
                      map.endTask != null)
                  ? completedTaskList.add(taskList[j])
                  : toBeCompletedTaskList.add(taskList[j]);
    }
    return true;
  }

  deleteTask(groupID, taskID) async {
    await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .doc(taskID)
        .delete();
  }

  startTask(groupID, taskID, groupTitle) async {
    final DocumentReference documentReference = await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .doc(taskID);

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
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  fetchUser(userID) async {
    var document = await Collections.USERS.doc(userID.toString()).get();
    if (document.exists) {
      final UserModel user = UserModel.fromDocument(document.data()!);
      return user;
    }
  }

  endTask(groupID, taskID, List<MemberModel> StartTime, taskDurationInMin,
      points, groupTitle, List<MemberModel> adminList, myPoints) async {
    final DocumentReference documentReference = await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .doc(taskID);
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
              .difference(StartTime[index].startTask.toDate())
              .inMinutes;

          var pointPerMinute = taskDurationInMin / double.parse(points);
          var userPoint;
          for (int i = 0; i < int.parse(points); i++) {
            if (differenceInMinutes < pointPerMinute * (i + 1)) {
              userPoint = double.parse(points) - double.parse(i.toString());
              break;
            }
          }
          Map<String, dynamic> newVariable = {
            'endTask': DateTime.now(),
            'pointsEarned':
                userPoint.ceil().toString(), // Add the 4th variable here
          };
          existingArray[index]['endTask'] = newVariable['endTask'];
          existingArray[index]['pointsEarned'] = newVariable['pointsEarned'];
          // Update the document with the modified array
          final newMap = {
            'point': userPoint.ceil().toString(),
            'groupID': groupID.toString(),
          };

          final userDocRef = Collections.USERS.doc(userData.userID.toString());
          final userDoc = await userDocRef.get();
          if (userDoc.exists) {
            List<dynamic> pointsList =
                userDoc.get('points') ?? <Map<String, dynamic>>[];
            // Check if the 'points' array is empty, and add newMap in that case.
            if (pointsList.isEmpty) {
              pointsList.add(newMap);
            } else {
              bool groupIDMatch = false;
              for (var i = 0; i < pointsList.length; i++) {
                if (pointsList[i]['groupID'] == newMap['groupID']) {
                  // If 'groupID' already exists in the array, add 'point' to the existing value.
                  pointsList[i]['point'] =
                      (int.parse(userPoint.ceil().toString()) +
                          int.parse(pointsList[i]['point'].toString()));
                  groupIDMatch = true;
                  break;
                }
              }

              // If 'groupID' doesn't match with any existing entry, add newMap to the list.
              if (!groupIDMatch) {
                pointsList.add(newMap);
              }
            }
            await userDocRef.update({'points': pointsList});
          }
          await Collections.USERS
              .doc(userData.userID.toString())
              .get()
              .then((value) async {
            userData = UserModel.fromDocument(value.data());
          });
          documentReference.update({
            'assignMembers': existingArray,
          }).then((_) async {
            bool achieved = await goalAchieved(groupID, myPoints.toString());
            if (achieved) {
              var notiID = Collections.USERS
                  .doc(adminList[0].userID)
                  .collection(Collections.NOTIFICATIONS)
                  .doc();
              notiID.set({
                "read": false,
                "notificationType": 3,
                "notification": "you have earned " +
                    userPoint.ceil().toString() +
                    " points in ",
                "Time": DateTime.now(),
                "notiID": notiID.id,
                "notiImage": userData.imageUrl,
                "userName": userData.displayName.toString(),
                "userToJoin": FieldValue.arrayUnion([]),
                "groupID": groupID.toString(),
                "groupName": groupTitle.toString(),
              });
            }
            var notiID = Collections.USERS
                .doc(adminList[0].userID)
                .collection(Collections.NOTIFICATIONS)
                .doc();
            notiID.set({
              "read": false,
              "notificationType": 3,
              "notification": "you have earned " +
                  userPoint.ceil().toString() +
                  " points in ",
              "Time": DateTime.now(),
              "notiID": notiID.id,
              "notiImage": userData.imageUrl,
              "userName": userData.displayName.toString(),
              "userToJoin": FieldValue.arrayUnion([]),
              "groupID": groupID.toString(),
              "groupName": groupTitle.toString(),
            });
            Collections.USERS
                .doc(adminList[0].userID.toString())
                .get()
                .then((value) async {
              UserModel notiUserData = UserModel.fromDocument(value.data());
              var data = {
                'type': "request",
                'end_time': DateTime.now().toString(),
              };
              _notiController.sendNotifications(
                  notiUserData.fcmToken.toString(),
                  userData.displayName.toString() +
                      " has completed the task in " +
                      groupTitle.toString(),
                  data);
            });
            print('Document updated successfully');
          }).catchError((error) {
            print('Error updating document: $error');
          });
        } else {
          print("Task haven't started yet");
        }
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  Future<bool> goalAchieved(String groupId, String myGoalPoints) async {
    try {
      // Step 1: Check if the group exists
      DocumentSnapshot groupSnapshot = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get();

      if (groupSnapshot.exists) {
        // Step 2: Check if the "goals" subcollection exists
        QuerySnapshot goalsSnapshot = await FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('goals')
            .get();

        if (goalsSnapshot.docs.isNotEmpty) {
          // Step 3: Filter documents in the "goals" subcollection
          DateTime now = DateTime.now();

          List<Map<String, dynamic>> filteredGoals = [];

          for (QueryDocumentSnapshot goalDoc in goalsSnapshot.docs) {
            DateTime goalDate = goalDoc['goalDate']
                .toDate(); // Assuming 'goalDate' is a Timestamp field
            int goalPoints = int.parse(goalDoc['goalPoints'].toString());

            // Check conditions
            if (!goalDate.isAfter(now) &&
                goalPoints >= int.parse(myGoalPoints)) {
              filteredGoals.add(goalDoc.data() as Map<String, dynamic>);
            }
          }

          // Do something with filteredGoals
          print('Filtered Goals: $filteredGoals');
          return true;
        } else {
          print('No goals subcollection found for the group.');
          return false;
        }
      } else {
        print('Group with ID $groupId not found.');
        return false;
      }
    } catch (error) {
      print('Error: $error');
      return false;
    }
  }

  createGroup(
      groupName, groupImage, List<MemberModel> adminsList, membersList) async {
    List<Map<String, dynamic>> adminListData = adminsList
        .map((member) => {
              'displayName': member.displayName,
              'imageUrl': member.imageUrl,
              'userID': member.userID,
            })
        .toList();

    Random random = Random();
    int groupCode = 10000 + random.nextInt(90000);
    var groupID = Collections.GROUPS.doc().id;
    await Collections.GROUPS.doc(groupID).set({
      "groupCode": groupCode.toString(),
      "groupName": groupName,
      "groupImage": groupImage,
      "groupID": groupID.toString(),
      "adminsList": adminListData,
      "membersList": [],
      "date": DateTime.now(),
    });
    await Collections.USERS
        .doc(userDocId.value)
        .collection(Collections.MYGROUPS)
        .doc()
        .set({
      "groupCode": groupCode.toString(),
      "groupID": groupID,
      "groupName": groupName,
      "groupImage": groupImage,
    });
    return groupID;
  }

  addGroupTask(groupID, taskTitle, taskDate, String startTimeT, String endTimeT,
      taskScore, List<MemberModel> assignMembers) async {
    final DateFormat format = DateFormat('yyyy-MM-dd HH:mm');

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
        await Collections.GROUPS.doc(groupID).collection(Collections.TASKS);
    List<Map<String, dynamic>> assignMembersData = assignMembers
        .map((member) => {
              'displayName': member.displayName,
              'imageUrl': member.imageUrl,
              'userID': member.userID,
              'startTask': DateTime.parse(startTimeT),
            })
        .toList();
    String docId = ref.doc().id;
    await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .doc(docId)
        .set({
      "taskTitle": taskTitle,
      "taskDate": taskDate,
      "startTime": startTimeT,
      "endTime": endTimeT,
      "duration": hours < 0 ? (-hours).toString() : (hours).toString(),
      "taskScore": taskScore,
      "assignMembers": assignMembersData,
      "id": docId,
    });
    for (int a = 0; a < assignMembers.length; a++) {
      updateCounter(assignMembers[a].userID, groupID);
    }
    return;
  }

  updateCounter(userID, groupID, {clearCounter = false}) async {
    try {
      // Reference to the user's counters subcollection
      CollectionReference countersRef =
          Collections.USERS.doc(userID.toString()).collection('counters');

      // Query to find the document with the specified groupID
      QuerySnapshot querySnapshot =
          await countersRef.where('groupID', isEqualTo: groupID).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // If the document exists, increment the counter
        DocumentReference docRef = querySnapshot.docs.first.reference;
        await docRef
            .update({'counter': clearCounter ? 0 : FieldValue.increment(1)});
      } else {
        // If the document does not exist, create a new one with counter set to 1
        await countersRef
            .add({'groupID': groupID, 'counter': clearCounter ? 0 : 1});
      }
    } catch (e) {
      print('Error updating counter: $e');
      // Handle the error accordingly
    }
  }

  editGroupTask(taskID, groupID, taskTitle, taskDate, String startTimeT,
      String endTimeT, taskScore, List<MemberModel> assignMembers) async {
    final DateFormat format = DateFormat('yyyy-MM-dd HH:mm');

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
    List<Map<String, dynamic>> assignMembersData = assignMembers
        .map((member) => {
              'displayName': member.displayName,
              'imageUrl': member.imageUrl,
              'userID': member.userID,
            })
        .toList();
    await Collections.GROUPS
        .doc(groupID)
        .collection(Collections.TASKS)
        .doc(taskID)
        .update({
      "taskTitle": taskTitle,
      "taskDate": taskDate,
      "startTime": startTimeT,
      "endTime": endTimeT,
      "duration": hours < 0 ? (-hours).toString() : (hours).toString(),
      "taskScore": taskScore,
      "assignMembers": assignMembersData,
      "id": taskID,
    });
    return;
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

  Future<bool> isGoalAvailable(groupID) async {
    DocumentReference documentReference = Collections.GROUPS.doc(groupID);

    CollectionReference subcollectionReference =
        documentReference.collection('goals');

    QuerySnapshot subcollectionQuery = await subcollectionReference.get();

    return subcollectionQuery.docs.isNotEmpty;
  }
}
