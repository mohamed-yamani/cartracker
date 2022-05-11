import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:print_color/print_color.dart';

class BackgroundJobs {

  static const androidConfig = FlutterBackgroundAndroidConfig(
  notificationTitle: "carlock",
  notificationText:
      "Background notification for keeping the example app running in the background",
  notificationImportance: AndroidNotificationImportance.Default,
  notificationIcon: AndroidResource(
      name: 'background_icon',
      defType: 'drawable'), // Default is ic_launcher from folder mipmap
);

  Future<void> initializeBackgroundJobs() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool success =
      await FlutterBackground.initialize(androidConfig: androidConfig);
  bool successRuning = await FlutterBackground.enableBackgroundExecution();

  Print.white('success : ' + success.toString());
  Print.white('successRuning : ' + successRuning.toString());
}
}