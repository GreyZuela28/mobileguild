import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';

class JobseekerBookmarkPage extends StatefulWidget {
  const JobseekerBookmarkPage({super.key});

  @override
  State<JobseekerBookmarkPage> createState() => _JobseekerBookmarkPageState();
}

class _JobseekerBookmarkPageState extends State<JobseekerBookmarkPage> {
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmark"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("bookmark")
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
              child: Text('No Bookmark'),
            );
          }

          if (snapshot.hasData) {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
              itemCount: snapshot.data!.docs.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final DocumentSnapshot = snapshot.data!.docs;
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
                  onTap: () async {
                    final documentSnapshot = (await FirebaseFirestore.instance
                        .collection("users")
                        .doc(document["userId"])
                        .collection("jobs")
                        .doc(document["jobId"])
                        .get());
                    if (!documentSnapshot.exists) {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection("bookmark")
                          .doc(document["jobId"])
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("This job is deleted!"),
                        ),
                      );
                    } else {
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
                    }
                  },
                  splashColor: Colors.grey[300],
                  tileColor: Colors.amberAccent,
                  leading: CircleAvatar(
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
                  ),
                  // leading: const Icon(Icons.people),
                  title: Text(document["jobTitle"]),
                  subtitle: Text("Vacancy: ${document["vacancy"]}",
                      overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(displayText),
                      IconButton(
                        onPressed: () {
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
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection("bookmark")
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

                              // FirebaseFirestore.instance
                              //     .collection("users")
                              //     .doc(FirebaseAuth.instance.currentUser!.uid)
                              //     .collection("bookmark")
                              //     .doc(document["jobId"])
                              //     .delete();
                            }
                          });
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
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text("No Notification"),
          );
        },
      ),
    );
  }
}
