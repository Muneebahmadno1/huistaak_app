class NotificationsModel {
  String title;
  String time;

  NotificationsModel({
    required this.title,
    required this.time,
  });
}

List<NotificationsModel> notifications = [
  NotificationsModel(
      title: "The yearly fees is now on discount", time: "06:00 PM"),
];
