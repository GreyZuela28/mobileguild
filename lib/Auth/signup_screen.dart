import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_guild_for_jobseekers_v3/auth/usertype.dart';
import 'package:mobile_guild_for_jobseekers_v3/users/educationalAttainment.dart';
import 'package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart';

import '../firebase/database.dart';
import '../main.dart';
import '../users/employer.dart';
import '../users/user_model.dart';
import '../utils/utils.dart';
import 'package:uuid/uuid.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const SignUpWidget({super.key, required this.onClickedSignUp});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final coursekey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final businessNameController = TextEditingController();
  TextEditingController courseController = TextEditingController();

  String? level;
  String? category;

  String userType = "jobseeker";
  bool showPassword = true;
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final educationAttainmentCategory = [
    "Elementary Graduate",
    "Highschool Undergraduate",
    "Highschool Graduate",
    "Vocational",
    "College Undergraduate",
    "College Graduate",
  ];

  final categories = [
    "Technology",
    "Education",
    "Government",
    "Health",
    "Service",
    "Transportation",
    "Construction",
    "Finance",
    "Other"
  ];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    mobileNumberController.dispose();
    nameController.dispose();
    courseController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void setDefault() {
    nameController.clear();
    level = null;
    category = null;
    courseController.clear();
    mobileNumberController.clear();
    emailController.clear();
    passwordController.clear();
    addressController.clear();
  }

  // Create a new instance of the UUID class
  var uuid = const Uuid();

  Future<void> courseCategory(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              actions: [
                TextButton(
                  child: const Text("save"),
                  onPressed: () {
                    final isValid = coursekey.currentState!.validate();
                    if (!isValid) return;
                    Navigator.of(context).pop();
                  },
                ),
              ],
              content: Form(
                key: coursekey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      child: DropdownButtonFormField(
                        value: category,
                        items: categories
                            .map((e) =>
                                DropdownMenuItem(child: Text(e), value: e))
                            .toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              category = value;
                              courseController.clear();
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.blueGrey,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        dropdownColor: Colors.deepPurple.shade50,
                        decoration: const InputDecoration(
                          labelText: "Job Category",
                          border: UnderlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "Please select category";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    TextFormField(
                      controller: courseController,
                      validator: (value) {
                        return value!.isNotEmpty
                            ? null
                            : "Please provide your specialization";
                      },
                      decoration: const InputDecoration(
                          labelText: "Specialization / Job / Course"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          "Welcome \n * ${userType.toUpperCase()} *",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: 30, color: Colors.white70),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          child: Row(
                            children: [
                              Expanded(
                                child: RadioListTile(
                                  activeColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    "Jobseeker",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  dense: true,
                                  value: "jobseeker",
                                  groupValue: userType,
                                  onChanged: (value) {
                                    setState(() {
                                      userType = value.toString();
                                      setDefault();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RadioListTile(
                                  activeColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: const Text(
                                    "Employer",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  dense: true,
                                  value: "employer",
                                  groupValue: userType,
                                  onChanged: (value) {
                                    setState(() {
                                      userType = value.toString();
                                      // educationalAttainment = null;
                                      setDefault();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: nameController,
                            cursorColor: Colors.white,
                            // keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              iconColor: Colors.white70,
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              icon: Icon(Icons.people),
                              labelText: "Name",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.isEmpty
                                ? "Enter Full Name"
                                : null,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: addressController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                              iconColor: Colors.white70,
                              labelStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              icon: const Icon(Icons.location_city),
                              labelText: userType != UserType.JOBSEEKER
                                  ? "Business Address"
                                  : "Address",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null && value.isEmpty
                                ? "Enter Address"
                                : null,
                          ),
                          const SizedBox(height: 10),
                          userType == UserType.JOBSEEKER
                              ? SizedBox(
                                  child: DropdownButtonFormField(
                                    value: level,
                                    items: educationAttainmentCategory
                                        .map((e) => DropdownMenuItem(
                                            child: Text(e), value: e))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          level = value;

                                          courseCategory(context);
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.blueGrey,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    dropdownColor: Colors.deepPurple.shade50,
                                    decoration: const InputDecoration(
                                      iconColor: Colors.white70,
                                      labelStyle: TextStyle(
                                        color: Colors.white70,
                                      ),
                                      labelText: "Educational Attainment",
                                      icon: Icon(
                                        Icons.cast_for_education,
                                      ),
                                      border: UnderlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select educational attainment";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                )
                              : TextFormField(
                                  controller: businessNameController,
                                  cursorColor: Colors.white,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    iconColor: Colors.white70,
                                    labelStyle: TextStyle(
                                      color: Colors.white70,
                                    ),
                                    icon: Icon(Icons.business_outlined),
                                    labelText: "Company / Business Name",
                                  ),
                                  // keyboardType: TextInputType.number,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) =>
                                      value != null && value.isEmpty
                                          ? "Enter Business Name"
                                          : null,
                                ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: mobileNumberController,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              iconColor: Colors.white70,
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              icon: Icon(Icons.phone),
                              labelText: "Mobile Number",
                            ),
                            keyboardType: TextInputType.phone,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) => value != null &&
                                    value.length == 11 &&
                                    value.startsWith("09")
                                ? null
                                : "Enter valid number",
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            cursorColor: Colors.white,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              iconColor: Colors.white70,
                              labelStyle: TextStyle(
                                color: Colors.white70,
                              ),
                              icon: Icon(Icons.email),
                              labelText: "Email",
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (email) =>
                                email != null && !EmailValidator.validate(email)
                                    ? "Enter a valid email"
                                    : null,
                          ),
                          const SizedBox(height: 5),
                          TextFormField(
                            obscuringCharacter: "*",
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              iconColor: Colors.white70,
                              labelStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              icon: const Icon(Icons.lock),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: passwordShow,
                              ),
                            ),
                            obscureText: showPassword,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) =>
                                value != null && value.length < 6
                                    ? "Enter min. 6 characters"
                                    : null,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
                            icon: const Icon(Icons.arrow_forward, size: 32),
                            label: const Text(
                              "Sign Up",
                              style: TextStyle(fontSize: 24),
                            ),
                            onPressed: signUp,
                          ),
                          const SizedBox(height: 20),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              text: "Already have an account? ",
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = widget.onClickedSignUp,
                                  text: "Login",
                                  style: TextStyle(
                                    // decoration: TextDecoration.underline,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }

  passwordShow() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    final education = EducationalAttainment(
      level: level,
      category: category,
      course: courseController.text.trim(),
    );

    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("users")
        .doc("cdhly3g4IsMb7vL0TYc8YmEpUpZ2")
        .get();

    var newDocument = uuid.v1();

    print(document["profilePic"]);

    ConnectionStatus.checkInternetConnection().then(
      (value) {
        if (value == ConnectivityResult.none) {
          ConnectionStatus.showInternetError(context);
        } else {
          try {
            FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                )
                .then(
                  (value) =>
                      db.collection("users").doc(auth.currentUser?.uid).set({
                    "id": auth.currentUser?.uid,
                    "userType": userType,
                    "name": nameController.text.trim(),
                    "address": addressController.text.trim(),
                    if (userType == UserType.JOBSEEKER)
                      "educationAttainment": education.toMap(),
                    if (userType == UserType.EMPLOYER)
                      "businessName": businessNameController.text.trim(),
                    "mobileNumber":
                        int.parse(mobileNumberController.text.trim()),
                    "profilePic": null,
                    "email": emailController.text.trim(),
                    "isValidated": false,
                    if (userType == UserType.JOBSEEKER) "resume": null,
                    "loginTime": DateTime.now(),
                  }),
                )
                .then(
                  (value) => FirebaseFirestore.instance
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .collection("notification")
                      .doc(newDocument)
                      .set({
                    "profilePic": document["profilePic"],
                    "notificationId": newDocument,
                    "name": "3B1C",
                    "description": "Welcome to Mobile Guild for Jobseekers",
                    "date": DateTime.now(),
                  }),
                );
          } on FirebaseAuthException catch (e) {
            Utils.showSnackBar(e.message);
          }
        }
      },
    );

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
