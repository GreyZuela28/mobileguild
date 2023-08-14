import 'dart:convert';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class notificationClass{
  final String token;
  final String title;
  final String body;
  final String email;
  final String jobId;
  final String notificationId;

  notificationClass({required this.token, required this.title, required this.body, required this.email, required this.jobId, required this.notificationId});


notificationClass.sendPushNotification(this.token, this.title, this.body, this.email, this.jobId, this.notificationId){ 

  try{
     http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAhhgm0wQ:APA91bGI0aS4C_7-eG0Kpr-HY7vYTM7wHl0vmIT5tj-KZa-lfzAI-rqjbeBdLPEDfclJZ1jWYu6-d1GErzV8BFeqUs8yUvYN-FsKk1lcGNsXo9PmIR7lS8t50uLkNU5wId1pPg2-pw1U',
      },
      body: jsonEncode(
        <String, dynamic>{
          "priority": "high",
          'data' : <String, dynamic>{
            "title": title,
            "message": body,
            "email": email,
            "jobId": jobId,
            "notificationId": notificationId,
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "redirect": "notif",
          },
          "notification": <String, dynamic>{
            "body": body,
            "title": title,
            "android_channel_id": "jobseeker_notification"
          },
          "to": token
        },
      ),
    );
  }
  catch(e){
    if(kDebugMode){
      print('error push notification');
    }
  }

}

  
}
