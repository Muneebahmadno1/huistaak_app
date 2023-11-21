import 'member_model.dart';

class TaskModel {
  dynamic taskTitle;
  dynamic taskScore;
  dynamic taskDate;
  dynamic startTime;
  dynamic endTime;
  dynamic duration;
  List<MemberModel> assignMembers;
  dynamic id;

  TaskModel({
    required this.taskTitle,
    required this.taskScore,
    required this.taskDate,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.assignMembers,
    required this.id,
  });

  factory TaskModel.fromJson(Map<String, dynamic> data) {
    return TaskModel(
      taskTitle: data['taskTitle'],
      taskScore: data['taskScore'],
      taskDate: data['taskDate'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      duration: data['duration'],
      assignMembers: List.from(data['assignMembers']),
      id: data['id'],
    );
  }
}
