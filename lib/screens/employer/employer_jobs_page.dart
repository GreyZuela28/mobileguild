import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/utils.dart';
import 'package:intl/intl.dart';

class EmployerJobPage extends StatefulWidget {
  const EmployerJobPage({super.key});

  @override
  State<EmployerJobPage> createState() => _EmployerJobPageState();
}

class _EmployerJobPageState extends State<EmployerJobPage> {
  // final jobNameController = TextEditingController();
  // final jobAddressController = TextEditingController();
  // final jobSalaryController = TextEditingController();
  // final jobDescriptionController = TextEditingController();
  // final jobUploadedKey = GlobalKey<FormState>();

  // bool fileUploaded = false;
  // String uploadedFile = "";
  // final categories = [
  //   "Technology",
  //   "Service",
  //   "Transport",
  //   "Health",
  //   "Construction",
  //   "Education",
  //   "Art",
  //   "Other"
  // ];
  // String? category;
  String choose = "choose";
  Utils utils = Utils();
  DateTime now = DateTime.now();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jobs"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("jobs")
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.size == 0) {
            return const Center(
              child: Text('No posted job'),
            );
          }

          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final document = snapshot.data!.docs.elementAt(index).data();
                DateTime documentDate = document['date'].toDate();
                int daysPassed = now.difference(documentDate).inDays;
                String displayDate =
                    DateFormat('yyyy-MM-dd').format(documentDate);
                String displayText =
                    daysPassed == 0 ? 'New' : '$daysPassed days ago';
                return ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    context.pushNamed("view", queryParams: {
                      "userId": document["userId"],
                      "email": document["email"],
                      "profilePic": document["profilePic"],
                      "jobId": document["jobId"],
                      "jobTitle": document["jobTitle"],
                      "category": document["category"],
                      "jobStatus": document["jobStatus"],
                      "address": document["address"],
                      "employer": document["employer"],
                      "businessName": document["businessName"],
                      "mobileNumber": document["mobileNumber"].toString(),
                      "vacancy": document["vacancy"],
                      "salary": document["salary"],
                      "jobQualification": document["jobQualification"],
                      "jobDescription": document["jobDescription"],
                      "date": document["date"].toString(),
                      "jobFile": document["jobFile"],
                    });
                  },
                  splashColor: Colors.grey[300],
                  tileColor: Colors.amberAccent,
                  leading: document["profilePic"] != null
                      ? CircleAvatar(
                          radius: 25,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: document["profilePic"],
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, size: 45),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                        )
                      : const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/icon.png"),
                        ),
                  // leading: const Icon(Icons.people),
                  title: Text(document["jobTitle"]),
                  subtitle: Text("Vacancy: ${document["vacancy"]}",
                      overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(displayText),
                      PopupMenuButton<int>(
                        onSelected: (index) {},
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              onTap: () {
                                context.pushNamed("listOfApplicants",
                                    queryParams: {
                                      "jobId": document["jobId"],
                                    });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("View Applicants"),
                                  ),
                                );
                              },
                              value: 0,
                              child: Row(
                                children: const [
                                  Icon(Icons.people_outline),
                                  SizedBox(width: 5),
                                  Text("View Applicants"),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              onTap: () {
                                ConnectionStatus.checkInternetConnection().then(
                                  (value) {
                                    if (value == ConnectivityResult.none) {
                                      ConnectionStatus.showInternetError(
                                          context);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Column(
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.check),
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
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Are you sure to delete this document?",
                                                  textAlign: TextAlign.center,
                                                ),
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
                                                  // Add your action here
                                                  FirebaseFirestore.instance
                                                      .collection("users")
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .collection("jobs")
                                                      .doc(document["jobId"])
                                                      .delete();

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "document deleted"),
                                                    ),
                                                  );
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 0),
                                            buttonPadding:
                                                const EdgeInsets.all(10),
                                            backgroundColor: Colors.white,
                                            elevation: 5,
                                            semanticLabel: "Alert dialog",
                                          );
                                        },
                                      );
                                    }
                                  },
                                );
                              },
                              value: 1,
                              child: Row(
                                children: const [
                                  Icon(Icons.delete_outline, color: Colors.red),
                                  SizedBox(width: 5),
                                  Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text("No Jobs Uploaded"),
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     DocumentSnapshot documentSnapshot = (await FirebaseFirestore.instance
      //         .collection("users")
      //         .doc(FirebaseAuth.instance.currentUser!.uid)
      //         .get());

      //     //check if the users profilePic equal to null
      //     //redirect to settings to upload image before adding a job
      //     if (documentSnapshot["profilePic"] == null) {
      //       uploadInfo();
      //     } else {
      //       goUploadJob();
      //     }
      //   },
      //   icon: const Icon(Icons.work_outline),
      //   label: const Text("Add Job"),
      // ),
      floatingActionButton: utils.floatingButton(choose),
    );
  }

  // void uploadInfo() {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Reminder"),
  //         content: const Text(
  //             "Please Insert a profilePic before uploading \n for further Identification."),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text("close"),
  //             onPressed: () {
  //               context.push("/employersettings");
  //               context.pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void goUploadJob() {
  //   context.pushNamed("uploadjob", queryParams: {
  //     "category": "choose",
  //   });
  // }
}
