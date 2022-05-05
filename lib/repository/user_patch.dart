import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class UserPatchLatLng {
  late final data;
  var rng = new Random();

  Future<void> updateCurrentUserInformation(LatLng points) async {
    Print.green(points.latitude.toString());
    Print.green(points.longitude.toString());
    const String url =
        "https://matricule.icebergtech.net/api/user/me/set_localisation/";
    try {
      data = await http.patch(
        Uri.parse(url),
        body: {
          "latitude": (points.latitude).toString(),
          "longitude": (points.longitude).toString(),
        },
        headers: {
          'Accept': 'application/json',
          "authorization": "Bearer " "babcc1fef4eada4129bc0976367ffaba84a30fb8",
        },
      );
      print(data);
      Print.yellow(data.body);
    } catch (e) {
      throw e.toString();
    }
  }
}
