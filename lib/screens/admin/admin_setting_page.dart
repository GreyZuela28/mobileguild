import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  // String? _uploadFileURl;
  UploadTask? uploadTask;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        print(_photo);
        uploadFile();
      } else {
        print("No image selected...");
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        print(_photo);
        uploadFile();
      } else {
        print("No Image selected..");
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;

    // final fileName = Path.basename(_photo!.path);
    // final destination = "profiles/$fileName";

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final ref = firebase_storage.FirebaseStorage.instance
          .ref("profile")
          .child(fileName);
      uploadTask = ref.putFile(_photo!);

      uploadTask!.snapshotEvents.listen((snapshot) {
        if (snapshot.state == TaskState.running) {
          double progress =
              snapshot.bytesTransferred / snapshot.totalBytes * 100;

          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {}); // update the UI after the delay
          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Uploading State"),
                  content: SizedBox(
                    height: 50,
                    child: Stack(fit: StackFit.expand, children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey,
                        color: Colors.green,
                      ),
                      Center(
                        child: Text(
                          "${progress.toStringAsFixed(0)}%",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
                  ),
                  actions: [
                    progress == 100
                        ? TextButton(
                            onPressed: () {
                              context.pop();
                              context.pop();
                              context.pop();
                            },
                            child: const Text("Done"))
                        : TextButton(
                            onPressed: () {},
                            child: const Text("Ok"),
                          )
                  ],
                );
              });
        } else if (snapshot.state == TaskState.success) {
          getUrl(ref).then((uploadFileURl) {
            FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({"profilePic": uploadFileURl});
          });
        }
      });
    } catch (e) {
      print("Error occured...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Settings"),
      ),
      body: Center(
        child: userDetails(),
      ),
    );
  }

  Widget userDetails() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final userData = snapshot.data!.data()!;

          return Stack(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.yellow,
                                ],
                                stops: [0.4, 1],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(3, 6),
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(-2, -4),
                                ),
                              ],
                            ),
                            width: double.maxFinite,
                            margin: const EdgeInsets.only(
                              right: 10.0,
                              left: 10.0,
                              top: 30.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 35),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 35),
                                    const Center(
                                      child: Text(
                                        "Personal Information:",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          // Text("ID: ${userData["id"]}",
                                          //     style: userTextStyle()),
                                          const SizedBox(height: 5),
                                          Text("Name: ${userData["name"]}"),

                                          const SizedBox(height: 5),
                                          Text(
                                              "Mobile Number: 0${userData["mobileNumber"]}"),
                                          const SizedBox(height: 5),
                                          Text("Email: ${userData["email"]}"),
                                          const SizedBox(height: 5),
                                          Text(
                                              "Address: ${userData["address"]}",
                                              style: userTextStyle()),

                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    userData["profilePic"] != null
                                        ? CircleAvatar(
                                            radius: 50,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset: const Offset(3, 6),
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 2,
                                                    offset:
                                                        const Offset(-2, -3),
                                                  ),
                                                ],
                                              ),
                                              child: ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      userData["profilePic"],
                                                  placeholder: (context, url) =>
                                                      const CircularProgressIndicator(),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error,
                                                          size: 45),
                                                  fit: BoxFit.cover,
                                                  width: 100,
                                                  height: 100,
                                                ),
                                              ),
                                            ),
                                          )
                                        : const CircleAvatar(
                                            backgroundImage:
                                                AssetImage("assets/icon.png"),
                                            radius: 50,
                                          ),
                                    userData["profilePic"] != null
                                        ? Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                iconSize: 25,
                                                icon: const Icon(Icons
                                                    .check_circle_outlined),
                                                onPressed: () {
                                                  // do something when the icon button is pressed
                                                  // _showPicker(context);
                                                },
                                              ),
                                            ),
                                          )
                                        : Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButton(
                                                alignment: Alignment.center,
                                                iconSize: 25,
                                                icon: const Icon(
                                                  Icons.add_a_photo_rounded,
                                                ),
                                                onPressed: () {
                                                  // do something when the icon button is pressed
                                                  ConnectionStatus
                                                          .checkInternetConnection()
                                                      .then((value) {
                                                    if (value ==
                                                        ConnectivityResult
                                                            .none) {
                                                      ConnectionStatus
                                                          .showInternetError(
                                                              context);
                                                    } else {
                                                      _showPicker(context);
                                                    }
                                                  });
                                                },
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
                      const SizedBox(height: 25.0),
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.yellow,
                            ],
                            stops: [0.4, 1],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(3, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: const Offset(-2, -4),
                            ),
                          ],
                        ),
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(
                          right: 10.0,
                          left: 10.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                "Login Information:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text("UserType: ${userData["userType"]}"),
                                  const SizedBox(height: 5),
                                  Text(
                                      "Login Time: ${DateFormat('yyyy-MM-dd').format(userData["loginTime"].toDate()).toString()}"),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  TextStyle userTextStyle() => const TextStyle(
        fontSize: 14,
      );

  Future<String> getUrl(Reference ref) async {
    String uploadFileURl = await ref.getDownloadURL();

    return uploadFileURl;
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
