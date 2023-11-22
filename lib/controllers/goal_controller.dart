import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';

class GoalController extends GetxController {
  List<dynamic> groupList = [];
  List<dynamic> groupWithUserList = [];
  List<Map<String, dynamic>> goalList = [];

  getGoalPageData() async {
    groupList.clear();
    groupWithUserList.clear();
    goalList.clear();
    QuerySnapshot querySnapshot = await Collections.USERS
        .doc(userData.userID)
        .collection(Collections.MYGROUPS)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;

      groupList.add({
        "groupName": a['groupName'],
        "groupImage": a['groupImage'],
        "groupID": a['groupID'],
      });
    }
    QuerySnapshot querySnapshot2 = await Collections.GROUPS.get();
    for (QueryDocumentSnapshot documentSnapshot1 in querySnapshot2.docs) {
      Map<String, dynamic> groupsData =
          documentSnapshot1.data() as Map<String, dynamic>;
      List<dynamic> memberArray = groupsData['membersList'];
      List<dynamic> adminArray = groupsData['adminsList'];
      for (var userMap in adminArray)
        if (userMap['userID'] == userData.userID) {
          groupWithUserList.add({
            "groupID": groupsData['groupID'],
            "groupImage": groupsData['groupImage'],
            "groupName": groupsData['groupName'],
            "id": documentSnapshot1.id,
          });
        }
      for (var userMap in memberArray)
        if (userMap['userID'] == userData.userID) {
          groupWithUserList.add({
            "groupID": groupsData['groupID'],
            "groupImage": groupsData['groupImage'],
            "groupName": groupsData['groupName'],
            "id": documentSnapshot1.id,
          });
        }
    }

    for (int i = 0; i < groupWithUserList.length; i++) {
      QuerySnapshot querySnapshot1 = await Collections.GROUPS
          .doc(groupWithUserList[i]['groupID'])
          .collection(Collections.GOALS)
          .get();
      for (int j = 0; j < querySnapshot1.docs.length; j++) {
        var a = querySnapshot1.docs[j].data() as Map;

        goalList.add({
          "goalGroupName": groupWithUserList[i]['groupName'],
          "goalGroupImage": groupWithUserList[i]['groupImage'],
          "goalGroup": a['goalGroup'],
          "goalTitle": a['goalTitle'],
          "goalDate": a['goalDate'],
          "goalTime": a['goalTime'],
          "goalPoints": a['goalPoints'],
          "goalID": a['goalID'],
        });
      }
    }
  }

  deleteGoal(goalGroup, goalID) async {
    await Collections.GROUPS
        .doc(goalGroup)
        .collection(Collections.GOALS)
        .doc(goalID)
        .delete();
  }

  addGroupGoal(
      groupID, goalTitle, goalDate, time, goalMembers, goalPoints) async {
    var doc = await Collections.GROUPS
        .doc(groupID.toString())
        .collection(Collections.GOALS)
        .doc();
    doc.set({
      "goalGroup": groupID.toString(),
      "goalID": doc.id,
      "goalTitle": goalTitle,
      "goalDate": goalDate,
      "goalTime": time,
      "goalMembers": goalMembers,
      "goalPoints": goalPoints
    });
    return;
  }

  editGroupGoal(goalID, groupID, goalTitle, goalDate, time, goalMembers,
      goalPoints) async {
    await Collections.GROUPS
        .doc(groupID.toString())
        .collection(Collections.GOALS)
        .doc(goalID)
        .update({
      "goalGroup": groupID.toString(),
      "goalID": goalID.toString(),
      "goalTitle": goalTitle,
      "goalDate": goalDate,
      "goalTime": time,
      "goalMembers": goalMembers,
      "goalPoints": goalPoints
    });
    return;
  }

  // Future<bool> groupWithNoGoal() async {
  //   // Assuming 'groups' is the name of your collection
  //   CollectionReference groupsCollection = Collections.GROUPS;
  //   for (Map<String, dynamic> groupData in groupList) {
  //     // Get the 'groupID' for each group
  //     String groupID = groupData['groupID'];
  //
  //     // Reference to the 'goals' subcollection
  //     CollectionReference goalsCollection =
  //         groupsCollection.doc(groupID).collection('goals');
  //
  //     // Query the 'goals' subcollection
  //     QuerySnapshot goalsQuery = await goalsCollection.get();
  //
  //     // Check if the 'goals' subcollection is not empty
  //     if (goalsQuery.docs.isEmpty ||
  //         goalsQuery.docs.first['goalDate'].toDate().isBefore(DateTime.now())) {
  //       return true;
  //     }
  //   }
  //
  //   // If none of the groups have a non-empty 'goals' subcollection, return false
  //   return false;
  // }

  Future<bool> groupWithNoGoal() async {
    // Assuming 'groups' is the name of your collection
    CollectionReference groupsCollection = Collections.GROUPS;

    for (Map<String, dynamic> groupData in groupList) {
      // Get the 'groupID' for each group
      String groupID = groupData['groupID'];

      // Reference to the 'goals' subcollection
      CollectionReference goalsCollection =
          groupsCollection.doc(groupID).collection('goals');

      // Query the 'goals' subcollection
      QuerySnapshot goalsQuery = await goalsCollection.get();

      // Check if the 'goals' subcollection is not empty
      if (goalsQuery.docs.isNotEmpty) {
        // Check if all goals are expired
        if (goalsQuery.docs.every((goalDoc) =>
            goalDoc['goalDate'].toDate().isBefore(DateTime.now()))) {
          return true; // All goals are expired
        }
      }
    }

    // If none of the groups have a non-empty 'goals' subcollection or not all goals are expired, return false
    return false;
  }

  Future<List<dynamic>> getGroupsWithEmptyGoals(String userID) async {
    List<dynamic> groupsWithEmptyGoals = [];

    CollectionReference myGroupsCollection =
        Collections.USERS.doc(userID).collection(Collections.MYGROUPS);

    QuerySnapshot querySnapshot = await myGroupsCollection.get();

    for (QueryDocumentSnapshot groupDoc in querySnapshot.docs) {
      // Get the data of the group
      Map<String, dynamic> groupData = groupDoc.data() as Map<String, dynamic>;

      // Reference to the 'goals' subcollection
      CollectionReference goalsCollection =
          Collections.GROUPS.doc(groupData['groupID']).collection('goals');

      // Query the 'goals' subcollection
      QuerySnapshot goalsQuery = await goalsCollection.get();

      // Check if the 'goals' subcollection is empty
      // if (goalsQuery.docs.isEmpty ||
      //     goalsQuery.docs.first['goalDate'].toDate().isBefore(DateTime.now())) {
      //   groupsWithEmptyGoals.add({
      //     "groupName": groupData['groupName'],
      //     "groupImage": groupData['groupImage'],
      //     "groupID": groupData['groupID'],
      //   });
      // }
      if (goalsQuery.docs.isNotEmpty) {
        // Check if all goals are expired
        if (goalsQuery.docs.every((goalDoc) =>
            goalDoc['goalDate'].toDate().isBefore(DateTime.now()))) {
          groupsWithEmptyGoals.add({
            "groupName": groupData['groupName'],
            "groupImage": groupData['groupImage'],
            "groupID": groupData['groupID'],
          });
        }
      }
    }

    return groupsWithEmptyGoals;
  }
}
