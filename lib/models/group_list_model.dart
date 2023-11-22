class GroupListModel {
  dynamic groupName;
  dynamic groupImage;
  dynamic groupID;

  GroupListModel({
    required this.groupName,
    required this.groupImage,
    required this.groupID,
  });

  factory GroupListModel.fromJson(Map<String, dynamic> data) {
    return GroupListModel(
      groupName: data['groupName'],
      groupImage: data['groupImage'],
      groupID: data['groupID'],
    );
  }
}
