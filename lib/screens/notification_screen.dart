// ignore_for_file: use_build_context_synchronously

import "package:cloud_firestore/cloud_firestore.dart";
import "package:connectivity_plus/connectivity_plus.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_messaging_platform_interface/src/remote_message.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "../utils/connection_status.dart";
import "applicant_screen.dart";

class NotificationScreen extends StatefulWidget {
  static const route = '/notification-screen';
  final String name;
  final String description;
  final String email;
  final String jobId;
  final String notificationId;
  
  const NotificationScreen( {
    super.key,
    required this.name,
    required this.description,
    required this.email, 
    required this.jobId, 
    required this.notificationId, 
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
  
}


class _NotificationScreenState extends State<NotificationScreen> {
  
  bool _isVisible = false;
  bool _isMeetingVisible = false;

  @override
  initState() {
    super.initState();
       if(widget.notificationId != '' && widget.jobId != ""){
        setState(() {
          _isVisible = true;
        });
       }
       if(widget.jobId != "" && widget.notificationId == ""){
        setState(() {
          _isMeetingVisible = true;
        });
       }
  }


  @override
  Widget build(BuildContext context) {
      print(widget.jobId);
      print(widget.name);
      print(widget.email);

    return Scaffold(
      
      appBar: AppBar(
        title: const Text("Notification Screen"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.email,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.notificationId,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            
            const SizedBox(height: 10),
            Visibility(
              visible: _isVisible,
              child: 
                ElevatedButton.icon(
                  onPressed: () {
                    ConnectionStatus
                      .checkInternetConnection()
                      .then(
                      (value) async {
                        if (value == ConnectivityResult.none) {
                          ConnectionStatus.showInternetError(context);
                        } 
                        else {
                          DocumentSnapshot job = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("jobs")
                            .doc(widget.jobId)
                            .collection("applicants")
                            .doc(widget.email)
                            .get();

                          context.pushNamed("applicant", queryParams: {
                          "profilePic": job["profilePic"],
                          "email": job["email"],
                          "name": job["name"],
                          "description": '',
                          "mobileNumber": job["mobileNumber"].toString(),
                          "address": job["address"],
                          "date": job["date"].toString(),
                          "resumeFile": job["resumeFile"],
                          "userId": job["id"],
                          "jobId": job["jobId"],
                        });
                
                        }
                      },
                    );
                  },
                  icon: const Icon(
                      Icons.article_outlined),
                  label: const Text("More Details"))
            ),
            Visibility(
              visible: _isMeetingVisible,
              child: 
                ElevatedButton.icon(
                  onPressed: () {
                    ConnectionStatus
                      .checkInternetConnection()
                      .then(
                      (value) async {
                        if (value == ConnectivityResult.none) {
                          ConnectionStatus.showInternetError(context);
                        } 
                        else {
                          DocumentSnapshot user = await FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .get();

                          context.pushNamed("video-call", queryParams: {
                        "userID": FirebaseAuth.instance.currentUser!.uid,
                        "userName": FirebaseAuth.instance.currentUser!.email,
                        "jobId": widget.jobId,
                        "jobName": "sample",
                        "businessName": user["name"],
                        });
                
                        }
                      },
                    );
                  },
                  icon: const Icon(
                      Icons.personal_video),
                  label: const Text("Go to meeting"))
            )
          ],
        ),
      ),
    );
  }

}
