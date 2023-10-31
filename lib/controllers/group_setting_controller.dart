import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../helper/collections.dart';

class GroupSettingController extends GetxController {
  List<Map<String, dynamic>> taskList = [];
  List<Map<String, dynamic>> groupInfo = [];

  getGroupTaskList(groupID) async {
    QuerySnapshot querySnapshot =
        await Collections.GROUPS.doc(groupID).collection("tasks").get();
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
    var querySnapshot = await Collections.GROUPS.doc(groupID).get();
    groupInfo.add({
      "groupImage": querySnapshot['groupImage'],
      "groupName": querySnapshot['groupName'],
      "adminsList": List.from(querySnapshot['adminsList']),
      "membersList": List.from(querySnapshot['membersList']),
    });
  }
}
