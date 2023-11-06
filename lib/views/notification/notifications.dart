import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../controllers/data_controller.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../helper/page_navigation.dart';
import '../../widgets/custom_widgets.dart';
import '../home/bottom_nav_bar.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final NotificationController _notiController =
      Get.find<NotificationController>();
  final HomeController _dataController = Get.find<HomeController>();

  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    await _notiController.getNotifications();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference collectionReference = firebaseFirestore
        .collection('users')
        .doc(userData.userID.toString())
        .collection("notifications");

    QuerySnapshot querySnapshot = await collectionReference.get();

    querySnapshot.docs.forEach((doc) {
      collectionReference.doc(doc.id).update({
        'read':
            true, // Change 'fieldNameToUpdate' to the field you want to update
      });
    });
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
            Get.find<GeneralController>().onBottomBarTapped(0);
            PageTransition.pageProperNavigation(page: CustomBottomNavBar());
          },
          leadingButton: Icon(
            Icons.arrow_back_ios,
            color: AppColors.buttonColor,
            size: 20,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : _notiController.notificationList.isEmpty
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
                          itemCount: _notiController.notificationList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Slidable(
                                  closeOnScroll: true,
                                  // Specify a key if the Slidable is dismissible.
                                  key: ValueKey(0),
                                  // The end action pane is the one at the right or the bottom side.
                                  endActionPane: ActionPane(
                                    // A motion is a widget used to control how the pane animates.
                                    motion: ScrollMotion(),

                                    // A pane can dismiss the Slidable.
                                    dismissible:
                                        DismissiblePane(onDismissed: () {
                                      _notiController.deleteNotification(
                                          _notiController
                                              .notificationList[index]['notiID']
                                              .toString());
                                    }),

                                    // All actions are defined in the children parameter.
                                    children: [
                                      // A SlidableAction can have an icon and/or a label.
                                      SlidableAction(
                                        backgroundColor: Color(0xFFFE4A49),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                        onPressed: (BuildContext context) {
                                          _notiController.deleteNotification(
                                              _notiController
                                                  .notificationList[index]
                                                      ['notiID']
                                                  .toString());
                                        },
                                      ),
                                      // SlidableAction(
                                      //   backgroundColor: Color(0xFF21B7CA),
                                      //   foregroundColor: Colors.white,
                                      //   icon: Icons.share,
                                      //   label: 'Share',
                                      //   onPressed: (BuildContext context) {},
                                      // ),
                                    ],
                                  ),
                                  child: InkWell(
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 12,
                                                        ),
                                                        ConstrainedBox(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxWidth:
                                                                      74.w,
                                                                  maxHeight:
                                                                      44),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              _notiController
                                                                          .notificationList[
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
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          DateFormat(
                                                                  'yyyy-MM-dd kk:mm a')
                                                              .format(DateTime.parse(
                                                                  _notiController
                                                                      .notificationList[
                                                                          index]
                                                                          [
                                                                          'Time']
                                                                      .toDate()
                                                                      .toString()))
                                                              .toString(),
                                                          style: bodySmall
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black45),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // _notiController.notificationList[
                                          //                 index]
                                          //             ['notificationType'] ==
                                          //         1
                                          //     ? Row(
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment.center,
                                          //         children: [
                                          //           InkWell(
                                          //             onTap: () async {
                                          //               await _dataController.joinGroup(
                                          //                   _notiController
                                          //                       .notificationList[
                                          //                           index][
                                          //                           'groupToJoinID']
                                          //                       .toString(),
                                          //                   _notiController
                                          //                               .notificationList[
                                          //                           index][
                                          //                       'userToJoin'][0]);
                                          //               await _notiController
                                          //                   .deleteNotification(
                                          //                       _notiController
                                          //                           .notificationList[
                                          //                               index][
                                          //                               'notiID']
                                          //                           .toString());
                                          //               Get.find<
                                          //                       GeneralController>()
                                          //                   .onBottomBarTapped(
                                          //                       0);
                                          //               PageTransition
                                          //                   .pageProperNavigation(
                                          //                       page:
                                          //                           CustomBottomNavBar());
                                          //             },
                                          //             child: Container(
                                          //                 padding:
                                          //                     EdgeInsets.all(8),
                                          //                 decoration:
                                          //                     BoxDecoration(
                                          //                   color: AppColors
                                          //                       .buttonColor,
                                          //                   borderRadius:
                                          //                       BorderRadius
                                          //                           .circular(
                                          //                               5),
                                          //                 ),
                                          //                 width: 20.w,
                                          //                 child: Center(
                                          //                     child: Text(
                                          //                   "Accept",
                                          //                   style: bodyNormal
                                          //                       .copyWith(
                                          //                           color: Colors
                                          //                               .white),
                                          //                 ))),
                                          //           ),
                                          //           Padding(
                                          //             padding:
                                          //                 const EdgeInsets.only(
                                          //                     left: 8.0),
                                          //             child: InkWell(
                                          //               onTap: () async {
                                          //                 await _notiController
                                          //                     .deleteNotification(
                                          //                         _notiController
                                          //                             .notificationList[
                                          //                                 index]
                                          //                                 [
                                          //                                 'notiID']
                                          //                             .toString());
                                          //                 Get.find<
                                          //                         GeneralController>()
                                          //                     .onBottomBarTapped(
                                          //                         0);
                                          //                 PageTransition
                                          //                     .pageProperNavigation(
                                          //                         page:
                                          //                             CustomBottomNavBar());
                                          //               },
                                          //               child: Container(
                                          //                   padding:
                                          //                       EdgeInsets.all(
                                          //                           8),
                                          //                   decoration:
                                          //                       BoxDecoration(
                                          //                     color: Colors.red,
                                          //                     borderRadius:
                                          //                         BorderRadius
                                          //                             .circular(
                                          //                                 5),
                                          //                   ),
                                          //                   width: 20.w,
                                          //                   child: Center(
                                          //                       child: Text(
                                          //                     "Reject",
                                          //                     style: bodyNormal
                                          //                         .copyWith(
                                          //                             color: Colors
                                          //                                 .white),
                                          //                   ))),
                                          //             ),
                                          //           )
                                          //         ],
                                          //       )
                                          //     : SizedBox.shrink()
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider()
                              ],
                            );
                          }),
                    ),
                  ],
                ),
    );
  }
}
