import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../constants/app_images.dart';
import '../../../constants/custom_validators.dart';
import '../../../constants/global_variables.dart';
import '../../../controllers/data_controller.dart';
import '../../../controllers/group_controller.dart';
import '../../../widgets/custom_widgets.dart';
import '../../../widgets/text_form_fields.dart';
import '../group_detail.dart';

class CreateNewGroup extends StatefulWidget {
  const CreateNewGroup({super.key});

  @override
  State<CreateNewGroup> createState() => _CreateNewGroupState();
}

class _CreateNewGroupState extends State<CreateNewGroup> {
  final GroupController _groupController = Get.find<GroupController>();
  final HomeController _dataController = Get.find<HomeController>();
  TextEditingController groupNameEditingController = TextEditingController();
  bool creatingGroup = false;
  bool loader = false;
  late PickedFile pickedFile;
  String? imageUrl;
  File? imageFile;
  final picker = ImagePicker();
  bool processingStatus = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? pickedImage;
  final GlobalKey<FormState> groupFormField = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataController.groupAdmins.clear();
    _dataController.groupAdmins.add({
      'userID': userData.userID,
      'displayName': userData.displayName,
      'imageUrl': userData.imageUrl,
    });
    print(_dataController.groupAdmins);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Create New Group",
          onTap: () {
            Get.back();
          },
          leadingButton: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.buttonColor,
          ),
        ),
      ),
      body: Form(
        key: groupFormField,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SingleChildScrollView(
            child: Column(
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
                        "Group Photo:",
                        style:
                            headingSmall.copyWith(color: AppColors.buttonColor),
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
                        radius: 60,
                        backgroundColor: AppColors.buttonColor,
                        child: CircleAvatar(
                          radius: 58,
                          backgroundImage: imageFile != null
                              ? FileImage(imageFile!) as ImageProvider
                              : AssetImage(
                                  AppImages.profileImage,
                                ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 10,
                        child: ZoomTapAnimation(
                          onTap: () {
                            _upload("gallery");
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
                      style: bodyNormal.copyWith(
                          color: AppColors.buttonColor,
                          fontFamily: "MontserratSemiBold"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: CustomTextField(
                    controller: groupNameEditingController,
                    validator: (value) =>
                        CustomValidator.isEmptyUserName(value),
                    hintText: "My daily home tasks",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                // DelayedDisplay(
                //   delay: Duration(milliseconds: 700),
                //   slidingBeginOffset: Offset(0, -1),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Group Admin:",
                //       style: bodyNormal.copyWith(
                //           color: AppColors.buttonColor,
                //           fontFamily: "MontserratSemiBold"),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Obx(
                //   () => DelayedDisplay(
                //     delay: Duration(milliseconds: 800),
                //     slidingBeginOffset: Offset(0, 0),
                //     child: Row(
                //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         for (int i = 0;
                //             i < _dataController.groupAdmins.length;
                //             i++)
                //           Padding(
                //             padding: const EdgeInsets.only(right: 8.0),
                //             child: CircleAvatar(
                //               radius: 20,
                //               backgroundImage:
                //                   AssetImage("assets/images/man1.png"),
                //             ),
                //           ),
                //         // ZoomTapAnimation(
                //         //   onTap: () {
                //         //     Get.to(() => AddMember(from: 'admin'));
                //         //   },
                //         //   child: Container(
                //         //       height: 40,
                //         //       width: 40,
                //         //       decoration: BoxDecoration(
                //         //           color: Colors.white,
                //         //           shape: BoxShape.circle,
                //         //           image: DecorationImage(
                //         //               image: AssetImage(
                //         //                   "assets/images/dotted_border.png"))),
                //         //       child: Icon(
                //         //         Icons.add,
                //         //         color: AppColors.buttonColor,
                //         //       )),
                //         // ),
                //       ],
                //     ),
                //   ),
                // ),
                //
                // SizedBox(
                //   height: 20,
                // ),
                // DelayedDisplay(
                //   delay: Duration(milliseconds: 900),
                //   slidingBeginOffset: Offset(0, -1),
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       "Add Group Members:",
                //       style: bodyNormal.copyWith(
                //           color: AppColors.buttonColor,
                //           fontFamily: "MontserratSemiBold"),
                //     ),
                //   ),
                // ),
                //
                // SizedBox(
                //   height: 20,
                // ),
                // Obx(
                //   () => DelayedDisplay(
                //     delay: Duration(milliseconds: 800),
                //     slidingBeginOffset: Offset(0, 0),
                //     child: Row(
                //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         for (int i = 0;
                //             i < _dataController.groupMembers.length;
                //             i++)
                //           Padding(
                //             padding: const EdgeInsets.only(right: 8.0),
                //             child: CircleAvatar(
                //               radius: 20,
                //               backgroundImage:
                //                   AssetImage("assets/images/man1.png"),
                //             ),
                //           ),
                //         ZoomTapAnimation(
                //           onTap: () {
                //             Get.to(() => AddMember(
                //                   from: 'member',
                //                 ));
                //           },
                //           child: Container(
                //               height: 40,
                //               width: 40,
                //               decoration: BoxDecoration(
                //                   color: Colors.white,
                //                   shape: BoxShape.circle,
                //                   image: DecorationImage(
                //                       image: AssetImage(
                //                           "assets/images/dotted_border.png"))),
                //               child: Icon(
                //                 Icons.add,
                //                 color: AppColors.buttonColor,
                //               )),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: ZoomTapAnimation(
                    onTap: () async {
                      if (groupFormField.currentState!.validate()) {
                        setState(() {
                          creatingGroup = true;
                        });
                        var groupID = await _groupController.createGroup(
                            groupNameEditingController.text.toString(),
                            imageUrl,
                            _dataController.groupAdmins,
                            _dataController.groupMembers);
                        _dataController.groupAdmins.clear();
                        _dataController.groupMembers.clear();
                        Get.offAll(() => GroupDetail(
                              groupID: groupID,
                              groupTitle:
                                  groupNameEditingController.text.toString(),
                            ));
                        setState(() {
                          creatingGroup = false;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          creatingGroup
                              ? Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : Text(
                                  "Create Group",
                                  style: headingSmall.copyWith(
                                      color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _upload(String inputSource) async {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Huistaak",
        titleStyle: const TextStyle(
          color: AppColors.buttonColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        middleText: "",
        content: const Column(
          children: [
            Center(
                child: CircularProgressIndicator(
              color: AppColors.buttonColor,
            ))
          ],
        ));
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);
      setState(() {
        processingStatus = true;
      });
      final String fileName = path.basename(pickedImage!.path);
      try {
        // Uploading the selected image with some custom meta data
        {
          imageFile = File(pickedImage!.path);
          await storage.ref(fileName).putFile(imageFile!).then((p0) async {
            imageUrl = await p0.ref.getDownloadURL();
            setState(() {});
            if (p0.state == TaskState.success) {
              setState(() {
                processingStatus = false;
              });
            }
          });
        }
        // Refresh the UI
        Get.back();
        setState(() {});
      } on FirebaseException catch (error) {
        Get.back();
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      Get.back();
      if (kDebugMode) {
        print(err);
      }
    }
  }
}
