import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/material.dart';
import 'package:mobile_guild_for_jobseekers_v3/auth/usertype.dart';

import 'jobdescription.dart';

class JobDescriptionScreen extends StatelessWidget {
  final JobDescription jobDescription;
  const JobDescriptionScreen({super.key, required this.jobDescription});

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Container(
      width: w * 0.7,
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.work),
          const SizedBox(width: 5.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  jobDescription.name,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${jobDescription.salary}/month",
                  style: const TextStyle(fontSize: 20.0),
                ),
                Text(
                  jobDescription.description,
                  style: const TextStyle(fontSize: 20.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          showIcon()
        ],
      ),
    );
  }

  Widget showIcon() {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Icon(Icons.more_vert));
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          if (userData!["userType"] == UserType.JOBSEEKER) {
            return IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 30,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                                leading: const Icon(Icons.view_agenda),
                                title: const Center(child: Text("View")),
                                onTap: () {
                                  context.pushNamed("view", params: {
                                    "name": jobDescription.name
                                  }, queryParams: {
                                    "salary": jobDescription.salary,
                                    "description": jobDescription.description
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("view")),
                                  );
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              leading: const Icon(Icons.send_outlined),
                              title: const Center(child: Text("Apply")),
                              onTap: () {
                                context.pushNamed("sendresume");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Apply")),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.save),
                              title: const Center(child: Text("Saved")),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Saved")),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          } else if (userData["userType"] == UserType.ADMIN) {
            return IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: SizedBox(
                        width: 30,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                                leading: const Icon(Icons.view_agenda),
                                title: const Center(child: Text("View")),
                                onTap: () {
                                  context.pushNamed("view", params: {
                                    "name": jobDescription.name
                                  }, queryParams: {
                                    "salary": jobDescription.salary,
                                    "description": jobDescription.description
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("view")),
                                  );
                                  Navigator.of(context).pop();
                                }),
                            ListTile(
                              leading: const Icon(Icons.approval),
                              title: const Center(child: Text("Delete")),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Delete")),
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        }

        return const SizedBox();
      },
    );
  }
}

List<JobDescription> jobdes = const <JobDescription>[
  JobDescription(name: "IT", description: "Fix Computer", salary: "100"),
  JobDescription(
      name: "Accountant", description: "Compute Financial", salary: "200"),
  JobDescription(name: "Engineer", description: "Fix someting", salary: "150"),
  JobDescription(name: "Doctor", description: "Cure sickness", salary: "110"),
  JobDescription(name: "Driver", description: "transport", salary: "100"),
];
