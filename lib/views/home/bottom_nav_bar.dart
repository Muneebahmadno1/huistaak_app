import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/constants/global_variables.dart';
import 'package:huistaak/controllers/general_controller.dart';
import 'package:huistaak/views/goals/new_goals_screen.dart';
import 'package:huistaak/views/home/connected_groups.dart';
import 'package:huistaak/views/profile/profile_screen.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

class CustomBottomNavBar extends StatefulWidget {
  final pageIndex;
  CustomBottomNavBar({Key? key, this.pageIndex = 0}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final GeneralController _generalController = Get.find<GeneralController>();
  int selectedIndex = 0;

  final List<Widget> _pages = [
    ConnectedGroupScreen(),
    NewGoalsScreen(),
    ProfileScreen(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[_generalController.currentIndex],
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: Colors.white,
          waterDropColor: AppColors.buttonColor,
          onItemSelected: (int index) {
            _generalController.onBottomBarTapped(index);
            setState(() {
              selectedIndex = index;
            });
          },
          selectedIndex: selectedIndex,
          bottomPadding: 20,
          barItems: <BarItem>[
            BarItem(
              filledIcon: Icons.home_filled,
              outlinedIcon: Icons.home_outlined,
            ),
            BarItem(
                filledIcon: Icons.circle, outlinedIcon: Icons.circle_outlined),
            BarItem(
              filledIcon: Icons.person_2,
              outlinedIcon: Icons.person_2_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
