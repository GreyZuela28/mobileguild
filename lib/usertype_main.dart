import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth/usertype.dart';
import 'screens/jobseeker/jobseeker_main_page.dart';
import 'screens/admin/admin_main_page.dart';
import 'screens/employer/employer_main_page.dart';

class UserTypePage extends StatefulWidget {
  const UserTypePage({super.key});

  @override
  State<UserTypePage> createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data();

          if (userData!["userType"] == UserType.JOBSEEKER) {
            return const JobseekerMainPage();
          } else if (userData["userType"] == UserType.EMPLOYER) {
            return const EmployerMainPage();
          }
          return const AdminMainPage();
        }

        return Container();
      },
    );
  }
}
