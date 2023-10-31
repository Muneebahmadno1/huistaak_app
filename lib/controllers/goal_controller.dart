import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';

class GoalController extends GetxController {
  List<dynamic> groupList = [];
  List<dynamic> groupWithUserList = [];
  List<Map<String, dynamic>> goalList = [];

  getGoalPageData() async {
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
    QuerySnapshot querySnapshot2 =
        await FirebaseFirestore.instance.collection('groups').get();
    for (QueryDocumentSnapshot documentSnapshot1 in querySnapshot2.docs) {
      Map<String, dynamic> groupsData =
          documentSnapshot1.data() as Map<String, dynamic>;
      List<dynamic> mamberArray = groupsData['membersList'];
      for (var userMap in mamberArray)
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
      for (int i = 0; i < querySnapshot1.docs.length; i++) {
        var a = querySnapshot1.docs[i].data() as Map;

        goalList.add({
          "goalTitle": a['goalTitle'],
          "goalDate": a['goalDate'],
          "goalTime": a['goalTime'],
          "goalID": a['goalID'],
        });
      }
    }
  }

  addGroupGoal(groupID, goalTitle, goalDate, time, goalMembers) async {
    var doc = await Collections.GROUPS
        .doc(groupID.toString())
        .collection(Collections.GOALS)
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