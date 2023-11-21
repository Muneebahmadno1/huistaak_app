// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:huistaak/constants/global_variables.dart';
// import 'package:huistaak/views/home/widgets/add_members_widget.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../../controllers/data_controller.dart';
// import '../../../widgets/custom_widgets.dart';
//
// class AddMember extends StatefulWidget {
//   final String from;
//
//   const AddMember({super.key, required this.from});
//
//   @override
//   State<AddMember> createState() => _AddMemberState();
// }
//
// class _AddMemberState extends State<AddMember> {
//   List<int> selectedIndex = [];
//   final HomeController _dataController = Get.find<HomeController>();
//   bool isLoading = false;
//
//   getData() async {
//     setState(() {
//       isLoading = true;
//     });
//     await _dataController.getGroupMember();
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         title: CustomAppBar(
//           pageTitle: "Add Member",
//           onTap: () {
//             Get.back();
//           },
//           leadingButton: Icon(
//             Icons.arrow_back_ios,
//             color: AppColors.buttonColor,
//             size: 20,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18.0),
//         child: isLoading
//             ? Center(
//                 child: Padding(
//                 padding: EdgeInsets.only(top: 25.h),
//                 child: CircularProgressIndicator(color: Colors.white),
//               ))
//             : Column(
//                 children: [
//                   _dataController.userList.isEmpty
//                       ? Center(
//                           child: Padding(
//                             padding: EdgeInsets.only(top: 25.h),
//                             child: Container(
//                               child: Text("No User Available"),
//                             ),
//                           ),
//                         )
//                       : Expanded(
//                           child: ListView.builder(
//                               itemCount: _dataController.userList.length,
//                               itemBuilder: (c, i) {
//                                 return InkWell(
//                                   onTap: () {
//                                     if (selectedIndex.contains(i) &&
//                                         (widget.from == "member"
//                                             ? _dataController.groupMembers.any(
//                                                 (map) =>
//                                                     map['userID'] ==
//                                                     _dataController.userList[i]
//                                                         ['userID'])
//                                             : _dataController.groupAdmins.any(
//                                                 (map) =>
//                                                     map['userID'] ==
//                                                     _dataController.userList[i]
//                                                         ['userID']))) {
//                                       selectedIndex.remove(i);
//                                       widget.from == "member"
//                                           ? _dataController.groupMembers
//                                               .removeWhere((map) =>
//                                                   map['userID'] ==
//                                                   _dataController.userList[i]
//                                                       ['userID'])
//                                           : _dataController.groupAdmins
//                                               .removeWhere((map) =>
//                                                   map['userID'] ==
//                                                   _dataController.userList[i]
//                                                       ['userID']);
//                                     } else {
//                                       selectedIndex.add(i);
//                                       widget.from == "member"
//                                           ? _dataController.groupMembers.add({
//                                               'userID': _dataController
//                                                   .userList[i]['userID'],
//                                               'displayName': _dataController
//                                                   .userList[i]['displayName'],
//                                               'imageUrl': _dataController
//                                                   .userList[i]['imageUrl']
//                                             })
//                                           : _dataController.groupAdmins.add({
//                                               'userID': _dataController
//                                                   .userList[i]['userID'],
//                                               'displayName': _dataController
//                                                   .userList[i]['displayName'],
//                                               'imageUrl': _dataController
//                                                   .userList[i]['imageUrl']
//                                             });
//                                     }
//                                     setState(() {
//                                       print(selectedIndex);
//                                       print(widget.from == "member"
//                                           ? _dataController.groupMembers
//                                           : _dataController.groupAdmins);
//                                     });
//                                   },
//                                   child: AddMemberWidget(
//                                     suffixIcon: "assets/images/man1.png",
//                                     isActive: selectedIndex.contains(i),
//                                     title: _dataController.userList[i]
//                                         ['displayName'],
//                                   ),
//                                 );
//                               }),
//                         )
//                 ],
//               ),
//       ),
//     );
//   }
// }
