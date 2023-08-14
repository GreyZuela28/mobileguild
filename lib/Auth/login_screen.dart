import 'package:cloud_firestore/cloud_firestore.dart';
import "package:connectivity_plus/connectivity_plus.dart";
import "package:email_validator/email_validator.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/gestures.dart";
import 'package:firebase_messaging/firebase_messaging.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:mobile_guild_for_jobseekers_v3/utils/connection_status.dart";

import "../utils/utils.dart";
import "forgot_password_page.dart";

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  String? mtoken = '';
  String? user_id = '';
  //late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool showPassword = true;

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
                key: loginKey,
                child: AutofillGroup(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      const CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/icon.png"),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Hey There,\n Welcome Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: 32,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40),
                      // TextField(
                      //   controller: emailController,
                      //   cursorColor: Colors.white60,
                      //   textInputAction: TextInputAction.next,
                      //   decoration: const InputDecoration(
                      //     iconColor: Colors.white60,
                      //     labelStyle: TextStyle(color: Colors.white60),
                      //     labelText: "Email",
                      //     icon: Icon(Icons.email),
                      //   ),
                      // ),
                      TextFormField(
                        autofillHints: const [AutofillHints.email],
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
                        // onEditingComplete: () =>
                        //     TextInput.finishAutofillContext(),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? "Enter a valid email"
                                : null,
                      ),
                      const SizedBox(height: 4),
                      // TextField(
                      //   controller: passwordController,
                      //   textInputAction: TextInputAction.done,
                      //   decoration: InputDecoration(
                      //     iconColor: Colors.white60,
                      //     labelStyle: const TextStyle(color: Colors.white60),
                      //     labelText: "Password",
                      //     icon: const Icon(Icons.lock),
                      //     suffixIcon: IconButton(
                      //       icon: Icon(showPassword
                      //           ? Icons.visibility_off
                      //           : Icons.visibility),
                      //       onPressed: passwordShow,
                      //     ),
                      //   ),
                      //   obscureText: showPassword,
                      // ),
                      TextFormField(
                        autofillHints: const [AutofillHints.password],
                        obscuringCharacter: "*",
                        controller: passwordController,
                        // keyboardType: TextInputType.visiblePassword,
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
                        onEditingComplete: () =>
                            TextInput.finishAutofillContext(),
                        obscureText: showPassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? "Enter min. 6 characters"
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        icon: const Icon(Icons.lock_open, size: 32),
                        label: const Text(
                          "Sign In",
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: signIn,
                        
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          text: "No account? ",
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = widget.onClickedSignUp,
                              text: "SignUp",
                              style: TextStyle(
                                // decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.primary,
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
          ),
        ],
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    requestPermission();
    getToken();
    // initInfo();
  }
  
  // initInfo(){
  //   var androidInitilize = const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   var iOsIntialize = const IOSInitializationSettings();
  //   var initializationsSettings = InitializationSettings(android:  androidInitilize, iOS: iOsIntialize);

  //   FlutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) async {

  //   });
  // }

  requestPermission() async {
    FirebaseMessaging message = FirebaseMessaging.instance;

    NotificationSettings settings = await message.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,

    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      print('User is authorized');
    }
    else if(settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User is authorized with provisional permission');
    }
    else{
      print('User is unauthorized');
    }
  }
  
  void getToken() async{

  await FirebaseMessaging.instance.getToken().then(
          (token) {
        setState(() { 
              mtoken = token;
            });
          }
        );
  }

  passwordShow() {
    setState(() {
      showPassword = !showPassword;
    });
  }



  Future signIn() async {
    final isValid = loginKey.currentState!.validate();
    if (!isValid) return;

    ConnectionStatus.checkInternetConnection().then((value) async {
      if (value == ConnectivityResult.none) {
        ConnectionStatus.showInternetError(context);
      } else {
        try {
          FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
            FirebaseAuth.instance
            .authStateChanges()
            .listen((User? user) {
              if (user == null) {
                print('User is currently signed out!');
              } else {
                   db.collection("users").doc(user.uid).update({
                        'token': mtoken,
                    });
                  print('the token is $mtoken');
                  print('the uid is ${user.uid}');
              }
            });
            
          } 
        on FirebaseAuthException catch (e) {
          Utils.showSnackBar(e.message);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message!),
            ),
          );
        }
      }
    });
  }
 
}
