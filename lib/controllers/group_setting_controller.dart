import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';

class GroupSettingController extends GetxController {
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> groupInfo = [];

  getGroupTaskList(groupID) async {
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
      "groupImage": querySnapshot['groupImage'],
      "groupName": querySnapshot['groupName'],
      "adminsList": List.from(querySnapshot['adminsList']),
      "membersList": List.from(querySnapshot['membersList']),
    });
  }

  leaveGroup(groupID) async {
    if (groupInfo[0]['membersList'].isNotEmpty) {
      groupInfo[0]['membersList']
          .removeWhere((map) => map['userID'] == userData.userID.toString());

      if (groupInfo[0]['membersList'].isNotEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'membersList': groupInfo[0]['membersList']});
      } else {
        Collections.GROUPS.doc(groupID.toString()).delete();
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
      } else if (groupInfo[0]['adminsList'].isEmpty) {
        Collections.GROUPS
            .doc(groupID.toString())
            .update({'adminsList': groupInfo[0]['adminsList']});
      }
    }
  }
}
