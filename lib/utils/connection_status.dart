import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatus {
  static Future<ConnectivityResult> checkInternetConnection() async {
    ConnectivityResult connectionStatus =
        await Connectivity().checkConnectivity();
    return connectionStatus;
  }

  static void showInternetError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.signal_wifi_off),
                  SizedBox(width: 10.0),
                  Text(
                    "Connection Error",
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
              const Text(
                "Please check your internet connection. Try again",
                textAlign: TextAlign.center,
              ),
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
                context.pop();
              },
              child: const Text("OK"),
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
}
