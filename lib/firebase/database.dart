import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_guild_for_jobseekers_v3/users/jobseeker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../users/employer.dart';
import '../users/user_model.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}' );
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;

  String get userUid => auth.currentUser!.uid;

  sigIn(UserModel user, String password) async {
    await auth
        .createUserWithEmailAndPassword(
            email: user.getEmail, password: password)
        .then((value) => db
            .collection("users")
            .doc(auth.currentUser!.uid)
            .set(user.toFirestore()));
  }

  // void handleMessage(RemoteMessage? message){
  //   if(message == null) return;

  //   navigatorKey.currentState?.pushNamed(
  //     NotificationScreen.route,
  //     arguments: message,
  //   );
  // }

  // Future initPushNotifications() async{
  //   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

  //   FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  //   FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  // }

  Future<void> initNotifications() async {
     await _firebaseMessaging.requestPermission();
     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    //  initPushNotifications();
  }

  login(String email, String password) async {
    auth.signInWithEmailAndPassword(email: email, password: password);
  }

  logout() async {
    await auth.signOut();
  }

  updateEmployee(UserModel user) async {
    await db.collection("users").doc(userUid).update(user.toFirestore());
  }


  

 

  Future<void> deleteEmployee(String id) async {
    await db.collection("users").doc(id).delete();
  }

  Future<List<UserModel>> retrieveJobsekeer(String userType) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("users")
        .where('userType', isEqualTo: "jobseeker")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Jobseeker.fromFirestore(docSnapshot, null))
        .toList();
  }

  Future<List<UserModel>> retrieveEmployer(String userType) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("users")
        .where('userType', isEqualTo: "employer")
        .get();
    return snapshot.docs
        .map((docSnapshot) => Employer.fromFirestore(docSnapshot, null))
        .toList();
  }

  String getUserType() {
    late String userType;
    final dbRef = db.collection("users").doc(userUid);

    dbRef.get().then((value) {
      final user = value.data();

      userType = user!['userType'];
    });
    return userType;
  }
}
