import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/global_variables.dart';
import '../helper/collections.dart';

class NotificationController extends GetxController {
  List<Map<String, dynamic>> notificationList = [];

  getNotifications() async {
    QuerySnapshot querySnapshot = await Collections.USERS
        .doc(userData.userID)
        .collection(Collections.NOTIFICATIONS)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      notificationList.add({
        "notification": a['notification'],
        "notificationType": a['notificationType'],
        "notiID": a['notiID'],
        "groupToJoinID": a['groupToJoinID'],
        "Time": a['Time'],
        "userToJoin": List.from(a['userToJoin']),
      });
    }
  }

  deleteNotification(notiID) async {
    await Collections.USERS
        .doc(userData.userID.toString())
        .collection(Collections.NOTIFICATIONS)
        .doc(notiID)
        .delete();
  }

  sendNotification(docID) {
    var notiID = Collections.USERS
        .doc(docID.toString())
        .collection(Collections.NOTIFICATIONS)
        .doc();
    notiID.set({
      "notificationType": 2,
      "notification": userData.displayName.toString() + " assigned you a task ",
      "userToJoin": FieldValue.arrayUnion([]),
      "Time": DateTime.now(),
      "notiID": notiID,
    });
  }
}
