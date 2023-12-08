class ChatUserModel {
  dynamic groupImage;
  dynamic groupName;
  dynamic date;
  dynamic id;
  dynamic createdAt;

  ChatUserModel({
    required this.groupImage,
    required this.groupName,
    required this.date,
    required this.id,
    required this.createdAt,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> data) {
    return ChatUserModel(
      createdAt: data['createdAt'],
      groupImage: data['groupImage'],
      groupName: data['points'],
      date: data['date'],
      id: data['id'],
    );
  }
}
