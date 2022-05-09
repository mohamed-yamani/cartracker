import 'package:carlock/model/utilisateurs_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class UserLivePage extends StatefulWidget {
  const UserLivePage({Key? key}) : super(key: key);

  @override
  State<UserLivePage> createState() => _UserLivePageState();
}

class _UserLivePageState extends State<UserLivePage> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    // if (Platform.isIOS) WebView.platform = IOSWebView();
  }

  @override
  Widget build(BuildContext context) {
    final params = ModalRoute.of(context)?.settings.arguments as Results;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        centerTitle: true,
        title: Text(
          'live stream ${params.firstName} ${params.lastName}',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: WebView(
        initialUrl: params.streamingUrl,
      ),
    );
  }
}
