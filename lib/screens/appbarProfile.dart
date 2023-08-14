import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class AppBarProfile extends StatefulWidget {
  const AppBarProfile({super.key});

  @override
  State<AppBarProfile> createState() => _AppBarProfileState();
}

class _AppBarProfileState extends State<AppBarProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircleAvatar(
            backgroundImage: AssetImage("assets/pita.png"),
          );
        }

        final userData = snapshot.data!.data()!;

        return Row(
          children: [
            userData["profilePic"] != null
                ? CircleAvatar(
                    radius: 20,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: userData["profilePic"],
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
                    radius: 20,
                    backgroundImage: AssetImage("assets/icon.png"),
                  ),
            const SizedBox(width: 8.0),
            Text(userData["name"],
                style: const TextStyle(
                  fontSize: 15,
                )),
          ],
        );
      },
    );
  }

}
