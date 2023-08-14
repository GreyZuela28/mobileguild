import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/auth/usertype.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';

class Utils {
  // final jobNameController = TextEditingController();
  // final jobAddressController = TextEditingController();
  // final jobSalaryController = TextEditingController();
  // final jobDescriptionController = TextEditingController();
  // final jobUploadedKey = GlobalKey<FormState>();

  bool fileUploaded = false;
  String uploadedFile = "";
  final categories = [
    "Government",
    "Technology",
    "Service",
    "Transport",
    "Health",
    "Construction",
    "Education",
    "Finance",
    "Other"
  ];
  String? category;
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();
  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget floatingButton(String category) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          if (userData!["userType"] == UserType.JOBSEEKER) {
            return const SizedBox();
          } else if (userData["userType"] == UserType.EMPLOYER) {
            return FloatingActionButton.extended(
              onPressed: () {
                if (userData["profilePic"] == null) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.assignment_outlined),
                                SizedBox(width: 5.0),
                                Text(
                                  "Reminder",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              margin: const EdgeInsets.only(top: 10, bottom: 20),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                "Please Insert a profile picture before uploading for further Identification."),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              color: Colors.grey,
                            ),
                            const Text(
                              "Note: Can do only once!",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Add your action here
                              context.push("/employersettings");
                              context.pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        buttonPadding: const EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                        elevation: 5,
                        semanticLabel: "Alert dialog",
                      );
                    },
                  );
                } else {
                  context.pushNamed("uploadjob", queryParams: {
                    "category": category,
                  });
                }
              },
              icon: const Icon(
                Icons.work_outline,
                size: 20,
              ),
              label: const Text("Add Job"),
            );
          } else if (userData["userType"] == UserType.ADMIN) {
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }

//when jobseeker view the job
  Widget viewScreenFloatingActionButton(String userId, String jobId) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          if (userData!["userType"] == UserType.JOBSEEKER) {
            return FloatingActionButton.extended(
              onPressed: () async {
                if (userData["profilePic"] == null) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.assignment_outlined),
                                SizedBox(width: 5.0),
                                Text(
                                  "Reminder",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 1,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                                "Please Insert a profile picture before uploading for further Identification.",
                                textAlign: TextAlign.center),
                            const SizedBox(height: 10),
                            Container(
                              height: 1,
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              color: Colors.grey,
                            ),
                            const Text(
                              "Note: Can do only once!",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Add your action here
                              context.push("/Jobseekersettings");
                              context.pop();
                            },
                            child: const Text("OK"),
                          ),
                        ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 0),
                        buttonPadding: const EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                        elevation: 5,
                        semanticLabel: "Alert dialog",
                      );
                    },
                  );
                } else {
                  context.pushNamed("sendresume", queryParams: {
                    "userId": userId,
                    "jobId": jobId,
                  });
                }
              },
              icon: const Icon(Icons.send_outlined),
              label: const Text("Send Application"),
            );
          } else if (userData["userType"] == UserType.EMPLOYER) {
            return const SizedBox();
          } else if (userData["userType"] == UserType.ADMIN) {
            return const SizedBox();
          }
        }
        return const SizedBox();
      },
    );
  }

  static String pascalCase(String text) {
    return text.capitalize();
  }

  Widget showOptions(String displayText, Map<String, dynamic> document) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          if (userData!["userType"] == UserType.JOBSEEKER) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(displayText),
                PopupMenuButton(
                  onSelected: (index) {},
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
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
                          // context.pop();
                        },
                        value: 0,
                        child: Row(
                          children: const [
                            Icon(Icons.article_outlined),
                            SizedBox(width: 8.0),
                            Text("view"),
                          ],
                        ),
                      ),
                      // PopupMenuItem(
                      //   onTap: () async {
                      //     // Handle button tap

                      //     context.pushNamed("sendresume", queryParams: {
                      //       "userId": document["userId"],
                      //       "jobId": document["jobId"],
                      //     });
                      //   },
                      //   value: 1,
                      //   child: Row(
                      //     children: const [
                      //       Icon(Icons.send_outlined),
                      //       SizedBox(width: 8.0),
                      //       Text("Send Resume"),
                      //     ],
                      //   ),
                      // ),
                      PopupMenuItem(
                        onTap: () async {
                          // ignore: use_build_context_synchronously
                          ConnectionStatus.checkInternetConnection()
                              .then((value) async {
                            if (value == ConnectivityResult.none) {
                              ConnectionStatus.showInternetError(context);
                            } else {
                              DocumentSnapshot documentSnapshot =
                                  (await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection("bookmark")
                                      .doc(document["jobId"])
                                      .get());
                              if (documentSnapshot.exists) {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("already exists"),
                                  ),
                                );
                              } else {
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("bookmark")
                                    .doc(document["jobId"])
                                    .set({
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
                                  "mobileNumber": document["mobileNumber"],
                                  "vacancy": document["vacancy"],
                                  "salary": document["salary"],
                                  "jobQualification":
                                      document["jobQualification"],
                                  "jobDescription": document["jobDescription"],
                                  "date": DateTime.now(),
                                  "jobFile": document["jobFile"],
                                });
                                // print(DateTime.now());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("saved to bookmark"),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        value: 2,
                        child: Row(
                          children: const [
                            Icon(Icons.bookmark_outlined),
                            SizedBox(width: 8.0),
                            Text("Save to Bookmark"),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            );
          } else if (userData["userType"] == UserType.EMPLOYER) {
            return Text(displayText);
          } else if (userData["userType"] == UserType.ADMIN) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(displayText),
                IconButton(
                  onPressed: () {
                    ConnectionStatus.checkInternetConnection().then(
                      (value) {
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
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                        "Are you sure to delete this document?",
                                        textAlign: TextAlign.center),
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
                                          .doc(document["userId"])
                                          .collection("jobs")
                                          .doc(document["jobId"])
                                          .delete();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text("document deleted"),
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 0),
                                buttonPadding: const EdgeInsets.all(10),
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
                  color: Colors.red,
                  splashColor: Colors.red,
                  highlightColor: Colors.redAccent,
                  tooltip: "Delete",
                  // hoverColor: Colors.redAccent,
                  icon: const Icon(Icons.delete_outlined),
                  selectedIcon: const Icon(Icons.delete),
                  // label: Text("delete"),
                ),
                // IconButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (BuildContext context) {
                //         return Dialog(
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: [
                //               ListView(
                //                 padding: const EdgeInsets.all(10),
                //                 shrinkWrap: true,
                //                 children: [
                //                   const SizedBox(height: 8),
                //                   ElevatedButton.icon(
                //                     onPressed: () {
                //                       FirebaseFirestore.instance
                //                           .collection("users")
                //                           .doc(document["userId"])
                //                           .collection("jobs")
                //                           .doc(document["jobId"])
                //                           .delete();
                //                       context.pop();
                //                     },
                //                     icon: Icon(Icons.delete_outline),
                //                     label: Text('Delete'),
                //                     style: ElevatedButton.styleFrom(
                //                       padding: EdgeInsets.all(20),
                //                       foregroundColor: Colors.red,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   icon: Icon(Icons.more_vert),
                // ),
              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }
}
