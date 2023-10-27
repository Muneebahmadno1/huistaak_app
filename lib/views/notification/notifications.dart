import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../helper/data_helper.dart';
import '../../widgets/custom_widgets.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final DataHelper _dataController = Get.find<DataHelper>();
  List<Map<String, dynamic>> notificationList = [];
  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userData.userID)
        .collection("notifications")
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i].data() as Map;
      setState(() {
        notificationList.add({
          "notification": a['notification'],
          "notificationType": a['notificationType'],
          "notiID": a['notiID'],
          "groupToJoinID": a['groupToJoinID'],
          "Time": a['Time'],
          "userToJoin": List.from(a['userToJoin']),
        });
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Notifications",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios,
            color: AppColors.buttonColor,
            size: 20,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : notificationList.isEmpty
              ? Center(child: Text("No notification for now"))
              : Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 80.h,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: notificationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: DelayedDisplay(
                                    delay: const Duration(milliseconds: 150),
                                    slidingBeginOffset: const Offset(0, 1),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                          width: double.infinity,
                                          height: 80,
                                          color: Colors.white12,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 26,
                                                backgroundImage:
                                                    userData.imageUrl == ""
                                                        ? AssetImage(
                                                            AppImages
                                                                .profileImage,
                                                          )
                                                        : NetworkImage(
                                                            userData.imageUrl,
                                                          ) as ImageProvider,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 12,
                                                      ),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 74.w,
                                                                maxHeight: 44),
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            notificationList[
                                                                    index][
                                                                'notification'],
                                                            style: bodyNormal,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Text(
                                                        DateFormat(
                                                                'yyyy-MM-dd _ kk:mm a')
                                                            .format(DateTime.parse(
                                                                notificationList[
                                                                            index]
                                                                        ['Time']
                                                                    .toDate()
                                                                    .toString()))
                                                            .toString(),
                                                        style:
                                                            bodySmall.copyWith(
                                                                color: Colors
                                                                    .black45),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        notificationList[index]
                                                    ['notificationType'] ==
                                                1
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await _dataController.joinGroup(
                                                          notificationList[
                                                                      index][
                                                                  'groupToJoinID']
                                                              .toString(),
                                                          notificationList[
                                                                      index]
                                                                  ['userToJoin']
                                                              [0]);
                                                      await _dataController
                                                          .deleteNotification(
                                                              notificationList[
                                                                          index]
                                                                      ['notiID']
                                                                  .toString());
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .buttonColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        width: 20.w,
                                                        child: Center(
                                                            child: Text(
                                                          "Accept",
                                                          style: bodyNormal
                                                              .copyWith(
                                                                  color: Colors
                                                                      .white),
                                                        ))),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        await _dataController
                                                            .deleteNotification(
                                                                notificationList[
                                                                            index]
                                                                        [
                                                                        'notiID']
                                                                    .toString());
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.all(8),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          ),
                                                          width: 20.w,
                                                          child: Center(
                                                              child: Text(
                                                            "Reject",
                                                            style: bodyNormal
                                                                .copyWith(
                                                                    color: Colors
                                                                        .white),
                                                          ))),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SizedBox.shrink()
                                      ],
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                            //   Slidable(
                            //   closeOnScroll: true,
                            //   // Specify a key if the Slidable is dismissible.
                            //   key: ValueKey(0),
                            //   // The end action pane is the one at the right or the bottom side.
                            //   endActionPane: ActionPane(
                            //     // A motion is a widget used to control how the pane animates.
                            //     motion: ScrollMotion(),
                            //
                            //     // A pane can dismiss the Slidable.
                            //     dismissible:
                            //         DismissiblePane(onDismissed: () {}),
                            //
                            //     // All actions are defined in the children parameter.
                            //     children: [
                            //       // A SlidableAction can have an icon and/or a label.
                            //       SlidableAction(
                            //         backgroundColor: Color(0xFFFE4A49),
                            //         foregroundColor: Colors.white,
                            //         icon: Icons.delete,
                            //         label: 'Delete',
                            //         onPressed: (BuildContext context) {},
                            //       ),
                            //       // SlidableAction(
                            //       //   backgroundColor: Color(0xFF21B7CA),
                            //       //   foregroundColor: Colors.white,
                            //       //   icon: Icons.share,
                            //       //   label: 'Share',
                            //       //   onPressed: (BuildContext context) {},
                            //       // ),
                            //     ],
                            //   ),
                            //
                            //   // The child of the Slidable is what the user sees when the
                            //   // component is not dragged.
                            //   child: Column(
                            //     children: [
                            //       InkWell(
                            //         onTap: () {},
                            //         child: DelayedDisplay(
                            //           delay: const Duration(milliseconds: 150),
                            //           slidingBeginOffset: const Offset(0, 1),
                            //           child: Container(
                            //             padding: const EdgeInsets.symmetric(
                            //                 horizontal: 14, vertical: 10),
                            //             width: double.infinity,
                            //             height: 80,
                            //             color: Colors.white12,
                            //             child: Row(
                            //               children: [
                            //                 CircleAvatar(
                            //                   radius: 26,
                            //                   backgroundColor:
                            //                       Colors.yellowAccent,
                            //                 ),
                            //                 Column(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment.center,
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.end,
                            //                   children: [
                            //                     Row(
                            //                       mainAxisAlignment:
                            //                           MainAxisAlignment.start,
                            //                       children: [
                            //                         SizedBox(
                            //                           width: 12,
                            //                         ),
                            //                         ConstrainedBox(
                            //                           constraints:
                            //                               BoxConstraints(
                            //                                   maxWidth: 74.w,
                            //                                   maxHeight: 44),
                            //                           child: Align(
                            //                             alignment: Alignment
                            //                                 .centerLeft,
                            //                             child: Text(
                            //                               notificationList[
                            //                                       index]
                            //                                   ['notification'],
                            //                               style: bodyNormal,
                            //                               overflow: TextOverflow
                            //                                   .ellipsis,
                            //                               maxLines: 2,
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ],
                            //                     ),
                            //                     Align(
                            //                         alignment:
                            //                             Alignment.bottomRight,
                            //                         child: Text(
                            //                           "08:00 PM",
                            //                           style: bodySmall.copyWith(
                            //                               color: index == 0
                            //                                   ? Colors.black45
                            //                                   : Colors.white30),
                            //                         )),
                            //                   ],
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Divider()
                            //     ],
                            //   ),
                            // );
                          }),
                    ),
                  ],
                ),
    );
  }
}
