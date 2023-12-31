import 'package:cached_network_image/cached_network_image.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/views/profile/change_password.dart';
import 'package:huistaak/views/profile/edit_profile.dart';
import 'package:huistaak/widgets/card_widget.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../controllers/auth_controller.dart';
import '../../helper/page_navigation.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int totalPoints = 0;
  final AuthController _authController = Get.find<AuthController>();
  getData() {
    if (userData.points.isNotEmpty) {
      // Calculate the sum of 'point' variables for the desired 'GroupID'

      for (var pointEntry in userData.points) {
        totalPoints = (int.parse(totalPoints.toString()) +
            int.parse(pointEntry['point'].toString()));
      }
    }
    print(totalPoints);
    setState(() {});
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
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 78.h,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                children: [
                  DelayedDisplay(
                    delay: Duration(milliseconds: 300),
                    slidingBeginOffset: Offset(0, -1),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Profile",
                        style: headingLarge.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      DelayedDisplay(
                        delay: Duration(milliseconds: 400),
                        slidingBeginOffset: Offset(0, 0),
                        child: CircleAvatar(
                          radius: 37, // Adjust the radius as needed
                          backgroundColor: Colors
                              .grey, // You can set a default background color
                          child: ClipOval(
                            child: SizedBox(
                              height: 37 * 2,
                              width: 37 * 2,
                              child: userData.imageUrl == ""
                                  ? Image.asset(
                                      AppImages
                                          .profileImage, // Replace with your asset image path
                                      fit: BoxFit.cover,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: userData.imageUrl,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: DelayedDisplay(
                          delay: Duration(milliseconds: 500),
                          slidingBeginOffset: Offset(0, -1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userData.displayName,
                                style: bodyNormal.copyWith(
                                  fontFamily: "MontserratBold",
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                totalPoints.toString() + " points",
                                style: bodySmall.copyWith(
                                    color: AppColors.buttonColor, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  // DelayedDisplay(
                  //   delay: Duration(milliseconds: 600),
                  //   slidingBeginOffset: Offset(0, 0),
                  //   child: ZoomTapAnimation(
                  //     onTap: () {
                  //       Get.to(() => ChoosePlan());
                  //     },
                  //     child: Container(
                  //       height: 100,
                  //       width: double.infinity,
                  //       padding: EdgeInsets.symmetric(horizontal: 20),
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(20),
                  //           color: AppColors.buttonColor),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                 height: 22,
                  //                 width: 48,
                  //                 decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(6)),
                  //                 child: Center(
                  //                   child: Text(
                  //                     "PRO",
                  //                     style:
                  //                         headingSmall.copyWith(fontSize: 13),
                  //                   ),
                  //                 ),
                  //               ),
                  //               SizedBox(
                  //                 height: 6,
                  //               ),
                  //               Text(
                  //                 "Upgrade to Premium",
                  //                 style: headingSmall.copyWith(
                  //                     color: Colors.white),
                  //               ),
                  //               Text(
                  //                 "This subscription is auto-renewable",
                  //                 style: bodyNormal.copyWith(
                  //                     fontSize: 13, color: Colors.white),
                  //               ),
                  //             ],
                  //           ),
                  //           Icon(
                  //             Icons.arrow_forward_ios,
                  //             size: 18,
                  //             color: Colors.white,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 700),
                    slidingBeginOffset: Offset(0, 0),
                    child: CustomCard(
                      onTap: () {
                        Get.to(() => EditProfile());
                      },
                      suffixIcon: Icon(
                        Icons.person,
                        color: AppColors.buttonColor,
                      ),
                      cardText: "Edit Profile",
                      leadingIcon: Icon(
                        Icons.navigate_next,
                        color: AppColors.buttonColor,
                        size: 36,
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 800),
                    slidingBeginOffset: Offset(0, 0),
                    child: CustomCard(
                      onTap: () {
                        Get.to(() => ChangePassword());
                      },
                      suffixIcon: Icon(
                        Icons.lock,
                        color: AppColors.buttonColor,
                      ),
                      cardText: "Change Password",
                      leadingIcon: Icon(
                        Icons.navigate_next,
                        color: AppColors.buttonColor,
                        size: 36,
                      ),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(milliseconds: 900),
                    slidingBeginOffset: Offset(0, 0),
                    child: CustomCard(
                      onTap: () {
                        _authController.clearFcm();
                        setUserLoggedIn(false);
                        FirebaseAuth.instance.signOut();
                        PageTransition.pageProperNavigation(
                            page: const LoginScreen());
                      },
                      suffixIcon: Icon(
                        Icons.logout,
                        color: AppColors.buttonColor,
                      ),
                      cardText: "Logout",
                      leadingIcon: Icon(
                        Icons.navigate_next,
                        color: AppColors.buttonColor,
                        size: 36,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
