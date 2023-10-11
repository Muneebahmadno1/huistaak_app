import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constants/app_images.dart';
import '../../constants/global_variables.dart';
import '../../widgets/custom_widgets.dart';
import '../home/bottom_nav_bar.dart';

class ChoosePlan extends StatefulWidget {
  const ChoosePlan({super.key});

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  int selectedId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "",
          onTap: () {
            Get.off(() => CustomBottomNavBar());
          },
          leadingButton: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(
              AppImages.cancelButton,
              color: Colors.black,
              height: 26,
            ),
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 86.h,
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 200,
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 300),
                    slidingBeginOffset: Offset(0, 0),
                    child: Image.asset(
                      "assets/images/choose_plan.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  slidingBeginOffset: Offset(0, -1),
                  child: Text(
                    "Upgrade to Premium",
                    style: headingLarge,
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 500),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 10),
                    child: Text(
                      "No commitment, cancel anytime",
                      style: bodyNormal.copyWith(
                          color: Colors.black54,
                          fontFamily: "MontserratSemiBold"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(child: const SizedBox()),
                DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedId = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                width: 1.2,
                                color: selectedId == 0
                                    ? AppColors.buttonColor
                                    : Colors.black12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Monthly",
                                    style: headingMedium.copyWith(
                                        color: AppColors.buttonColor),
                                  ),
                                  FittedBox(
                                    child: Row(
                                      children: [
                                        Text(
                                          "\$ ",
                                          style:
                                              bodySmall.copyWith(fontSize: 12),
                                        ),
                                        Text(
                                          "19.99",
                                          style: headingMedium.copyWith(
                                              fontSize: 20,
                                              color: AppColors.buttonColor),
                                        ),
                                        Text(
                                          " / monthly offer trial ends, cancel any time",
                                          style:
                                              bodySmall.copyWith(fontSize: 9),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 22,
                              width: 22,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: selectedId == 0 ? 2 : 1.2,
                                      color: selectedId == 0
                                          ? Colors.transparent
                                          : Colors.black12),
                                  shape: BoxShape.circle,
                                  color: selectedId == 0
                                      ? AppColors.buttonColor
                                      : Colors.white54),
                              child: selectedId == 0
                                  ? Center(
                                      child: Icon(
                                      Icons.check,
                                      size: 18,
                                      color: Colors.white,
                                    ))
                                  : SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 700),
                  slidingBeginOffset: Offset(0, 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedId = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 90,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                width: 1.2,
                                color: selectedId == 1
                                    ? AppColors.buttonColor
                                    : Colors.black12)),
                        child: Stack(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Yearly",
                                        style: headingMedium.copyWith(
                                            color: AppColors.buttonColor),
                                      ),
                                      FittedBox(
                                        child: Row(
                                          children: [
                                            Text(
                                              "\$ ",
                                              style: bodySmall.copyWith(
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              "129.99",
                                              style: headingMedium.copyWith(
                                                  color: AppColors.buttonColor,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              " / yearly offer trial ends, cancel any time",
                                              style: bodySmall.copyWith(
                                                  fontSize: 9),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: selectedId == 1 ? 2 : 1.2,
                                          color: selectedId == 1
                                              ? Colors.transparent
                                              : Colors.black12),
                                      shape: BoxShape.circle,
                                      color: selectedId == 1
                                          ? AppColors.buttonColor
                                          : Colors.transparent),
                                  child: selectedId == 1
                                      ? Center(
                                          child: Icon(
                                            Icons.check,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 25,
                              child: Container(
                                height: 30,
                                width: 90,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: AppColors.buttonColor),
                                child: Center(
                                  child: Text(
                                    "Cheapest",
                                    style: headingSmall.copyWith(
                                        fontSize: 11, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: const SizedBox()),
                DelayedDisplay(
                  delay: Duration(milliseconds: 800),
                  slidingBeginOffset: Offset(0, -1),
                  child: Text(
                    "Free for 3 days",
                    style: headingSmall.copyWith(
                        color: AppColors.buttonColor,
                        fontFamily: "MontserratSemiBold"),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 900),
                  slidingBeginOffset: Offset(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 8),
                    child: CustomButton(
                      buttonText: "Start free Trail",
                      onTap: () {},
                    ),
                  ),
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 1000),
                  slidingBeginOffset: Offset(0, -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Privacy Policy",
                          style: bodySmall.copyWith(
                              fontFamily: "MontserratSemiBold"),
                        ),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.black,
                        ),
                        Text(
                          "Restore Purchase",
                          style: bodySmall.copyWith(
                              fontFamily: "MontserratSemiBold"),
                        ),
                        Container(
                          height: 20,
                          width: 1,
                          color: Colors.black,
                        ),
                        Text(
                          "Terms of use",
                          style: bodySmall.copyWith(
                              fontFamily: "MontserratSemiBold"),
                        ),
                      ],
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 22.0),
                //   child: Text(
                //     "You can cancel your subscription or trial anytime by cancelling your subscription through your iTunes account settings, or it will automatically renew. This must be done 24 hours before the end of the trial or any subscription period to avoid being charged. Subscription",
                //     style: bodySmall,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
