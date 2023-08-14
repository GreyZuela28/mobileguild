import 'package:flutter/material.dart';

class NotifScreen extends StatefulWidget {
  final String? message;
  final String? title;

  NotifScreen({Key? key, required this.message, required this.title}) : super(key: key);

  @override
  _NotifScreenState createState() => _NotifScreenState();
}

class _NotifScreenState extends State<NotifScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Notification Message For Product: \n ${widget.message}',
            ),
          ],
        ),
      ),
    );
  }
}