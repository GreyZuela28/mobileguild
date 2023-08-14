import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/employer/employer_jobs_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/employer/employer_homescreen_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/employer/employer_notification_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/employer/employer_setting_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../notification_screen.dart';

// ignore: unused_import
import '../../Auth/usertype.dart';
import '../../main.dart';

class EmployerMainPage extends StatefulWidget {
  const EmployerMainPage({super.key});

  @override
  State<EmployerMainPage> createState() => _EmployerMainPageMainPageState();
}

class _EmployerMainPageMainPageState extends State<EmployerMainPage> {
  int index = 0;

  final screens = [
    const EmployerHomeScreenPage(),
    const EmployerNotificationPage(),
    const EmployerJobPage(),
    const EmployerSettingsPage(),
  ];

    @override
  void initState() {
    super.initState();

    setupInteractedMessage();

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      RemoteNotification? notification = message?.notification!;

      print(notification != null ? notification.title : '');
    });

    FirebaseMessaging.onMessage.listen((message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;

   
        String action = jsonEncode(message.data);

        flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification!.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                priority: Priority.high,
                importance: Importance.max,
                setAsGroupSummary: true,
                styleInformation: DefaultStyleInformation(true, true),
                largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
                channelShowBadge: true,
                autoCancel: true,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: action);
 
      print('A new event was published!');
    });

    final android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = DarwinInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    
    flutterLocalNotificationsPlugin?.initialize(initSettings,
        onDidReceiveNotificationResponse: notificationTapBackground,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => _handleMessage(message.data));
  }

   Future<dynamic> onSelectNotification(payload) async {
    Map<String, dynamic> action = jsonDecode(payload);
    _handleMessage(action);
  }

  Future<void> setupInteractedMessage() async {
    await FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => _handleMessage(value != null ? value.data : Map()));
  }

  
void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.payload?.isNotEmpty ?? false) {
    onSelectNotification(notificationResponse.payload);
  }
}

  void _handleMessage(Map<String, dynamic> data) {
    print(data);
    if (data['redirect'] == "notif") {
      Navigator.push(
          context,
          MaterialPageRoute(
             builder: (context) => NotificationScreen(name: data['title'], description: data['message'], email: data['email'], jobId: data["jobId"],notificationId: data["notificationId"])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        child: NavigationBar(
          elevation: 10,
          height: 60,
          backgroundColor: Colors.blueGrey,
          selectedIndex: index,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          animationDuration: const Duration(seconds: 1),
          onDestinationSelected: (index) {
            setState(() {
              this.index = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.notifications_outlined),
              selectedIcon: Icon(Icons.notifications_active),
              label: "Notification",
            ),
            NavigationDestination(
              icon: Icon(Icons.work_outline),
              selectedIcon: Icon(Icons.work),
              label: "Jobs",
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
