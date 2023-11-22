class GoalDetailsModel {
  dynamic goalGroupName;
  dynamic goalGroupImage;
  dynamic goalGroup;
  dynamic goalTitle;
  dynamic goalDate;
  dynamic goalTime;
  dynamic goalPoints;
  dynamic goalID;

  GoalDetailsModel({
    required this.goalGroupName,
    required this.goalGroupImage,
    required this.goalGroup,
    required this.goalTitle,
    required this.goalDate,
    required this.goalTime,
    required this.goalPoints,
    required this.goalID,
  });

  factory GoalDetailsModel.fromJson(Map<String, dynamic> data) {
    return GoalDetailsModel(
      goalGroupName: data['goalGroupName'],
      goalGroupImage: data['goalGroupImage'],
      goalGroup: data['goalGroup'],
      goalTitle: data['goalTitle'],
      goalDate: data['goalDate'],
      goalTime: data['goalTime'],
      goalPoints: data['goalPoints'],
      goalID: data['goalID'],
    );
  }
}
