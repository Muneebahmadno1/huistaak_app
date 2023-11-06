class ChatUserModel {
  dynamic groupImage;
  dynamic groupName;
  dynamic date;
  dynamic id;

  ChatUserModel({
    required this.groupImage,
    required this.groupName,
    required this.date,
    required this.id,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> data) {
    return ChatUserModel(
      groupImage: data['groupImage'],
      groupName: data['points'],
      date: data['date'],
      id: data['id'],
    );
  }
}
