import 'dart:async';

import 'package:location/location.dart';

class GetLocalisation {
  void getNewLocalisation() async {
    //! get new localisation
    final Location _location = Location();
    var location = await _location.getLocation();
    late StreamSubscription _locationSubscription;

    _locationSubscription =
        _location.onLocationChanged.listen((locationx) async {
      _locationSubscription.cancel();
    });
  }
}
