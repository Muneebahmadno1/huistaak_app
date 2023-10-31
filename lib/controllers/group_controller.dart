import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../helper/collections.dart';

class GroupController extends GetxController {
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> groupInfo = [];

  getGroupDetails(groupID, groupTitle) async {
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
        "Duration": a['Duration'],
        "assignMembers": List.from(a['assignMembers']),
        "id": a['id'],
      });
    }
  }
}
