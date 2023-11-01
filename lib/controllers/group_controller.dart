import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/user_model.dart';

class GroupController extends GetxController {
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> groupInfo = [];

  getGroupDetails(groupID, groupTitle) async {
    groupInfo.clear();
    taskList.clear();
    var querySnapshot1 = await Collections.GROUPS.doc(groupID).get();
    groupInfo.add({
      "groupImage": querySnapshot1['groupImage'],
      "groupName": querySnapshot1['groupName'],
      "adminsList": List.from(querySnapshot1['adminsList']),
      "membersList": List.from(querySnapshot1['membersList']),
    });
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
        "duration": a['duration'],
        "assignMembers": List.from(a['assignMembers']),
        "id": a['id'],
      });
    }
  }

  startTask(groupID, taskID, groupTitle) {
    final DocumentReference documentReference = Collections.GROUPS
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
      }
    }).catchError((error) {
      print('Error fetching document: $error');
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
        .collection(Collections.MYGROUPS)
        .doc()
        .set({
      "groupID": groupID,
      "groupName": groupName,
      "groupImage": groupImage,
    });
    return groupID;
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
        await Collections.GROUPS.doc(groupID).collection(Collections.TASKS);

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
      "assignMembers": assignMembers,
      "id": docId,
    });
    return;
  }
}
