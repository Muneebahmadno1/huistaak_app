import 'package:cloud_firestore/cloud_firestore.dart';

class Collections {
  static var USERS = FirebaseFirestore.instance.collection('users');
  static var GROUPS = FirebaseFirestore.instance.collection('groups');

  //subcollections
  static String NOTIFICATIONS = 'comments';
  static String MYGROUPS = 'statistics';
}
