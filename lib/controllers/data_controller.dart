import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import 'notification_controller.dart';

class HomeController extends GetxController {
  final NotificationController _notiController =
      Get.find<NotificationController>();
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
  List<dynamic> userList = [];
  List<dynamic> groupList = [];
  List<dynamic> groupMemberList = [];

  getAllUserGroups() async {
    chatUsers.clear();
    QuerySnapshot querySnapshot = await Collections.GROUPS.get();
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
            'date': groupsData['date'],
            "id": documentSnapshot.id,
          });
        }
      for (var userMap in mamberArray)
        if (userMap['userID'] == userData.userID) {
          chatUsers.add({
            "groupImage": groupsData['groupImage'],
            "groupName": groupsData['groupName'],
            'date': groupsData['date'],
            "id": documentSnapshot.id,
          });
        }
    }
    print("_dataController.chatUsers");
    print(chatUsers);
  }

  joinGroupRequest(groupID) async {
    try {
      final newMap = {
        'displayName': userData.displayName.toString(),
        'imageUrl': userData.imageUrl.toString(),
        'userID': userData.userID.toString(),
      };
      var querySnapshot2 =
          await Collections.GROUPS.doc(groupID.toString()).get();

      adminList.add({
        "adminsList": List.from(querySnapshot2['adminsList']),
        "membersList": List.from(querySnapshot2['membersList']),
      });

      await Collections.GROUPS.doc(groupID).update({
        "membersList": FieldValue.arrayUnion([newMap])
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  joinGroup(groupID, Map<String, dynamic> newMap) async {
    await Collections.GROUPS.doc(groupID).update({
      "membersList": FieldValue.arrayUnion([newMap])
    });
  }

  getGroupMember() async {
    userList.clear();
    QuerySnapshot querySnapshot = await Collections.USERS
        .where("userID", isNotEqualTo: userData.userID.toString())
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      userList.add({
        "displayName": a['displayName'],
        "imageUrl": a['imageUrl'],
        "userID": a['userID'],
      });
    }
  }

  getTaskMember(groupID) async {
    userList.clear();
    DocumentSnapshot querySnapshot =
        await Collections.GROUPS.doc(groupID.toString()).get();

    if (querySnapshot.exists) {
      var data = querySnapshot.data() as Map<String, dynamic>;

      if (data.containsKey('membersList')) {
        List<dynamic> membersList = data['membersList'];

        for (int i = 0; i < membersList.length; i++) {
          var memberData = membersList[i] as Map<String, dynamic>;

          userList.add({
            "displayName": memberData['displayName'],
            "imageUrl": memberData['imageUrl'],
            "userID": memberData['userID'],
          });
        }
      }
      if (data.containsKey('adminsList')) {
        List<dynamic> membersList = data['adminsList'];

        for (int i = 0; i < membersList.length; i++) {
          var memberData = membersList[i] as Map<String, dynamic>;

          userList.add({
            "displayName": memberData['displayName'],
            "imageUrl": memberData['imageUrl'],
            "userID": memberData['userID'],
          });
        }
      }
    }

    // userList.add({
    //   "membersList": List.from(querySnapshot['membersList']),
    //   "adminsList": List.from(querySnapshot['adminsList']),
    // });
  }
}
