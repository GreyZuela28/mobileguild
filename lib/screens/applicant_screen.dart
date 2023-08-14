import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';
import 'package:uuid/uuid.dart';
import 'notification_class.dart';

class ApplicantScreen extends StatefulWidget {
  final String profilePic;
  final String email;
  final String name;
  final String description;
  final int mobileNumber;
  final String address;
  final String date;
  String? resumeFile;
  final String userId;
  final String jobId;

  ApplicantScreen({
    super.key,
    required this.profilePic,
    required this.email,
    required this.name,
    required this.description,
    required this.mobileNumber,
    required this.address,
    required this.date,
    this.resumeFile,
    required this.userId,
    required this.jobId,
  });

  @override
  State<ApplicantScreen> createState() => _ApplicantScreenState();
}

class _ApplicantScreenState extends State<ApplicantScreen> {
  DateTime now = DateTime.now();
  // Create a new instance of the UUID class
  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
      int.parse(widget.date.split('=')[1].split(',')[0]) * 1000 +
          (int.parse(widget.date.split('=')[2].split(')')[0]) / 1000).round(),
    );
    DateTime dateTime = timestamp.toDate();

    int daysPassed = DateTime.now().difference(dateTime).inDays;
    String displayDate = DateFormat('yyyy-MM-dd').format(dateTime);
    String displayText = daysPassed == 0 ? 'New' : '$daysPassed days ago';
    return Scaffold(
      appBar: AppBar(
        title: const Text("Applicant Screen"),
        actions: [
          PopupMenuButton<int>(
            onSelected: (index) {},
            itemBuilder: (context) {
              return [
               PopupMenuItem(
                onTap: () {
                  //start an online meet
                  ConnectionStatus.checkInternetConnection()
                      .then((value) {
                    if (value == ConnectivityResult.none) {
                      ConnectionStatus.showInternetError(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Start Online Meet"),
                        ),
                      );
                    }
                  });
                },
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(Icons.meeting_room_rounded,color: Colors.black),
                      SizedBox(width: 8.0),
                      Text("Start Meet"),
                    ],
                  ),
                ),
                 PopupMenuItem(
                  onTap: () {
                    ConnectionStatus.checkInternetConnection()
                        .then((value) {
                      if (value == ConnectivityResult.none) {
                        ConnectionStatus.showInternetError(context);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.check_outlined),
                                      SizedBox(width: 5.0),
                                      Text(
                                        "Confirmation",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              content: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                      "Are you sure to hire this applicant?"),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 1,
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    // Add your action here

                                    var newDocument = uuid.v1();

                                    DocumentSnapshot job =
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth.instance
                                                .currentUser!.uid)
                                            .collection("jobs")
                                            .doc(widget.jobId)
                                            .get();
                                    // ignore: unnecessary_null_comparison

                                    FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.userId)
                                        .collection("notification")
                                        .doc(newDocument)
                                        .set({
                                      "notificationId": newDocument,
                                      "profilePic": job["profilePic"],
                                      "name": job["employer"],
                                      "jobTitle": job["jobTitle"],
                                      "description":
                                          "Congratulations!, You have been hired",
                                      "date": DateTime.now(),
                                    });

                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text("Hired!"),
                                      ),
                                    );
                                    // ignore: use_build_context_synchronously
                                    context.pop();

                                    DocumentSnapshot jobseekerData = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(widget.userId)
                                          .get(); 

                                    notificationClass.sendPushNotification(jobseekerData['token'],'Congratulations!', "You have been hired for the position of ${job["jobTitle"]} at ${job["businessName"]}", jobseekerData["email"], "", "");
                                  },
                                  child: const Text("OK"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 0),
                              buttonPadding: const EdgeInsets.all(10),
                              backgroundColor: Colors.white,
                              elevation: 5,
                              semanticLabel: "Alert dialog",
                            );
                          },
                        );
                      }
                    });
                  },
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.approval_outlined, color: Colors.black),
                      SizedBox(width: 8.0),
                      Text("Hire"),
                    ],
                  ),
                ),
                  PopupMenuItem(
                          onTap: () {
                            ConnectionStatus.checkInternetConnection()
                                .then((value) {
                              if (value == ConnectivityResult.none) {
                                ConnectionStatus.showInternetError(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.warning_outlined),
                                              SizedBox(width: 5.0),
                                              Text(
                                                "Warning",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 1,
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 20),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                              "Are you sure to delete this applicant?"),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("jobs")
                                                .doc(widget.jobId)
                                                .collection("applicants")
                                                .doc(widget.email)
                                                .delete();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text("Applicant deleted"),
                                              ),
                                            );
                                                 context.pushNamed("listOfApplicants",
                                                  queryParams: {
                                                    "jobId": widget.jobId,
                                                  });
                                        
                                            context.pop();
                                          },
                                          child: const Text("OK"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 0),
                                      buttonPadding: const EdgeInsets.all(10),
                                      backgroundColor: Colors.white,
                                      elevation: 5,
                                      semanticLabel: "Alert dialog",
                                    );
                                  },
                                );
                              }
                            });
                          },
                          value: 2,
                          child: Row(
                            children: const [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 8.0),
                              Text("delete",
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage("assets/background.png"),
              //   fit: BoxFit.fill,
              // ),
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.withOpacity(0.5),
                  Colors.blue.withOpacity(0.5),
                ],
                stops: const [0.4, 1],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.yellow,
                              ],
                              stops: [0.4, 1],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(3, 6),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(-3, -6),
                              ),
                            ],
                          ),
                          width: double.maxFinite,
                          margin: const EdgeInsets.only(
                            right: 10.0,
                            left: 10.0,
                            top: 30.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const SizedBox(height: 60.0),
                              const Center(
                                child: Text(
                                  "Applicant's Information:",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    const SizedBox(height: 15.0),
                                    Text("Name : ${widget.name}"),
                                    const SizedBox(height: 5.0),
                                    Text("Email: ${widget.email}"),
                                    const SizedBox(height: 5.0),
                                    Text(
                                        "Mobile Number : 0${widget.mobileNumber}"),
                                    const SizedBox(height: 5.0),
                                    Text("Address : ${widget.address}"),
                                    const SizedBox(height: 5.0),
                                    widget.resumeFile == ""
                                        ? Column(
                                            children: [
                                              Text(
                                                  "Description : ${widget.description}"),
                                              const SizedBox(height: 5.0),
                                            ],
                                          )
                                        : const SizedBox(),
                                    Text("Upload Time : $displayText"),
                                    const SizedBox(height: 15.0),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        ConnectionStatus
                                                .checkInternetConnection()
                                            .then(
                                          (value) {
                                            if (value ==
                                                ConnectivityResult.none) {
                                              ConnectionStatus
                                                  .showInternetError(context);
                                            } else {
                                              context.pushNamed(
                                                "pdfscreen",
                                                queryParams: {
                                                  "jobFile": widget.resumeFile!,
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.article_outlined),
                                      label: const Text("View Resume"),
                                    ),
                                    const SizedBox(height: 15.0),
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        var newDocument = uuid.v1();

                                        //to video conference
                                        DocumentSnapshot jobseekerData = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(widget.userId)
                                          .get(); 

                                        DocumentSnapshot job =
                                        await FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth.instance
                                                .currentUser!.uid)
                                            .collection("jobs")
                                            .doc(widget.jobId)
                                            .get();


                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.userId)
                                            .collection("notification")
                                            .doc(newDocument)
                                            .set({
                                          "notificationId": newDocument,
                                          "profilePic": job["profilePic"],
                                          "name": job["employer"],
                                          "jobTitle": job["jobTitle"],
                                          "description": "Congratulations!, almose there! We are inviting you for a short an interview",
                                          "date": DateTime.now(),
                                          "jobId": widget.jobId
                                        });

                                         notificationClass.sendPushNotification(jobseekerData['token'],'Congratulations!', "You are invited for an interview as a ${job["jobTitle"]} at ${job["businessName"]}", jobseekerData["email"], widget.jobId, "");
                                         // ignore: use_build_context_synchronously
                                         context.pushNamed("video-call",
                                         queryParams: {
                                                  "userID": FirebaseAuth.instance.currentUser!.uid,
                                                  "userName": FirebaseAuth.instance.currentUser!.email,
                                                  "jobId": widget.jobId,
                                                  "jobName": job['jobTitle'],
                                                  "businessName": job['businessName'],
                                                },);
                                         },
                                      icon: const Icon(Icons.video_call),
                                      label: const Text("Invite For An Interview"),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(3, 6),
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(-2, -3),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: widget.profilePic,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, size: 45),
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      
    );
   
  }
}
