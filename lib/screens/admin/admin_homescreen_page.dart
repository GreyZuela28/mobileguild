import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:mobile_guild_for_jobseekers_v3/screens/appbarProfile.dart';

import '../../Jobs/selectjob.dart';

class AdminHomeScreenPage extends StatefulWidget {
  const AdminHomeScreenPage({super.key});

  @override
  State<AdminHomeScreenPage> createState() => _AdminHomeScreenPageState();
}

class _AdminHomeScreenPageState extends State<AdminHomeScreenPage> {
  // final db = FirebaseApi();
  final auth = FirebaseAuth.instance;

  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarProfile(),
        // leading: ,
        actions: [
          PopupMenuButton<int>(
            onSelected: (index) {},
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {
                    context.push("/adminsettings");
                  },
                  value: 0,
                  child: Row(
                    children: const [
                      Icon(Icons.settings, color: Colors.black),
                      SizedBox(width: 5),
                      Text(
                        "Setting",
                        // auth.currentUser!.email!.substring(
                        //     0, auth.currentUser?.email!.indexOf("@")),
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  onTap: () {
                    auth.signOut();
                  },
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 5),
                      Text("Logout"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.yellow,
            ],
            stops: [0.4, 1],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            // crossAxisSpacing: 4.0,
            // mainAxisSpacing: 8.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 15.0,
            children: List.generate(choices.length, (index) {
              return Center(
                child: SelectJob(job: choices[index]),
              );
            }),
          ),
        ),
      ),
    );
  }
}
