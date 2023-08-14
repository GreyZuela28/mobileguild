import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';

class AdminNotificationPage extends StatefulWidget {
  const AdminNotificationPage({super.key});

  @override
  State<AdminNotificationPage> createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("notification")
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
              child: Text('No notification'),
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
                int daysPassed = DateTime.now().difference(documentDate).inDays;
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
                    context.pushNamed("notification", queryParams: {
                      "name": document["name"],
                      "description": document["description"]
                    });
                  },
                  splashColor: Colors.grey[300],
                  tileColor: Colors.amberAccent,
                  // leading: const Icon(Icons.people),
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
                  title: Text(document["name"]),
                  subtitle: Text(document["description"]),
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
                              FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection("notification")
                                  .doc(document["notificationId"])
                                  .delete();
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
