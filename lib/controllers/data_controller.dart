import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/user_model.dart';
import '../views/home/connected_groups.dart';

class DataController extends GetxController {
  DateTime? selectedDate = DateTime.now();
  DateTime? goalSelectedDate = DateTime.now();
  RxString startTime = '09:00 AM'.obs;
  RxString endTime = '10:00 AM'.obs;
  List<dynamic> chatUsers = [];
  List<Map<String, dynamic>> adminList = [];
  RxList<Map<String, dynamic>> groupAdmins = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> groupMembers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignTaskMember = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignGoalMember = <Map<String, dynamic>>[].obs;

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
        .collection(Collections.MYGROUPS)
        .doc()
        .set({
      "groupID": groupID,
      "groupName": groupName,
      "groupImage": groupImage,
    });

    return;
  }

  getAllUserGroups() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('groups').get();
    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> groupsData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> mamberArray = groupsData['membersList'];
      List<dynamic> adminArray = groupsData['adminsList'];
      for (var userMap in adminArray)
        if (userMap['userID'] == userData.userID) {
          chatUsers.add({
            "groupImage": groupsData['groupImage'],
            "groupName": groupsData['groupName'],
            "id": documentSnapshot.id,
          });
        }
      for (var userMap in mamberArray)
        if (userMap['userID'] == userData.userID) {
          chatUsers.add({
            "groupImage": groupsData['groupImage'],
            "groupName": groupsData['groupName'],
            "id": documentSnapshot.id,
          });
        }
    }
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
        .collection(Collections.NOTIFICATIONS)
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
        .collection(Collections.NOTIFICATIONS)
        .doc(notiID)
        .delete();
  }

  sendNotification(docID) {
    var notiID = Collections.USERS
        .doc(docID.toString())
        .collection(Collections.NOTIFICATIONS)
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
      "duration": hours < 0 ? (-hours).toString() : (hours).toString(),
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
    final DocumentReference documentReference = Collections.GROUPS
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
}
