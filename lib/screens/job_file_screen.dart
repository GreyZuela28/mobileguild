import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';

class PDFScreen extends StatefulWidget {
  final String path;
  const PDFScreen({
    super.key,
    required this.path,
  });

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool hasInternetConnection = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });

    // if (result != ConnectivityResult.none) {
    //   bool internet = await InternetConnectionChecker().hasConnection;
    //   if (internet == true) {
    //     setState(() {
    //       hasInternetConnection = internet;

    //     });
    //   }
    // } else {
    //   setState(() {
    //     hasInternetConnection = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter PDF Viewer'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.bookmark,
        //       color: Colors.white,
        //       semanticLabel: 'Bookmark',
        //     ),
        //     onPressed: () {
        //       _pdfViewerKey.currentState?.openBookmarkView();
        //     },
        //   ),
        // ],
      ),
      body: _connectionStatus != ConnectivityResult.none
          ? SfPdfViewer.network(
              widget.path,
              key: _pdfViewerKey,
            )
          : Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // Set the width to half of the screen width
                height: MediaQuery.of(context).size.width *
                    0.8, // Set the height to the same as the width to make it a square
                child: Image.asset("assets/internet.png"),
              ),
            ),
    );
  }
}
