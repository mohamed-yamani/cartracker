import 'dart:async';
import 'dart:convert';

import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/latestLocalisation.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/repository/update_location.dart';
import 'package:carlock/repository/user_patch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:print_color/print_color.dart';

class My_Localisation {
  final Location _location = Location();
  late StreamSubscription locationSubscription;
  UserPatchLatLng? userPatchLatLng = UserPatchLatLng();
  late LocationData location;

  Future<void> updateLocation() async {
    location = await _location.getLocation();

    locationSubscription =
        _location.onLocationChanged.listen((locationx) async {
      try {
        // bool localisationChanged = await updateLocationOnlyIfLocationChanges
        //     .handleLocationUpdate(Localisation(
        //         locationx.latitude.toString(), locationx.longitude.toString()));
        // localisationChanged = true;
        Print.red('location updated --- --- success');
        Print.green((location.latitude!).toStringAsFixed(4));
        Print.green((location.longitude!).toStringAsFixed(4));
        Print.red('location updated --- --- success');

        await userPatchLatLng!.updateCurrentUserInformation(
          LatLng(
            double.parse((location.latitude!).toStringAsFixed(4)),
            double.parse((location.longitude!).toStringAsFixed(4)),
          ),
        );
        // updateCarPosition();
        Print.red('location updated');
      } catch (e) {
        Print.red('location not updated');
      }
    });

    // updateZoom = true;
  }
}

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
