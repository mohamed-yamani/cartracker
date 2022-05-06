import 'dart:convert';

import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/latestLocalisation.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:print_color/print_color.dart';

class ApiLocalisation {
  late final data;
  Future<LatestLocalisation> getlatestlocalisation() async {
    TokenModel? tokenModel = await getToken();
    const String url = "$myUrl/api/user/3/localisation/";
    try {
      data = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          "authorization": "Bearer ${tokenModel?.token}",
        },
      );
      return LatestLocalisation.fromJson(jsonDecode(data.body));
      // return
    } catch (e) {
      throw 'please check your internet connection';
    }
  }
}
