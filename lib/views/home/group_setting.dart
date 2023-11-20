import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/views/home/group_task_list.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../controllers/general_controller.dart';
import '../../controllers/group_setting_controller.dart';
import '../../helper/page_navigation.dart';
import '../../helper/shimmers_loaders.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_widgets.dart';
import 'bottom_nav_bar.dart';

class GroupSetting extends StatefulWidget {
  final groupID;

  const GroupSetting({super.key, required this.groupID});

  @override
  State<GroupSetting> createState() => _GroupSettingState();
}

class _GroupSettingState extends State<GroupSetting> {
  final GroupSettingController _groupSettingController =
      Get.find<GroupSettingController>();
  bool isLoading = false;
  bool Loading = false;
  bool imageChangeLoading = false;
  bool adminLoading = false;
  bool memberLoading = false;
  List<UserModel> adminList = [];
  List<UserModel> memberList = [];

  getData() async {
    setState(() {
      adminList.clear();
      memberList.clear();
      isLoading = true;
      adminLoading = true;
      memberLoading = true;
    });
    await _groupSettingController.getGroupInfo(widget.groupID.toString());
    setState(() {
      isLoading = false;
    });

    for (int i = 0;
        i < _groupSettingController.groupInfo[0]['adminsList'].length;
        i++) {
      adminList.add(await _groupSettingController.fetchUser(
          _groupSettingController.groupInfo[0]['adminsList'][i]['userID']
              .toString()));
    }
    for (int i = 0;
        i < _groupSettingController.groupInfo[0]['membersList'].length;
        i++) {
      memberList.add(await _groupSettingController.fetchUser(
          _groupSettingController.groupInfo[0]['membersList'][i]['userID']
              .toString()));
    }
    setState(() {
      adminLoading = false;
      memberLoading = false;
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
          pageTitle: "Group Details",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.buttonColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: isLoading == true
              ? Center(
                  child: Padding(
                  padding: EdgeInsets.only(top: 25.h),
                  child: CircularProgressIndicator(color: Colors.white),
                ))
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0, -1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Group ID: ",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SelectableText(
                        _groupSettingController.groupInfo[0]['groupCode']
                            .toString(),
                        style: bodyNormal.copyWith(
                            color: Colors.black,
                            fontFamily: "MontserratSemiBold")),
                    SizedBox(
                      height: 20,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 300),
                      slidingBeginOffset: Offset(0, -1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Group Photo:",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 400),
                      slidingBeginOffset: Offset(0, 0),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70, // Adjust the radius as needed
                            backgroundColor: Colors
                                .grey, // You can set a default background color
                            child: imageChangeLoading
                                ? Center(child: CircularProgressIndicator())
                                : ClipOval(
                                    child: SizedBox(
                                      height: 70 * 2,
                                      width: 70 * 2,
                                      child: _groupSettingController
                                                  .groupInfo[0]['groupImage'] ==
                                              null
                                          ? Image.asset(
                                              AppImages
                                                  .groupIcon, // Replace with your asset image path
                                              fit: BoxFit.fitHeight,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl: _groupSettingController
                                                  .groupInfo[0]['groupImage'],
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 10,
                            child: ZoomTapAnimation(
                              onTap: () async {
                                setState(() {
                                  imageChangeLoading = true;
                                });
                                await _groupSettingController.upload(
                                    "gallery", widget.groupID.toString());
                                await getData();
                                setState(() {
                                  imageChangeLoading = false;
                                });
                              },
                              onLongTap: () {},
                              enableLongTapRepeatEvent: false,
                              longTapRepeatDuration:
                                  const Duration(milliseconds: 100),
                              begin: 1.0,
                              end: 0.93,
                              beginDuration: const Duration(milliseconds: 20),
                              endDuration: const Duration(milliseconds: 120),
                              beginCurve: Curves.decelerate,
                              endCurve: Curves.fastOutSlowIn,
                              child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.buttonColor,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 500),
                      slidingBeginOffset: Offset(0, -1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Group Name:",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          )),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0, 0),
                      child: TextFormField(
                        readOnly: true,
                        style: bodyNormal.copyWith(
                            fontFamily: "MontserratSemiBold"),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Colors
                                    .black26, // Make the border transparent
                                width:
                                    1, // Set the width to 0 to make it disappear
                              ),
                            ),
                            hintText: _groupSettingController.groupInfo[0]
                                ['groupName'],
                            hintStyle: bodyNormal.copyWith(
                                color: Colors.black,
                                fontFamily: "MontserratSemiBold"),
                            prefixIconColor: Colors.white,
                            prefixIconConstraints: const BoxConstraints(
                              maxHeight: 30,
                              minHeight: 30,
                            )),
                      ),
                      // CustomTextField(
                      //     hintText: groupInfo[0]['groupName'])
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 600),
                      slidingBeginOffset: Offset(0, 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: ZoomTapAnimation(
                          onTap: () {
                            Get.to(() => GroupTaskList(
                                  groupID: widget.groupID,
                                ));
                          },
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Group Task List",
                                      style: bodyLarge.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 700),
                      slidingBeginOffset: Offset(0, -1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Group Admins:",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    adminLoading
                        ? Shimmers.employeeListShimmer()
                        : ListView.builder(
                            itemCount: _groupSettingController
                                .groupInfo[0]['adminsList'].length,
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 16),
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, i) {
                              return DelayedDisplay(
                                delay: Duration(milliseconds: 800),
                                slidingBeginOffset: Offset(0, -1),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        // Adjust the radius as needed
                                        backgroundColor: Colors.grey,
                                        // You can set a default background color
                                        child: ClipOval(
                                          child: SizedBox(
                                            height: 30 * 2,
                                            width: 30 * 2,
                                            child: adminList[i].imageUrl == ""
                                                ? Image.asset(
                                                    AppImages.profileImage,
                                                    // Replace with your asset image path
                                                    fit: BoxFit.fitHeight,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl:
                                                        adminList[i].imageUrl,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 25.w,
                                            child: Text(
                                              _groupSettingController
                                                          .groupInfo[0]
                                                      ['adminsList'][i]
                                                  ['displayName'],
                                              maxLines: 1,
                                              style: headingMedium,
                                            ),
                                          ),
                                          Text(
                                            "Group Admin",
                                            style: bodyNormal.copyWith(
                                                color: Colors.black26),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 25.w,
                                      ),
                                      Icon(
                                        Icons.admin_panel_settings_rounded,
                                        color: AppColors.buttonColor,
                                        size: 3.h,
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                    SizedBox(
                      height: 20,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 900),
                      slidingBeginOffset: Offset(0, -1),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Group Members:",
                            style: headingSmall.copyWith(
                                color: AppColors.buttonColor),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    memberLoading
                        ? Shimmers.employeeListShimmer()
                        : _groupSettingController
                                .groupInfo[0]['membersList'].isEmpty
                            ? Text(
                                "No member have joined group yet.",
                                style: bodySmall.copyWith(color: Colors.grey),
                              )
                            : ListView.builder(
                                itemCount: _groupSettingController
                                    .groupInfo[0]['membersList'].length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 16),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, j) {
                                  return DelayedDisplay(
                                    delay: Duration(milliseconds: 1000),
                                    slidingBeginOffset: Offset(0, -1),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 14.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            // Adjust the radius as needed
                                            backgroundColor: Colors.grey,
                                            // You can set a default background color
                                            child: ClipOval(
                                              child: SizedBox(
                                                height: 30 * 2,
                                                width: 30 * 2,
                                                child: _groupSettingController
                                                                    .groupInfo[0]
                                                                ['membersList']
                                                            [j]['imageUrl'] ==
                                                        ""
                                                    ? Image.asset(
                                                        AppImages.profileImage,
                                                        // Replace with your asset image path
                                                        fit: BoxFit.fitHeight,
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl: _groupSettingController
                                                                    .groupInfo[0]
                                                                ['membersList']
                                                            [j]['imageUrl'],
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                        fit: BoxFit.fill,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              width: 25.w,
                                              child: Text(
                                                _groupSettingController
                                                            .groupInfo[0]
                                                        ['membersList'][j]
                                                    ['displayName'],
                                                maxLines: 1,
                                                style: headingMedium,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25.w,
                                          ),
                                          _groupSettingController.groupInfo[0]
                                                      ['adminsList']
                                                  .any((map) =>
                                                      map['userID']
                                                          .toString() ==
                                                      userData.userID
                                                          .toString())
                                              ? InkWell(
                                                  onTap: () async {
                                                    confirmPopUp(context,
                                                        "Are you sure, you want to remove this member",
                                                        () async {
                                                      await _groupSettingController
                                                          .removeMember(
                                                        _groupSettingController
                                                                    .groupInfo[0]
                                                                ['membersList']
                                                            [j]['userID'],
                                                        widget.groupID
                                                            .toString(),
                                                      );
                                                      getData();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ))
                                              : SizedBox.shrink(),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          _groupSettingController.groupInfo[0]
                                                      ['adminsList']
                                                  .any((map) =>
                                                      map['userID']
                                                          .toString() ==
                                                      userData.userID
                                                          .toString())
                                              ? InkWell(
                                                  onTap: () async {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (context) {
                                                          return StatefulBuilder(
                                                              builder: (context,
                                                                  setState) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              elevation: 0,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13)),
                                                              // title: Text("Notice"),
                                                              // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
                                                              actions: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        alignment:
                                                                            Alignment
                                                                                .center,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              18.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Icon(
                                                                                Icons.admin_panel_settings_rounded,
                                                                                color: AppColors.buttonColor,
                                                                                size: 5.h,
                                                                              ),
                                                                              // Image.asset(
                                                                              //   AppImages.logo1,
                                                                              //   color: AppColors.buttonColor,
                                                                              //   height: 5.h,
                                                                              // ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                                                                                child: Text(
                                                                                  "Are you sure, you want to make this member admin",
                                                                                  textAlign: TextAlign.center,
                                                                                  style: TextStyle(
                                                                                    height: 1.4,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontFamily: 'Poppins',
                                                                                    color: Colors.black,
                                                                                    fontSize: 17,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 20,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  TextButton(
                                                                                    child: Text(
                                                                                      "No",
                                                                                      style: bodyNormal.copyWith(color: Colors.black),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () async {
                                                                                      await _groupSettingController.makeAdmin(_groupSettingController.groupInfo[0]['membersList'][j]['userID'], widget.groupID.toString(), _groupSettingController.groupInfo[0]['groupName'].toString());
                                                                                      getData();
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Yes",
                                                                                      style: bodyNormal.copyWith(color: Colors.red),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )),
                                                                  ],
                                                                ),
                                                              ],
                                                            );
                                                            ;
                                                          });
                                                        });
                                                  },
                                                  child: Icon(
                                                    Icons.add_moderator,
                                                    color:
                                                        AppColors.buttonColor,
                                                    size: 3.h,
                                                  ))
                                              : SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 1100),
                      slidingBeginOffset: Offset(0, 0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: ZoomTapAnimation(
                          onTap: () {
                            // _showPopup(context);
                          },
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                thickness: 1.2,
                                color: AppColors.buttonColor,
                              )),
                              Expanded(
                                  child: Divider(
                                thickness: 1.2,
                                color: AppColors.buttonColor,
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 1200),
                      slidingBeginOffset: Offset(0, 0),
                      child: ZoomTapAnimation(
                        onTap: () async {
                          setState(() {
                            Loading = true;
                          });
                          await _groupSettingController.leaveGroup(
                              widget.groupID.toString(),
                              _groupSettingController.groupInfo[0]['groupName']
                                  .toString());
                          Get.find<GeneralController>().onBottomBarTapped(0);
                          PageTransition.pageProperNavigation(
                              page: CustomBottomNavBar());
                          setState(() {
                            Loading = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Loading
                                ? Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.white))
                                : Text(
                                    "Leave this group",
                                    style: headingSmall.copyWith(
                                        color: Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: 1200),
                      slidingBeginOffset: Offset(0, 0),
                      child: ZoomTapAnimation(
                        onTap: () async {
                          openWhatsApp(_groupSettingController.groupInfo[0]
                                  ['groupCode']
                              .toString());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Share Group Code",
                              style: headingSmall.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void openWhatsApp(message) async {
    String encodedMessage = Uri.encodeComponent(message);
    var whatsappAndroid = Uri.parse("whatsapp://send?text=$encodedMessage");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
}
