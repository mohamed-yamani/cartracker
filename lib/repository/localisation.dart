import 'dart:async';
import 'dart:convert';

import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/latestLocalisation.dart';
import 'package:carlock/model/permission_model.dart';
import 'package:carlock/model/token.dart';
import 'package:carlock/repository/api_permission_repo.dart';
import 'package:carlock/repository/save_get_token.dart';
import 'package:carlock/repository/user_patch.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:print_color/print_color.dart';

class MyLocalisation {
  final Location _location = Location();
  late StreamSubscription locationSubscription;
  UserPatchLatLng? userPatchLatLng = UserPatchLatLng();
  late LocationData location;
  late List<dynamic> permissionList;
  bool can_sync_location = false;

  Future<void> updateLocation() async {
    location = await _location.getLocation();
    PermissionStatus locationUserHasPermission =
        await _location.hasPermission();
    if (locationUserHasPermission == PermissionStatus.granted) {
      Print.red(
          'location --------------------------------------: $locationUserHasPermission');
      _location.changeSettings(
        interval: 1500,
        // distanceFilter: 10,
      );

      locationSubscription =
          _location.onLocationChanged.listen((location) async {
        try {
          // bool localisationChanged = await updateLocationOnlyIfLocationChanges
          //     .handleLocationUpdate(Localisation(
          //         locationx.latitude.toString(), locationx.longitude.toString()));
          // localisationChanged = true;
          Print.red('location updated --- --- success');
          Print.green((location.latitude!).toString());
          Print.green((location.longitude!).toString());
          Print.red('location updated --- --- success');

          await userPatchLatLng!.updateCurrentUserInformation(
            LatLng(
              double.parse((location.latitude!).toString()),
              double.parse((location.longitude!).toString()),
            ),
          );
          // updateCarPosition();
          Print.red('location updated');
        } catch (e) {
          Print.red('location not updated');
        }
      });
    } else if (locationUserHasPermission == PermissionStatus.denied) {
      Print.red(
          'location --------------------------------------: $locationUserHasPermission');
      _location.requestPermission();
    } else {
      Print.red(
          'location --------------------------------------: $locationUserHasPermission');
      _location.requestPermission();
    }

    // updateZoom = true;
  }
}

class ApiLocalisation {
  late final data;
  Future<LatestLocalisation> getlatestlocalisation(String? id) async {
    TokenModel? tokenModel = await getToken();
    String url = "$myUrl/api/user/$id/localisation/";
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
