import 'member_model.dart';

class GroupDetailsModel {
  dynamic groupCode;
  dynamic groupImage;
  dynamic groupName;
  List<MemberModel> adminsList;
  List<MemberModel> membersList;

  GroupDetailsModel({
    required this.groupImage,
    required this.groupName,
    required this.groupCode,
    required this.adminsList,
    required this.membersList,
  });

  factory GroupDetailsModel.fromJson(Map<String, dynamic> data) {
    return GroupDetailsModel(
      groupImage: data['groupImage'],
      groupName: data['groupName'],
      groupCode: data['groupCode'],
      adminsList: List.from(data['adminsList']),
      membersList: List.from(data['membersList']),
    );
  }
}
