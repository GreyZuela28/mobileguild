import 'package:flutter/material.dart';
import 'package:mobile_guild_for_jobseekers_v3/auth/signup_screen.dart';

import 'login_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginWidget(onClickedSignUp: toggle)
        : SignUpWidget(onClickedSignUp: toggle);
  }

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
