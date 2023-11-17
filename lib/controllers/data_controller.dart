import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/user_model.dart';
import 'notification_controller.dart';

class HomeController extends GetxController {
  final NotificationController _notiController =
      Get.find<NotificationController>();
  DateTime? selectedDate = DateTime.now();
  DateTime? goalSelectedDate = DateTime.now();
  RxString startTime = ''.obs;
  RxString endTime = ''.obs;
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
  }

  joinGroupRequest(groupID) async {
    String groupName = "";
    try {
      final newMap = {
        'displayName': userData.displayName.toString(),
        'imageUrl': userData.imageUrl.toString(),
        'userID': userData.userID.toString(),
      };
      var querySnapshot2 = await Collections.GROUPS
          .where("groupCode", isEqualTo: groupID.toString())
          .get();
      if (querySnapshot2.docs.isNotEmpty) {
        // Get the first document (assuming there's only one match)
        var documentSnapshot = querySnapshot2.docs.first;
        groupName = documentSnapshot['groupName'];
        // Retrieve data and add it to the adminList
        adminList.add({
          "adminsList": List.from(documentSnapshot['adminsList']),
          "membersList": List.from(documentSnapshot['membersList']),
        });
      }
      await Collections.GROUPS
          .where("groupCode", isEqualTo: groupID.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((QueryDocumentSnapshot doc) {
          // Update the document using the doc reference
          Collections.GROUPS.doc(doc.id).update({
            "membersList": FieldValue.arrayUnion([newMap])
          });
        });
      });
      var notiID = Collections.USERS
          .doc(adminList[0]['adminsList'][0]['userID'])
          .collection(Collections.NOTIFICATIONS)
          .doc();
      notiID.set({
        "read": false,
        "notificationType": 1,
        "notification": userData.displayName.toString() + " join ",
        "Time": DateTime.now(),
        "notiID": notiID.id,
        "groupID": groupID.toString(),
        "groupName": groupName.toString(),
      });
      Collections.USERS
          .doc(adminList[0]['adminsList'][0]['userID'].toString())
          .get()
          .then((value) async {
        UserModel notiUserData = UserModel.fromDocument(value.data());
        var data = {
          'type': "request",
          'end_time': DateTime.now().toString(),
        };
        _notiController.sendNotifications(notiUserData.fcmToken.toString(),
            userData.displayName.toString() + " join group ", data);
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
