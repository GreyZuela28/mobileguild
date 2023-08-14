import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/add_job_screen.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/admin_setting_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/user_jobseeker.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/admin/user_employer.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/applicant_screen.dart';

import 'package:mobile_guild_for_jobseekers_v3/screens/employer/employer_setting_page.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/job_file_screen.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/list_of_applicants_screen.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/meeting_screen.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/notification_screen.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/send_application_screen.dart';

import 'package:mobile_guild_for_jobseekers_v3/utils/utils.dart';
import 'package:path/path.dart';
import 'Jobs/category/other.dart';
import 'Jobs/category/construction.dart';
import 'Jobs/category/education.dart';
import 'Jobs/category/finance.dart';
import 'Jobs/category/government.dart';
import 'Jobs/category/health.dart';
import 'Jobs/category/service.dart';
import 'Jobs/category/technology.dart';
import 'Jobs/category/transportation.dart';
import 'Jobs/viewscreen.dart';
import 'auth/authenticate.dart';
import 'firebase_options.dart';
import 'global_key.dart';
import 'screens/jobseeker/jobseeker_setting_page.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;


FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
late FirebaseMessaging messaging;

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void notificationTapBackground(NotificationResponse notificationResponse) {
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.payload?.isNotEmpty ?? false) {
    print(
        'notification action tapped with input: ${notificationResponse.input}');
    print('testing kung mgloag');
  }
}

Future<void> main() async {
  WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.preserve(widgetsBinding: widgetBinding);
  messaging = FirebaseMessaging.instance;

  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final fcmToken = await messaging.getToken();
  print(fcmToken);

   await messaging.subscribeToTopic('notification');

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    channel = const AndroidNotificationChannel(
        'notification', // id
        'title', // title
        importance: Importance.high,
        enableLights: true,
        enableVibration: true,
        showBadge: true,
        playSound: true);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await messaging
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  
  runApp(const MyApp());
}

// final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      key: GlobalContextService.navigatorKey,
      scaffoldMessengerKey: Utils.messengerKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blueGrey[600],
        scaffoldBackgroundColor: Colors.blue[300],
      ),
      routerConfig: router,
    );
  }
}

final router = GoRouter(
  initialLocation: "/main",
  routes: <RouteBase>[
    GoRoute(
        name: "main",
        path: "/main",
        builder: (BuildContext context, GoRouterState state) {
          return const AuthenticationPage();
        },
        routes: [
          GoRoute(
            name: "view",
            path: "view",
            builder: (BuildContext context, GoRouterState state) {
              return ViewScreen(
                userId: state.queryParams["userId"]!,
                email: state.queryParams["email"]!,
                profilePic: state.queryParams["profilePic"]!,
                jobId: state.queryParams["jobId"]!,
                jobTitle: state.queryParams["jobTitle"]!,
                category: state.queryParams["category"]!,
                jobStatus: state.queryParams["jobStatus"]!,
                address: state.queryParams["address"]!,
                employer: state.queryParams["employer"]!,
                businessName: state.queryParams["businessName"]!,
                mobileNumber: state.queryParams["mobileNumber"]!,
                vacancy: state.queryParams["vacancy"]!,
                salary: state.queryParams["salary"],
                jobQualification: state.queryParams["jobQualification"],
                jobDescription: state.queryParams["jobDescription"],
                date: state.queryParams["date"],
                jobFile: state.queryParams["jobFile"],
              );
            },
          ),
          GoRoute(
            name: "pdfscreen",
            path: "pdfscreen",
            builder: (BuildContext context, GoRouterState state) {
              return PDFScreen(
                path: state.queryParams["jobFile"]!,
              );
            },
          ),
          GoRoute(
            name: "jobseeker",
            path: "jobseeker",
            builder: (BuildContext context, GoRouterState state) {
              return JobseekerScreen(
                id: state.queryParams["id"]!,
                profilePic: state.queryParams["profilePic"]!,
                name: state.queryParams["name"]!,
                userType: state.queryParams["userType"]!,
                address: state.queryParams["address"]!,
                email: state.queryParams["email"]!,
                mobileNumber: state.queryParams["mobileNumber"]!,
                loginTime: state.queryParams["loginTime"]!,
                education: state.queryParams["education"]!,
              );
            },
          ),
          GoRoute(
            name: "employer",
            path: "employer",
            builder: (BuildContext context, GoRouterState state) {
              return EmployerScreen(
                id: state.queryParams["id"]!,
                profilePic: state.queryParams["profilePic"]!,
                name: state.queryParams["name"]!,
                userType: state.queryParams["userType"]!,
                businessName: state.queryParams["businessName"]!,
                address: state.queryParams["address"]!,
                email: state.queryParams["email"]!,
                loginTime: state.queryParams["loginTime"]!,
                mobileNumber: state.queryParams["mobileNumber"]!,
              );
            },
          ),
          GoRoute(
            name: "applicant",
            path: "applicant",
            builder: (BuildContext context, GoRouterState state) {
              return ApplicantScreen(
                profilePic: state.queryParams["profilePic"]!,
                email: state.queryParams["email"]!,
                name: state.queryParams["name"]!,
                description: state.queryParams["description"]!,
                mobileNumber: int.parse(state.queryParams["mobileNumber"]!),
                address: state.queryParams["address"]!,
                date: state.queryParams["date"]!,
                resumeFile: state.queryParams["resumeFile"],
                userId: state.queryParams["userId"]!,
                jobId: state.queryParams["jobId"]!,
              );
            },
          ),
          GoRoute(
            name: "video-call",
            path: "video-call",
            builder: (BuildContext context, GoRouterState state){
              return MeetingScreen(
                userID: state.queryParams["userID"]!,
                userName: state.queryParams["userName"]!,
                jobId: state.queryParams["jobId"]!,
                jobName: state.queryParams["jobName"]!,
                businessName: state.queryParams["businessName"]!,
              );
            }
          ),
          GoRoute(
            name: "listOfApplicants",
            path: "listOfApplicants",
            builder: (BuildContext context, GoRouterState state) {
              return ListOfApplicantsScreen(
                jobId: state.queryParams["jobId"]!,
              );
            },
          ),
          GoRoute(
            name: "notification-screen",
            path: "notification-screen",
            builder: (BuildContext context, GoRouterState state) {
              return NotificationScreen(
                name: state.queryParams["name"]!,
                description: state.queryParams["description"]!,
                email: state.queryParams["email"]!,
                jobId: state.queryParams["jobId"]!,
                notificationId: state.queryParams["notificationId"]!,
              );
            },
          ),
          GoRoute(
            name: "uploadjob",
            path: "uploadjob",
            builder: (BuildContext context, GoRouterState state) {
              return AddedJobScreen(
                category: state.queryParams["category"]!,
              );
            },
          ),
          GoRoute(
            name: "sendresume",
            path: "sendresume",
            builder: (BuildContext context, GoRouterState state) {
              return SendApplicationScreen(
                userId: state.queryParams["userId"]!,
                jobId: state.queryParams["jobId"]!,
              );
            },
          ),
          GoRoute(
            path: "technology",
            builder: (BuildContext context, GoRouterState state) {
              return const Technology();
            },
          ),
          GoRoute(
            path: "education",
            builder: (BuildContext context, GoRouterState state) {
              return const Education();
            },
          ),
          GoRoute(
            path: "government",
            builder: (BuildContext context, GoRouterState state) {
              return const Government();
            },
          ),
          GoRoute(
            path: "health",
            builder: (BuildContext context, GoRouterState state) {
              return const Health();
            },
          ),
          GoRoute(
            path: "service",
            builder: (BuildContext context, GoRouterState state) {
              return const Service();
            },
          ),
          GoRoute(
            path: "transportation",
            builder: (BuildContext context, GoRouterState state) {
              return const Transportation();
            },
          ),
          GoRoute(
            path: "construction",
            builder: (BuildContext context, GoRouterState state) {
              return const Construction();
            },
          ),
          GoRoute(
            path: "finance",
            builder: (BuildContext context, GoRouterState state) {
              return const Finance();
            },
          ),
          GoRoute(
            path: "other",
            builder: (BuildContext context, GoRouterState state) {
              return const Other();
            },
          ),
        ]),
    GoRoute(
        path: "/jobseekersettings",
        builder: (BuildContext context, GoRouterState state) {
          return const JobseekerSettingsPage();
        }),
    GoRoute(
        path: "/employersettings",
        builder: (BuildContext context, GoRouterState state) {
          return const EmployerSettingsPage();
        }),
    GoRoute(
        name: "adminsettings",
        path: "/adminsettings",
        builder: (BuildContext context, GoRouterState state) {
          return const AdminSettingsPage();
        }),
  ],
);
