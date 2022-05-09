import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:print_color/print_color.dart';

class FirbaseConfiguration {
  Future<String?> get_reg_id() async {
    String? regId = await FirebaseMessaging.instance.getToken();
    return regId;
  }
}
