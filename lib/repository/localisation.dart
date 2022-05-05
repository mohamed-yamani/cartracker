import 'dart:convert';

import 'package:carlock/model/latestLocalisation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class ApiLocalisation {
  late final data;
  Future<LatestLocalisation> getlatestlocalisation() async {
    const String url =
        "https://matricule.icebergtech.net/api/user/3/localisation/";
    try {
      data = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          "authorization": "Bearer " "babcc1fef4eada4129bc0976367ffaba84a30fb8",
        },
      );
      return LatestLocalisation.fromJson(jsonDecode(data.body));
      // return
    } catch (e) {
      throw 'please check your internet connection';
    }
  }
}
