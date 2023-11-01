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
  RxString startTime = '09:00 AM'.obs;
  RxString endTime = '10:00 AM'.obs;
  List<dynamic> chatUsers = [];
  List<Map<String, dynamic>> adminList = [];
  RxList<Map<String, dynamic>> groupAdmins = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> groupMembers = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignTaskMember = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> assignGoalMember = <Map<String, dynamic>>[].obs;

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
    print("_dataController.chatUsers");
    print(chatUsers);
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
    Collections.USERS
        .doc(adminList[0]['adminsList'][0]['userID'].toString())
        .get()
        .then((value) async {
      UserModel notiUserData = UserModel.fromDocument(value.data());
      _notiController.sendNotifications(notiUserData.fcmToken.toString(),
          userData.displayName.toString() + " requested to join group ");
    });
    return;
  }

  joinGroup(groupID, Map<String, dynamic> newMap) async {
    await Collections.GROUPS.doc(groupID).update({
      "membersList": FieldValue.arrayUnion([newMap])
    });
  }
}
