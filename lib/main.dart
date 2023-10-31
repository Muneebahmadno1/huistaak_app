import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huistaak/controllers/general_controller.dart';
import 'package:huistaak/splash_screen.dart';
import 'package:sizer/sizer.dart';

import 'controllers/auth_controller.dart';
import 'controllers/data_controller.dart';
import 'controllers/goal_controller.dart';
import 'controllers/group_controller.dart';
import 'controllers/group_setting_controller.dart';
import 'controllers/notification_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(DataController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialBinding: InitialBinding(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'Huistaak',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      );
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(GeneralController());
    Get.put(AuthController());
    Get.put(DataController());
    Get.put(GoalController());
    Get.put(GroupSettingController());
    Get.put(GroupController());
    Get.put(NotificationController());
    // Get.put(NotificationController());
    // Get.put(PricingController());
    // Get.put(ShiftController());
  }
}
