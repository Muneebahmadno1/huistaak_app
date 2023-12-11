import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/goal_details_model.dart';
import '../models/group_list_model.dart';
import '../models/user_model.dart';

class GoalController extends GetxController {
  List<GroupListModel> groupList = [];
  List<GroupListModel> groupWithUserList = [];
  List<GoalDetailsModel> goalList = [];

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
      groupList.add(GroupListModel(
        groupName: a['groupName'],
        groupImage: a['groupImage'],
        groupID: a['groupID'],
      ));
    }
    QuerySnapshot querySnapshot2 = await Collections.GROUPS.get();
    for (QueryDocumentSnapshot documentSnapshot1 in querySnapshot2.docs) {
      Map<String, dynamic> groupsData =
          documentSnapshot1.data() as Map<String, dynamic>;
      List<dynamic> memberArray = groupsData['membersList'];
      List<dynamic> adminArray = groupsData['adminsList'];
      for (var userMap in adminArray)
        if (userMap['userID'] == userData.userID) {
          groupWithUserList.add(GroupListModel(
            groupName: groupsData['groupName'],
            groupImage: groupsData['groupImage'],
            groupID: groupsData['groupID'],
          ));
        }
      for (var userMap in memberArray)
        if (userMap['userID'] == userData.userID) {
          groupWithUserList.add(GroupListModel(
            groupName: groupsData['groupName'],
            groupImage: groupsData['groupImage'],
            groupID: groupsData['groupID'],
          ));
        }
    }

    for (int i = 0; i < groupWithUserList.length; i++) {
      QuerySnapshot querySnapshot1 = await Collections.GROUPS
          .doc(groupWithUserList[i].groupID)
          .collection(Collections.GOALS)
          .get();
      for (int j = 0; j < querySnapshot1.docs.length; j++) {
        var a = querySnapshot1.docs[j].data() as Map;

        goalList.add(
          GoalDetailsModel(
              goalGroupName: groupWithUserList[i].groupName,
              goalGroupImage: groupWithUserList[i].groupImage,
              goalGroup: a['goalGroup'],
              goalTitle: a['goalTitle'],
              goalDate: a['goalDate'],
              goalTime: a['goalTime'],
              goalPoints: a['goalPoints'],
              goalID: a['goalID'],
              goalAddedTime: a['goalAddedTime']),
        );
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
      "goalPoints": goalPoints,
      "goalAddedTime": DateTime.now()
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

  Future<bool> groupWithNoGoal() async {
    // Assuming 'groups' is the name of your collection
    CollectionReference groupsCollection = Collections.GROUPS;

    for (GroupListModel groupData in groupList) {
      // Get the 'groupID' for each group
      String groupID = groupData.groupID;

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
      } else if (goalsQuery.docs.isEmpty) {
        return true;
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
      } else if (goalsQuery.docs.isEmpty) {
        groupsWithEmptyGoals.add({
          "groupName": groupData['groupName'],
          "groupImage": groupData['groupImage'],
          "groupID": groupData['groupID'],
        });
      }
    }

    return groupsWithEmptyGoals;
  }

  resetGroupPoints(String groupId) async {
    // Get a reference to the users collection
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    // Fetch all documents in the collection
    QuerySnapshot allUsers = await usersCollection.get();

    // Update the 'point' variable to "0" for each user with the specified groupId
    for (QueryDocumentSnapshot documentSnapshot in allUsers.docs) {
      // Get the data map for the current user
      Map<String, dynamic> userData =
          documentSnapshot.data() as Map<String, dynamic>;

      // Check if 'points' array is not null and is a List
      if (userData['points'] != null && userData['points'] is List) {
        // Iterate through the 'points' array and update 'point' variable for the matching 'groupID'
        List<dynamic> updatedPoints = List.from(userData['points']);
        for (int i = 0; i < updatedPoints.length; i++) {
          if (updatedPoints[i]['groupID'] == groupId) {
            // Update the 'point' variable to "0"
            updatedPoints[i]['point'] = '0';
          }
        }

        // Get the document reference for the current user
        DocumentReference userDocRef = usersCollection.doc(documentSnapshot.id);

        // Update the 'points' array in Firestore
        await userDocRef.update({'points': updatedPoints});
      }
    }
    Collections.USERS.doc(userData.userID.toString()).get().then((value) async {
      userData = UserModel.fromDocument(value.data());
    });
  }

  markCompleted(String groupId, userID, goalID) async {
    print(groupId);
    print(userID);
    print(goalID);
    DocumentReference goalDocRef = Collections.GROUPS
        .doc(groupId.toString())
        .collection(Collections.GOALS)
        .doc(goalID.toString());

    // Fetch the current data
    DocumentSnapshot goalDoc = await goalDocRef.get();

    if (goalDoc.exists) {
      // Get the current completedGoals array
      Map<String, dynamic>? data = goalDoc.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('completedGoals')) {
        // Get the current completedGoals array
        List<dynamic> completedGoals = data['completedGoals'];

        // Add the new userId to completedGoals array
        completedGoals.add(userID);

        // Update the completedGoals array in Firestore
        await goalDocRef.update({'completedGoals': completedGoals});
      } else {
        // If the 'completedGoals' field doesn't exist, initialize it with the new userId
        await goalDocRef.update({
          'completedGoals': [userID]
        });
      }
    } else {
      print('Goal document does not exist.');
    }
  }
}
