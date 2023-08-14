import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_guild_for_jobseekers_v3/Auth/usertype.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<AdminUsersPage> {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 1,
        title: const Text(
          "Users",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
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
                          child: Text("JOBSEEKER"),
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
                          child: Text("EMPLOYER"),
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
                  StreamBuilder<QuerySnapshot>(
                    stream: usersCollection
                        .where('userType', isEqualTo: 'jobseeker')
                        .orderBy("name")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data!.size == 0) {
                        return const Center(
                          child: Text('No Users'),
                        );
                      }

                      // if (snapshot.hasData) {
                      return ListView.separated(
                        padding:
                            const EdgeInsets.only(top: 10, right: 5, left: 5),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          final document = snapshot.data!.docs
                              .elementAt(index)
                              .data() as Map<String, dynamic>;

                          return ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () {
                              context.pushNamed("jobseeker", queryParams: {
                                "id": document["id"],
                                "profilePic": document["profilePic"],
                                "name": document["name"],
                                "userType": document["userType"],
                                "address": document["address"],
                                "email": document["email"],
                                "loginTime": document["loginTime"].toString(),
                                "mobileNumber":
                                    document["mobileNumber"].toString(),
                                "education":
                                    document["educationAttainment"].toString(),
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
                                    backgroundImage:
                                        AssetImage("assets/icon.png"),
                                  ),
                            // leading: const Icon(Icons.people),
                            title: Text(document["name"]),
                            subtitle: Text(document["email"]),
                            trailing: IconButton(
                              onPressed: () {
                                confirm(document["id"]);
                              },
                              color: Colors.red,
                              splashColor: Colors.red,
                              highlightColor: Colors.redAccent,
                              tooltip: "Delete",
                              icon: const Icon(Icons.delete_outlined),
                              selectedIcon: const Icon(Icons.delete),
                            ),
                          );
                        },
                      );
                    },
                    //   return SizedBox();
                    // },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: usersCollection
                        .where('userType', isEqualTo: 'employer')
                        .orderBy("name")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // if (snapshot.hasData) {
                      return ListView.separated(
                        padding:
                            const EdgeInsets.only(top: 10, right: 5, left: 5),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                        itemBuilder: (BuildContext context, int index) {
                          final document = snapshot.data!.docs
                              .elementAt(index)
                              .data() as Map<String, dynamic>;

                          return ListTile(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () {
                              context.pushNamed("employer", queryParams: {
                                "id": document["id"],
                                "profilePic": document["profilePic"],
                                "name": document["name"],
                                "userType": document["userType"],
                                "businessName": document["businessName"],
                                "address": document["address"],
                                "email": document["email"],
                                "loginTime": document["loginTime"].toString(),
                                "mobileNumber":
                                    document["mobileNumber"].toString(),
                                // "education":
                                // document["educationAttainment"].toString(),
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
                                    backgroundImage:
                                        AssetImage("assets/icon.png"),
                                  ),
                            // leading: const Icon(Icons.people),
                            title: Text(document["name"]),
                            subtitle: Text(document["email"]),
                            trailing: IconButton(
                              onPressed: () {
                                confirm(document["id"]);
                              },
                              color: Colors.red,
                              splashColor: Colors.red,
                              highlightColor: Colors.redAccent,
                              tooltip: "Delete",
                              icon: const Icon(Icons.delete_outlined),
                              selectedIcon: const Icon(Icons.delete),
                            ),

                            // trailing: ElevatedButton.icon(
                            //   onPressed: () {
                            //     FirebaseFirestore.instance
                            //         .collection("users")
                            //         .doc(document["id"])
                            //         .delete();
                            //   },
                            //   icon: Icon(Icons.delete_outlined),
                            //   label: Text("delete"),
                            // ),
                            // subtitle: Text(document["description"]),
                          );
                        },
                      );
                      // }
                      // return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void confirm(String id) {
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
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      color: Colors.grey,
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Are you sure to delete this user?"),
                    const SizedBox(height: 10),
                    Container(
                      height: 1,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
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
                          .doc(id)
                          .delete();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("user deleted"),
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
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
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
  }
}
