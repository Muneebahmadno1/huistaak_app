class NotificationModel {
  dynamic read;
  dynamic notification;
  dynamic notificationType;
  dynamic notiID;
  dynamic notiImage;
  dynamic groupToJoinID;
  dynamic Time;
  dynamic groupID;
  dynamic groupName;
  dynamic userName;
  List<dynamic> userToJoin;

  NotificationModel({
    this.notiImage =
        "https://firebasestorage.googleapis.com/v0/b/huistaak-b26cd.appspot.com/o/Ellipse%20425.png?alt=media&token=39ef01fd-faeb-4237-aad0-229a71531287",
    required this.read,
    required this.notification,
    required this.notificationType,
    required this.notiID,
    required this.groupToJoinID,
    required this.Time,
    required this.groupID,
    required this.groupName,
    required this.userName,
    required this.userToJoin,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> a) {
    return NotificationModel(
      notiImage: a['notiImage'],
      read: a['read'],
      notification: a['notification'],
      notificationType: a['notificationType'],
      notiID: a['notiID'],
      groupToJoinID: a['groupToJoinID'],
      Time: a['Time'],
      groupID: a['groupID'],
      groupName: a['groupName'],
      userName: a['userName'] ?? null,
      userToJoin: a['userToJoin'] == null ? [] : List.from(a['userToJoin']),
    );
  }
}
