import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants/global_variables.dart';
import '../helper/collections.dart';
import '../models/user_model.dart';

class NotificationController extends GetxController {
  List<Map<String, dynamic>> notificationList = [];

  getNotifications() async {
    notificationList.clear();
    QuerySnapshot querySnapshot = await Collections.USERS
        .doc(userData.userID)
        .collection(Collections.NOTIFICATIONS)
        .orderBy('Time', descending: true)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      notificationList.add({
        "read": a['read'],
        "notification": a['notification'],
        "notificationType": a['notificationType'],
        "notiID": a['notiID'],
        "groupToJoinID": a['groupToJoinID'],
        "Time": a['Time'],
        "groupID": a['groupID'],
        "groupName": a['groupName'],
        "userToJoin": List.from(a['userToJoin'] ?? null),
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

  sendNotification(docID, endTime, groupName, groupID) {
    var notiID = Collections.USERS
        .doc(docID.toString())
        .collection(Collections.NOTIFICATIONS)
        .doc();
    notiID.set({
      "read": false,
      "notificationType": 2,
      "notification": userData.displayName.toString() +
          "assigned you a task in " +
          groupName.toString(),
      "userToJoin": FieldValue.arrayUnion([]),
      "Time": DateTime.now(),
      "notiID": notiID.id,
      "groupID": groupID.toString(),
      "groupName": groupName.toString(),
    });
    Collections.USERS.doc(docID.toString()).get().then((value) async {
      UserModel notiUserData = UserModel.fromDocument(value.data());
      var data = {
        'type': "scheduled",
        'end_time': DateTime.now().toString(),
      };
      sendNotifications(notiUserData.fcmToken.toString(),
          userData.displayName.toString() + " assigned you a task ", data);
    });
  }

  sendNotifications(deviceTokens, description, data) async {
    String url = "https://fcm.googleapis.com/fcm/send";

    var apiKey =
        'key=AAAAoKUwY_0:APA91bH9L1ChtMkNJfzY_T_B9hkRFj3osMkvkx0RhUUpL2UnOV3hJ8AEVRgdCpsKPREqYyXic7KE824DY5NLUBXX1oA9dshHBdSpvh2o7CGyTKVkUocGVjkxcnA5maXgRbJ9c8GH8Uyt';

    var apiData = {
      "registration_ids": [deviceTokens],
      "notification": {"title": 'Huistaak', "body": description.toString()},
      "data": data
    };

    print('APIDATA: $apiData');
    try {
      http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(apiData),
          headers: {
            "Authorization": "$apiKey",
            "Content-Type": "application/json"
          });
      print('RESPONSE.BODY: ${response.body}');
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("result545");
        print(result);
        if (result['success'] == 1) {
          return 'true';
        } else {
          return 'false';
        }
      } else {
        return "error";
      }
    } on Exception {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
