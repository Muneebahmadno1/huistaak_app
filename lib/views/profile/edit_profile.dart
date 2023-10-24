import 'dart:io';

import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/app_images.dart';
import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../helper/data_helper.dart';
import '../../helper/page_navigation.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';
import '../home/bottom_nav_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final DataHelper _dataController = Get.find<DataHelper>();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool loader = false;
  late PickedFile pickedFile;
  String? imageUrl;
  File? imageFile;
  final picker = ImagePicker();
  bool processingStatus = false;
  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? pickedImage;
  final GlobalKey<FormState> profileField = GlobalKey();

  getData() {
    setState(() {
      nameController.text = userData.displayName ?? "";
      postalCodeController.text = userData.postalCode;
      imageUrl = userData.imageUrl;
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
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "Edit Profile",
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
      body: Form(
        key: key,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
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
                              : (userData.imageUrl != "" &&
                                      userData.imageUrl != null)
                                  ? NetworkImage(userData.imageUrl)
                                      as ImageProvider
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
                  height: 30,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Full Name:",
                        style: bodyNormal.copyWith(
                            color: AppColors.buttonColor,
                            fontFamily: "MontserratSemiBold"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: nameController,
                        validator: (value) =>
                            CustomValidator.isEmptyUserName(value),
                        hintText: "Robert Fox",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: Duration(milliseconds: 700),
                  slidingBeginOffset: Offset(0, -1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email address:",
                        style: bodyNormal.copyWith(
                            color: AppColors.buttonColor,
                            fontFamily: "MontserratSemiBold"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        readonly: true,
                        hintText: userData.email,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DelayedDisplay(
                  delay: Duration(milliseconds: 700),
                  slidingBeginOffset: Offset(0, -1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Postal Code of House:",
                        style: bodyNormal.copyWith(
                            color: AppColors.buttonColor,
                            fontFamily: "MontserratSemiBold"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: postalCodeController,
                        validator: (value) => CustomValidator.isEmpty(value),
                        hintText: "Postal Code",
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CustomButton(
                      buttonText: "Save Changes",
                      onTap: () async {
                        if (key.currentState!.validate()) {
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

                          await _dataController.editProfile(
                              nameController.text,
                              imageUrl,
                              postalCodeController.text,
                              phoneController.text);
                          setState(() {});
                          PageTransition.pageBackNavigation(
                              page: CustomBottomNavBar(
                            pageIndex: 2,
                          ));
                        }
                      },
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
