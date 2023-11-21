class MemberModel {
  dynamic displayName;
  dynamic imageUrl;
  dynamic userID;
  dynamic startTask;
  dynamic endTask;
  dynamic pointsEarned;

  MemberModel({
    required this.displayName,
    required this.imageUrl,
    required this.userID,
    this.startTask,
    this.endTask,
    this.pointsEarned,
  });

  factory MemberModel.fromJson(Map<String, dynamic> data) {
    return MemberModel(
      displayName: data['displayName'],
      imageUrl: data['imageUrl'],
      userID: data['userID'],
      startTask: data['startTask'] ?? "",
      endTask: data['endTask'] ?? "",
      pointsEarned: data['pointsEarned'] ?? "",
    );
  }
}
