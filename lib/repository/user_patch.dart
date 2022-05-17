import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/localisation.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class UserPatchLatLng {
  late final data;

  Future<void> updateCurrentUserInformation(LatLng points) async {
    Print.green(points.latitude.toString());
    Print.green(points.longitude.toString());
    String token;

    //update localisation if localisation is changed and active
    Print.yellow('User information updated1');
    TokenModel? tokenModel = await getToken();
    try {
      data = await http.patch(
        Uri.parse(urlLocalisation),
        body: {
          "latitude": (points.latitude).toString(),
          "longitude": (points.longitude).toString(),
        },
        headers: {
          'Accept': 'application/json',
          "authorization": "Bearer ${tokenModel?.token}",
        },
      );
      Print.yellow('data.code: ${data.statusCode}');
      print(data);
      Print.red(data.body);
    } catch (e) {
      Print.red(e);
      throw e.toString();
    }
  }

  handleLocationUpdate(Localisation localisation) {}
}
