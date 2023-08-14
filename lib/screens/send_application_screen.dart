import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

import 'notification_class.dart';

class SendApplicationScreen extends StatefulWidget {
  final String userId;
  final String jobId;
  
  const SendApplicationScreen({
    super.key,
    required this.userId,
    required this.jobId,
  });

  @override
  State<SendApplicationScreen> createState() => _SendApplicationScreenState();
}

class _SendApplicationScreenState extends State<SendApplicationScreen> {
  final applicantNameController = TextEditingController();
  final applicantAddressController = TextEditingController();
  final applicantMobileNumberController = TextEditingController();
  final applicantDescriptionController = TextEditingController();
  final sendApplicationkey = GlobalKey<FormState>();

  File? file;
  String uploadedFile = "Please Upload File";
  @override
  void dispose() {
    applicantNameController.dispose();
    applicantAddressController.dispose();
    applicantMobileNumberController.dispose();
    applicantDescriptionController.dispose();

    super.dispose();
  }

  double? progress;
  String progressText = "";
  UploadTask? uploadTask;
  bool doneUpload = false;
  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: sendApplicationkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/icon.png"),
                  ),
                  const Text(
                    "Send Application",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 32,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),

                  // const SizedBox(height: 5),
                  // TextFormField(
                  //   controller: applicantNameController,
                  //   cursorColor: Colors.white,
                  //   textInputAction: TextInputAction.next,
                  //   decoration: const InputDecoration(
                  //     iconColor: Colors.white70,
                  //     labelStyle: TextStyle(
                  //       color: Colors.white70,
                  //     ),
                  //     icon: Icon(Icons.people),
                  //     labelText: "Name",
                  //   ),
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) => value != null && value.isEmpty
                  //       ? "Enter Full Name"
                  //       : null,
                  // ),
                  // const SizedBox(height: 5),
                  // TextFormField(
                  //   controller: applicantAddressController,
                  //   cursorColor: Colors.white,
                  //   textInputAction: TextInputAction.next,
                  //   decoration: const InputDecoration(
                  //     iconColor: Colors.white70,
                  //     labelStyle: TextStyle(
                  //       color: Colors.white70,
                  //     ),
                  //     icon: Icon(Icons.location_city),
                  //     labelText: "Address",
                  //   ),
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) =>
                  //       value != null && value.isEmpty ? "Enter Address" : null,
                  // ),
                  // const SizedBox(height: 5),
                  // TextFormField(
                  //   controller: applicantMobileNumberController,
                  //   cursorColor: Colors.white,
                  //   textInputAction: TextInputAction.next,
                  //   decoration: const InputDecoration(
                  //     iconColor: Colors.white70,
                  //     labelStyle: TextStyle(
                  //       color: Colors.white70,
                  //     ),
                  //     icon: Icon(Icons.phone),
                  //     labelText: "Mobile Number",
                  //   ),
                  //   keyboardType: TextInputType.number,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) => value != null &&
                  //           value.length == 11 &&
                  //           value.startsWith("09")
                  //       ? null
                  //       : "Enter valid number",
                  // ),
                  // const SizedBox(height: 5),
                  // TextFormField(
                  //   controller: applicantDescriptionController,
                  //   cursorColor: Colors.white,
                  //   textInputAction: TextInputAction.next,
                  //   decoration: const InputDecoration(
                  //     iconColor: Colors.white70,
                  //     labelStyle: TextStyle(
                  //       color: Colors.white70,
                  //     ),
                  //     icon: Icon(Icons.description_outlined),
                  //     labelText: "description",
                  //   ),
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) => value != null && value.isEmpty
                  //       ? "Please provide a description"
                  //       : null,
                  // ),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(uploadedFile),
                      trailing: IconButton(
                          onPressed: () async {
                            // Select a file using file_picker
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowMultiple: false,
                              allowedExtensions: ['pdf', 'doc'],
                            );

                            if (result == null) {
                              return; // user canceled the picker
                            }

                            file = File(result.files.single.path!.toString());
                            setState(
                              () {
                                uploadedFile = basename(file!.path);
                              },
                            );
                          },
                          icon: const Icon(Icons.file_upload_outlined)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          DocumentSnapshot document = await FirebaseFirestore
                              .instance
                              .collection("users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .get();

                          final isValid =
                              sendApplicationkey.currentState!.validate();
                          if (!isValid) return;

                          ConnectionStatus.checkInternetConnection()
                              .then((value) async {
                            if (value == ConnectivityResult.none) {
                              ConnectionStatus.showInternetError(context);
                            } else {
                              if (uploadedFile == "Please Upload File") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 0),
                                      buttonPadding: const EdgeInsets.all(10),
                                      title: Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Icon(Icons.priority_high),
                                              SizedBox(width: 5.0),
                                              Text(
                                                "Must Do",
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
                                              color: Colors.grey),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Please select a resume File.",
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 1,
                                            margin: const EdgeInsets.only(
                                                top: 10, bottom: 20),
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: const Text("Ok"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                DocumentSnapshot documentSnapshot =
                                    (await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(widget.userId)
                                        .collection("jobs")
                                        .doc(widget.jobId)
                                        .collection("applicants")
                                        .doc(document["email"])
                                        .get());

                                if (documentSnapshot.exists) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Applicant already exist"),
                                    ),
                                  );
                                } else {
                                  String fileName = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();

                                  final ref = FirebaseStorage.instance
                                      .ref("resume")
                                      .child(fileName);

                                  uploadTask = ref.putFile(file!);

                                  uploadTask!.snapshotEvents.listen((snapshot) {
                                    if (snapshot.state == TaskState.running) {
                                      double progress =
                                          snapshot.bytesTransferred /
                                              snapshot.totalBytes *
                                              100;

                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        setState(
                                            () {}); // update the UI after the delay
                                      });
                                      // getUrl(ref).then((value) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text("Uploading State"),
                                              content: SizedBox(
                                                height: 50,
                                                child: Stack(
                                                    fit: StackFit.expand,
                                                    children: [
                                                      LinearProgressIndicator(
                                                        value: progress,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        color: Colors.green,
                                                      ),
                                                      Center(
                                                        child: Text(
                                                          "${progress.toStringAsFixed(0)}%",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              actions: [
                                                progress == 100
                                                    ? TextButton(
                                                        onPressed: () {
                                                          context.pop();
                                                          context.pop();
                                                          context.pop();
                                                          context.pop();
                                                        },
                                                        child:
                                                            const Text("Done"))
                                                    : TextButton(
                                                        onPressed: () {},
                                                        child: const Text("Ok"),
                                                      )
                                              ],
                                            );
                                          });
                                      // });
                                    } else if (snapshot.state ==
                                        TaskState.success) {
                                      getUrl(ref).then((uploadFileURl) async {
                                        var newDocument = uuid.v1();

                                          DocumentSnapshot employer = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(widget.userId)
                                          .collection("jobs")
                                          .doc(widget.jobId)
                                          .get(); 
                              
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.userId)
                                            .collection("jobs")
                                            .doc(widget.jobId)
                                            .collection("applicants")
                                            .doc(document["email"])
                                            .set({
                                          "id": document["id"],
                                          "name": document["name"],
                                          "address": document["address"],
                                          "mobileNumber":
                                              document["mobileNumber"],
                                          "date": DateTime.now(),
                                          "profilePic": document["profilePic"],
                                          "email": document["email"],
                                          "userType": document["userType"],
                                          "resumeFile": uploadFileURl,
                                          "token": document["token"],
                                          "jobId": widget.jobId
                                        });
                                        //upload resume on send application
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update({"resume": uploadFileURl});
                                        
                                        //insert notification to firebase
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(widget.userId)
                                            .collection("notification")
                                            .doc(newDocument)
                                            .set({
                                          "profilePic": document["profilePic"],
                                          "notificationId": newDocument,
                                          "name": 'New Job Applicant Received',
                                          "email": document["email"],
                                          "description": "We are pleased to inform you that a new job application has been received for the position of ${employer['jobTitle']} at ${employer['businessName']}. We believe you will be interested in reviewing this promising candidate for the role.",
                                          "date": DateTime.now(),
                                          "jobId": widget.jobId
                                        });

                                        DocumentSnapshot employerData = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(widget.userId)
                                          .get(); 
                           
                                        notificationClass.sendPushNotification(employerData['token'],'Application for the position of ${employer['jobTitle']}', "We are pleased to inform you that a new job application has been received for the position of ${employer['jobTitle']} at ${employer['businessName']}. We believe you will be interested in reviewing this promising candidate for the role.", document["email"], widget.jobId, newDocument);

                                      });
                                    }
                                  });
                                }
                              }
                            }
                          });
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: const Text("send Resume"),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getUrl(Reference ref) async {
    String uploadFileURl = await ref.getDownloadURL();

    return uploadFileURl;
  }
}
