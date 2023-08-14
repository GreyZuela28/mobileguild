import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/jobclass.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart';
import 'dart:io';

class AddedJobScreen extends StatefulWidget {
  const AddedJobScreen({
    super.key,
    required this.category,
  });
  final category;

  @override
  State<AddedJobScreen> createState() => _AddedJobScreenState();
}

class _AddedJobScreenState extends State<AddedJobScreen> {
  final jobTitleController = TextEditingController();
  final jobAddressController = TextEditingController();
  final jobSalaryController = TextEditingController();
  final jobQualificationController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final jobEmployerController = TextEditingController();
  final jobVacancyController = TextEditingController();
  final jobUploadedKey = GlobalKey<FormState>();
  final fileUploadKey = GlobalKey<FormState>();

  final jobTitle2Controller = TextEditingController();
  final jobVacancy2Controller = TextEditingController();

// Create a new instance of the UUID class
  var uuid = const Uuid();
// Generate a unique ID for the new document

  @override
  void dispose() {
    jobTitleController.dispose();
    jobAddressController.dispose();
    jobSalaryController.dispose();
    jobDescriptionController.dispose();
    jobQualificationController.dispose();
    super.dispose();
  }

  File? file;
  bool fileUploaded = false;
  String uploadedFile = "Please Upload File";
  final status = [
    "permanent",
    "contractual",
    "job order",
  ];

  UploadTask? uploadTask;

  String? jobStatus;
  String? jobStatus2;
  String? category;
  String? category2;
  final categories = [
    "government",
    "technology",
    "service",
    "transport",
    "health",
    "construction",
    "education",
    "finance",
    "others"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              child: Container(
                height: 70,
                color: Colors.white,
                child: TabBar(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  unselectedLabelColor: Colors.pink,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.pinkAccent,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.pinkAccent,
                            width: 1,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("Hard Type"),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.pinkAccent,
                            width: 1,
                          ),
                        ),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text("Send File"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Stack(
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
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: jobUploadedKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                const CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage("assets/icon.png"),
                                ),
                                const Text(
                                  "JOB REQUIREMENTS",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 10),
                                widget.category == "choose"
                                    ? SizedBox(
                                        child: DropdownButtonFormField(
                                          value: category,
                                          items: categories
                                              .map((e) => DropdownMenuItem(
                                                  child: Text(e), value: e))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(
                                              () {
                                                category = value;
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.blueGrey,
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          dropdownColor:
                                              Colors.deepPurple.shade50,
                                          decoration: const InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.white70,
                                            ),
                                            labelText: "Job Category",
                                            border: UnderlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return "Please select category";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      )
                                    : Center(
                                        child:
                                            Text(widget.category.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 24,
                                                )),
                                      ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobTitleController,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please enter Job Name";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Job Title",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  child: DropdownButtonFormField(
                                    value: jobStatus,
                                    items: status
                                        .map((e) => DropdownMenuItem(
                                            child: Text(e), value: e))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          jobStatus = value;
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.blueGrey,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    dropdownColor: Colors.deepPurple.shade50,
                                    decoration: const InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.white70,
                                      ),
                                      labelText: "Job Status",
                                      border: UnderlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select category";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobVacancyController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please enter the number of vacancy";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Number of Vacancy",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobSalaryController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please provide salary";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Job Salary / Day ",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobQualificationController,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please enter job qualifications";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Qualifications",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobDescriptionController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please enter description";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Job Description",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        DocumentSnapshot documentSnapshot =
                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .get();

                                        final isValid = jobUploadedKey
                                            .currentState!
                                            .validate();
                                        if (!isValid) return;

                                        ConnectionStatus
                                                .checkInternetConnection()
                                            .then((value) {
                                          if (value ==
                                              ConnectivityResult.none) {
                                            ConnectionStatus.showInternetError(
                                                context);
                                          } else {
                                            var newDocumentId = uuid.v4();

                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection("jobs")
                                                .doc(newDocumentId)
                                                .set({
                                              "userId": FirebaseAuth
                                                  .instance.currentUser!.uid,
                                              "jobId": newDocumentId,
                                              "profilePic": documentSnapshot[
                                                  "profilePic"],
                                              "category":
                                                  widget.category == "choose"
                                                      ? category
                                                      : widget.category,
                                              "jobTitle": jobTitleController
                                                  .text
                                                  .trim()
                                                  .toLowerCase(),
                                              "jobStatus": jobStatus,
                                              "vacancy": jobVacancyController
                                                  .text
                                                  .trim(),
                                              "address":
                                                  documentSnapshot["address"],
                                              "mobileNumber": documentSnapshot[
                                                  "mobileNumber"],
                                              "employer":
                                                  documentSnapshot["name"],
                                              "businessName": documentSnapshot[
                                                  "businessName"],
                                              "salary": jobSalaryController.text
                                                  .trim(),
                                              "jobQualification":
                                                  jobQualificationController
                                                      .text
                                                      .trim(),
                                              "jobDescription":
                                                  jobDescriptionController.text
                                                      .trim(),
                                              "date": DateTime.now(),
                                              "jobFile": uploadedFile,
                                              "email":
                                                  documentSnapshot["email"],
                                            });

                                            // TODO: upload to firestorage and firebase.
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text("Job Added"),
                                              ),
                                            );
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      },
                                      icon: const Icon(Icons.save_outlined),
                                      label: const Text("Post Job"),
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
                      ),
                    ],
                  ),

                  //This is the second tabbarview

                  Stack(
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
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: fileUploadKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                widget.category == "choose"
                                    ? SizedBox(
                                        child: DropdownButtonFormField(
                                          value: category2,
                                          items: categories
                                              .map((e) => DropdownMenuItem(
                                                  child: Text(e), value: e))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(
                                              () {
                                                category2 = value;
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.blueGrey,
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          dropdownColor:
                                              Colors.deepPurple.shade50,
                                          decoration: const InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.white70,
                                            ),
                                            labelText: "Job Category",
                                            border: UnderlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return "Please select category";
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      )
                                    : Center(
                                        child:
                                            Text(widget.category.toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 24,
                                                )),
                                      ),
                                const SizedBox(height: 5),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobTitle2Controller,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please enter Job Name";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Job Title",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  child: DropdownButtonFormField(
                                    value: jobStatus2,
                                    items: status
                                        .map((e) => DropdownMenuItem(
                                            child: Text(e), value: e))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          jobStatus2 = value;
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.blueGrey,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    dropdownColor: Colors.deepPurple.shade50,
                                    decoration: const InputDecoration(
                                      labelStyle: TextStyle(
                                        color: Colors.white70,
                                      ),
                                      labelText: "Job Status",
                                      border: UnderlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select category";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextFormField(
                                  controller: jobVacancy2Controller,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return value!.isNotEmpty
                                        ? null
                                        : "Please enter the number of vacancy";
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Number of Vacancy",
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    title: Text(uploadedFile),
                                    trailing: IconButton(
                                        onPressed: () async {
                                          // Select a file using file_picker
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            type: FileType.custom,
                                            allowMultiple: false,
                                            allowedExtensions: ['pdf', 'doc'],
                                          );

                                          if (result == null)
                                            return; // user canceled the picker

                                          file = File(result.files.single.path!
                                              .toString());
                                          setState(
                                            () {
                                              uploadedFile =
                                                  basename(file!.path);
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                            Icons.file_upload_outlined)),
                                  ),
                                ),
                                const SizedBox(height: 25.0),
                                ElevatedButton.icon(
                                    onPressed: () async {
                                      final isValid = fileUploadKey
                                          .currentState!
                                          .validate();
                                      if (!isValid) return;

                                      ConnectionStatus.checkInternetConnection()
                                          .then((value) async {
                                        if (value == ConnectivityResult.none) {
                                          ConnectionStatus.showInternetError(
                                              context);
                                        } else {
                                          if (uploadedFile ==
                                              "Please Upload File") {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: const [
                                                          Icon(Icons
                                                              .priority_high),
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
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10,
                                                                  bottom: 20),
                                                          color: Colors.grey),
                                                    ],
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text(
                                                          "Please select a job File.",
                                                          textAlign:
                                                              TextAlign.center),
                                                      const SizedBox(
                                                          height: 10),
                                                      Container(
                                                        height: 1,
                                                        margin: const EdgeInsets
                                                                .only(
                                                            top: 10,
                                                            bottom: 20),
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
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10.0,
                                                          vertical: 0),
                                                );
                                              },
                                            );
                                          } else {
                                            DocumentSnapshot documentSnapshot =
                                                await FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .get();

                                            var newDocumentId = uuid.v4();

                                            String fileName = DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString();

                                            final ref = firebase_storage
                                                .FirebaseStorage.instance
                                                .ref("jobfile")
                                                .child(fileName);

                                            uploadTask = ref.putFile(file!);

                                            uploadTask!.snapshotEvents
                                                .listen((snapshot) {
                                              if (snapshot.state ==
                                                  TaskState.running) {
                                                double progress =
                                                    snapshot.bytesTransferred /
                                                        snapshot.totalBytes *
                                                        100;

                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  setState(
                                                      () {}); // update the UI after the delay
                                                });

                                                // getUrl(ref).then((value) {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Uploading State"),
                                                        content: SizedBox(
                                                          height: 50,
                                                          child: Stack(
                                                              fit: StackFit
                                                                  .expand,
                                                              children: [
                                                                LinearProgressIndicator(
                                                                  value:
                                                                      progress,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    "${progress.toStringAsFixed(0)}%",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        actions: [
                                                          progress == 100
                                                              ? TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .pop();
                                                                    context
                                                                        .pop();
                                                                    context
                                                                        .pop();
                                                                    context
                                                                        .pop();
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          "Done"))
                                                              : TextButton(
                                                                  onPressed:
                                                                      () {},
                                                                  child:
                                                                      const Text(
                                                                          "Ok"),
                                                                )
                                                        ],
                                                      );
                                                    });
                                                // });
                                              } else if (snapshot.state ==
                                                  TaskState.success) {
                                                getUrl(ref)
                                                    .then((uploadFileURl) {
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .collection("jobs")
                                                      .doc(newDocumentId)
                                                      .set({
                                                    "userId": FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid,
                                                    "jobId": newDocumentId,
                                                    "profilePic":
                                                        documentSnapshot[
                                                            "profilePic"],
                                                    "category":
                                                        widget.category ==
                                                                "choose"
                                                            ? category2
                                                            : widget.category,
                                                    "jobTitle":
                                                        jobTitle2Controller.text
                                                            .trim()
                                                            .toLowerCase(),
                                                    "jobStatus": jobStatus2,
                                                    "vacancy":
                                                        jobVacancy2Controller
                                                            .text
                                                            .trim(),
                                                    "address": documentSnapshot[
                                                        "address"],
                                                    "mobileNumber":
                                                        documentSnapshot[
                                                            "mobileNumber"],
                                                    "employer":
                                                        documentSnapshot[
                                                            "name"],
                                                    "businessName":
                                                        documentSnapshot[
                                                            "businessName"],
                                                    "date": DateTime.now(),
                                                    "jobFile": uploadFileURl,
                                                    "email": documentSnapshot[
                                                        "email"],
                                                  });
                                                });
                                              }
                                            });

                                            //upload file!!
                                            // ignore: use_build_context_synchronously
                                            // showDialog(
                                            //   context: context,
                                            //   builder: (context) {
                                            //     return AlertDialog(
                                            //       title: Column(
                                            //         children: [
                                            //           Row(
                                            //             mainAxisSize:
                                            //                 MainAxisSize.min,
                                            //             children: const [
                                            //               Icon(Icons
                                            //                   .assignment_outlined),
                                            //               SizedBox(width: 5.0),
                                            //               Text(
                                            //                 "Reminder",
                                            //                 style: TextStyle(
                                            //                   fontSize: 20,
                                            //                 ),
                                            //               ),
                                            //             ],
                                            //           ),
                                            //           Container(
                                            //             height: 1,
                                            //             margin: const EdgeInsets
                                            //                     .only(
                                            //                 top: 10,
                                            //                 bottom: 20),
                                            //             color: Colors.grey,
                                            //           ),
                                            //         ],
                                            //       ),
                                            //       content: Column(
                                            //         mainAxisSize:
                                            //             MainAxisSize.min,
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .center,
                                            //         children: [
                                            //           const Text(
                                            //               "Upload the job.",
                                            //               textAlign:
                                            //                   TextAlign.center),
                                            //           const SizedBox(
                                            //               height: 10),
                                            //           Container(
                                            //             height: 1,
                                            //             margin: const EdgeInsets
                                            //                     .only(
                                            //                 top: 10,
                                            //                 bottom: 10),
                                            //             color: Colors.grey,
                                            //           ),
                                            //         ],
                                            //       ),
                                            //       actions: [
                                            //         TextButton(
                                            //           onPressed: () async {
                                            //             // Add your action here
                                            //             String fileName = DateTime
                                            //                     .now()
                                            //                 .millisecondsSinceEpoch
                                            //                 .toString();
                                            //             final ref =
                                            //                 firebase_storage
                                            //                     .FirebaseStorage
                                            //                     .instance
                                            //                     .ref("jobfile")
                                            //                     .child(
                                            //                         fileName);

                                            //             firebase_storage
                                            //                     .UploadTask
                                            //                 uploadTask =
                                            //                 ref.putFile(file!);

                                            //             TaskSnapshot
                                            //                 storageTaskSnapshot =
                                            //                 await uploadTask
                                            //                     .whenComplete(
                                            //                         () => print(
                                            //                             "done"));

                                            //             String _uploadFileURl =
                                            //                 await ref
                                            //                     .getDownloadURL();
                                            //             FirebaseFirestore
                                            //                 .instance
                                            //                 .collection("users")
                                            //                 .doc(FirebaseAuth
                                            //                     .instance
                                            //                     .currentUser!
                                            //                     .uid)
                                            //                 .collection("jobs")
                                            //                 .doc(newDocumentId)
                                            //                 .set({
                                            //               "userId": FirebaseAuth
                                            //                   .instance
                                            //                   .currentUser!
                                            //                   .uid,
                                            //               "jobId":
                                            //                   newDocumentId,
                                            //               "profilePic":
                                            //                   documentSnapshot[
                                            //                       "profilePic"],
                                            //               "category":
                                            //                   widget.category ==
                                            //                           "choose"
                                            //                       ? category2
                                            //                       : widget
                                            //                           .category,
                                            //               "jobTitle":
                                            //                   jobTitle2Controller
                                            //                       .text
                                            //                       .trim()
                                            //                       .toLowerCase(),
                                            //               "jobStatus":
                                            //                   jobStatus2,
                                            //               "vacancy":
                                            //                   jobVacancy2Controller
                                            //                       .text
                                            //                       .trim(),
                                            //               "address":
                                            //                   documentSnapshot[
                                            //                       "address"],
                                            //               "mobileNumber":
                                            //                   documentSnapshot[
                                            //                       "mobileNumber"],
                                            //               "employer":
                                            //                   documentSnapshot[
                                            //                       "name"],
                                            //               "businessName":
                                            //                   documentSnapshot[
                                            //                       "businessName"],
                                            //               "date":
                                            //                   DateTime.now(),
                                            //               "jobFile":
                                            //                   _uploadFileURl,
                                            //               "email":
                                            //                   documentSnapshot[
                                            //                       "email"],
                                            //             });
                                            //             // ignore: use_build_context_synchronously
                                            //             context.pop();
                                            //             // ignore: use_build_context_synchronously
                                            //             context.pop();
                                            //           },
                                            //           child: const Text("OK"),
                                            //         ),
                                            //         TextButton(
                                            //           onPressed: () {
                                            //             // Add your action here
                                            //             context.pop();
                                            //           },
                                            //           child:
                                            //               const Text("cancel"),
                                            //         ),
                                            //       ],
                                            //       shape: RoundedRectangleBorder(
                                            //         borderRadius:
                                            //             BorderRadius.circular(
                                            //                 10),
                                            //       ),
                                            //       contentPadding:
                                            //           const EdgeInsets
                                            //                   .symmetric(
                                            //               horizontal: 10.0,
                                            //               vertical: 0),
                                            //       buttonPadding:
                                            //           const EdgeInsets.all(10),
                                            //       backgroundColor: Colors.white,
                                            //       elevation: 5,
                                            //       semanticLabel: "Alert dialog",
                                            //     );
                                            //   },
                                            // );
                                          }
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.article_outlined),
                                    label: const Text("Add Job")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getUrl(Reference ref) async {
    String uploadFileURl = await ref.getDownloadURL();

    return uploadFileURl;
  }
}
