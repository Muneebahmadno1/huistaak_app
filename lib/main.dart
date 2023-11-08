import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:huistaak/controllers/general_controller.dart';
import 'package:huistaak/splash_screen.dart';
import 'package:huistaak/views/notification/notifications.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'controllers/auth_controller.dart';
import 'controllers/data_controller.dart';
import 'controllers/goal_controller.dart';
import 'controllers/group_controller.dart';
import 'controllers/group_setting_controller.dart';
import 'controllers/notification_controller.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("_firebaseMessagingBackgroundHandler");
  await Firebase.initializeApp();
  FirebaseMessaging.onMessageOpenedApp.listen((_handleMessage));
  print("message");
  print(message);
}

void _handleMessage(RemoteMessage message) {
  print("_handleMessage");
  print(message.data);
  print("message");
  print(message);
  Get.offAll(const Notifications());
}

void onSelectNotification(String? payload) {
  print("onSelectNotification");
  print("Navigation_url");
  // print(navigationUrl);
  // print("payload");
  // print(payload);
  // Get.offAll(const NotificationScreen());
  Get.offAll(const Notifications());
}

Future<void> setupInteractedMessage() async {
  // Get any messages which caused the application to open from
  // a terminated state.
  print('setupInteractedMessage');
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();

  // If the message also contains a data property with a "type" of "chat",
  // navigate to a chat screen
  if (initialMessage != null) {
    _handleMessage(initialMessage);
  }

  // Also handle any interaction when the app is in the background via a
  // Stream listener
  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
}

Future<tz.TZDateTime> _twoHoursBeforeUsualTime(time) async {
  tz.initializeTimeZones();
  tz.Location location = await tz.getLocation('Asia/Karachi');
  tz.TZDateTime now = tz.TZDateTime.from(DateTime.parse(time), location);
  tz.TZDateTime scheduledDate = now.subtract(const Duration(minutes: 30));
  print(scheduledDate);
  return scheduledDate;
}

void scheduleBeforeUsualTimeNotification(time) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'daily_notification_channel',
    'Daily Notification',
    importance: Importance.max,
    priority: Priority.high,
  );

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin().zonedSchedule(
    0,
    'Huistaak',
    'Your Task Duration will end in 30 minutes',
    _twoHoursBeforeUsualTime(time) as tz.TZDateTime,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> _selectNotification(RemoteMessage message) async {
  print(message.data);
  if (message.data['type'] == 'scheduled') {
    scheduleBeforeUsualTimeNotification(message.data['end_time'].toString());
  }
  ;
  // if (message.data)
  AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
          'high_importance_channel', 'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher");
  NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await FlutterLocalNotificationsPlugin().show(123, message.notification!.title,
      message.notification!.body, platformChannelSpecifics,
      payload: 'data');

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // FlutterLocalNotificationsPlugin().initialize(initializationSettings,
  //     onSelectNotification: onSelectNotification);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupInteractedMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessageOpenedApp.listen((_handleMessage));
  FirebaseMessaging.onMessage.listen((_selectNotification));

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title // description
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.requestPermission(
      sound: true, badge: true, alert: true, provisional: true);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(Intro(padding: EdgeInsets.zero, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    Get.put(NotificationController());
    Get.put(HomeController());
    Get.put(GoalController());
    Get.put(GroupSettingController());
    Get.put(GroupController());
  }
}
