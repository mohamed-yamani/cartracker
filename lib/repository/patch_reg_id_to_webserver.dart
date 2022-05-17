import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class RegIdToWebserver {
  late final data;

  Future<void> PatchRegIdToWS(String? regId) async {
    //update localisation if localisation is changed and active
    Print.yellow('User information updated');
    TokenModel? tokenModel = await getToken();
    Print.green(regId);
    try {
      data = await http.patch(
        // Uri.parse('https://platereader.icebergtech.netapi/user/me/'),
        Uri.parse('$myUrl/api/user/me/'),
        body: {
          "reg_id": regId,
        },
        headers: {
          'Accept': 'application/json',
          "authorization": "Bearer ${tokenModel?.token}",
        },
      );
      Print.green(data);
      Print.yellow(data.body);
    } catch (e) {
      throw e.toString();
    }
  }
}
