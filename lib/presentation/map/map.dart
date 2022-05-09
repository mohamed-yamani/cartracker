import 'dart:async';

import 'package:carlock/constants/urls.dart';
import 'package:carlock/model/latestLocalisation.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/repository/localisation.dart';
import 'package:carlock/repository/user_patch.dart';
import 'package:carlock/services/update_location_only_if_location_changes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:print_color/print_color.dart';

import 'package:share/share.dart';

// https://matricule.icebergtech.net/api/match/?search=655
// https://matricule.icebergtech.net/api/match/?user=3

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late StreamSubscription _locationSubscription;
  GoogleMapController? _controller;
  final Location _location = Location();
  Marker? marker;
  Circle? circle;
  UserPatchLatLng? userPatchLatLng = UserPatchLatLng();
  late Timer _timer;
  bool updateZoom = true;
  bool liveLocalisation = false;
  bool mapCarte = false;
  UpdateLocationOnlyIfLocationChanges updateLocationOnlyIfLocationChanges =
      UpdateLocationOnlyIfLocationChanges();
  var location;
  bool firstTime = true;
  LatestLocalisation? latestLocalisation;

  // @override
  // void initState() {
  // sendNewLocation();
  //   updateCarPosition();
  //   super.initState();
  // }

  void updateCarPosition() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          getCurrontLocation();
        });
      }
    });
  }

  @override
  void dispose() {
    // _locationSubscription.cancel();

    // _timer.cancel();
    // _locationSubscription.di
    _controller?.dispose();
    super.dispose();
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   // ! check if _controller is null assign it to controller
  //   _controller ??= controller;
  //   setState(() {
  //     _markers.add(const Marker(
  //       markerId: MarkerId(
  //         'marker_id_1',
  //       ),
  //       position: LatLng(32.8821743, -6.897816),
  //       infoWindow: InfoWindow(
  //         title: 'share location',
  //         snippet: 'long press to share location',
  //       ),
  //     ));
  //   });
  // }

  static CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(32.8821743, -6.897816),
    zoom: 14.4746,
  );

  final _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    Results result = arguments as Results;
    LatLng latLng =
        LatLng(double.parse(result.latitude!), double.parse(result.longitude!));
    Print.red('latLng: $latLng');
    Print.green('latLng: $latLng');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text('carte'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                  '$googleShareLocation${latestLocalisation?.latitude},${latestLocalisation?.longitude}');
            },
          ),
        ],
      ),
      body: (double.parse(result.latitude!) == 0.0 &&
              double.parse(result.longitude!) == 0.0)
          ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Image.asset(
                  'assets/images/searchAnimation.gif',
                  fit: BoxFit.cover,
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(
                      child: Text('Aucune localisation disponible'),
                    ),
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                GoogleMap(
                    mapType: mapCarte ? MapType.normal : MapType.satellite,
                    initialCameraPosition: CameraPosition(
                      bearing: 0,
                      target: LatLng(double.parse(result.latitude!),
                          double.parse(result.longitude!)),
                      tilt: 59.440717697143555,
                      zoom: 14.4746,
                    ),
                    markers: Set<Marker>.of(_markers),
                    onMapCreated: (GoogleMapController controller) {
                      // ! check if _controller is null assign it to controller
                      // _controller ??= controller;
                      setState(() {
                        _markers.add(Marker(
                          markerId: MarkerId(
                            result.matriculeStr!,
                          ),
                          position: LatLng(double.parse(result.latitude!),
                              double.parse(result.longitude!)),
                          infoWindow: InfoWindow(
                            title: result.matriculeStr!,
                            // snippet: 'voiture est
                          ),
                        ));
                      });
                    }),
                Container(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          mapCarte = !mapCarte;
                        });
                      },
                      child: Icon(
                        Icons.map,
                        color: (mapCarte) ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                )
                // const ButtonTextNewPosition(),
              ],
            ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        height: 55,
        width: MediaQuery.of(context).size.width,
        // color: Colors.red,
        margin: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 10, bottom: 20),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     // FloatingActionButton(
        //     //   onPressed: () {
        //     //     Print.magenta('pressed');
        //     //     liveLocalisation = !liveLocalisation;
        //     //     sendNewLocation();
        //     //     setState(() {
        //     //       liveLocalisation;
        //     //     });
        //     //     // sendNewLocation();
        //     //     // getCurrontLocation();
        //     //   },
        //     //   child: Icon((liveLocalisation) ? Icons.stop : Icons.play_arrow),
        //     // ),
        //     // const SizedBox(width: 50),
        //     // FloatingActionButton(
        //     //   onPressed: () {
        //     //     Share.share(
        //     //         'share is here');
        //     //     Print.red('pressed');
        //     //   },
        //     //   child: const Icon(Icons.share),
        //     // ),
        //   ],
        // ),
      ),
    );
  }

  // Future<Uint8List> getMarker() async {
  //   ByteData byteData =
  //       await DefaultAssetBundle.of(context).load('assets/images/marker.png');
  //   return byteData.buffer.asUint8List();
  // }

  void updateMarkerAndCircle(
    latestLocalisation,
    // Uint8List markerImageData
  ) {
    LatLng latLng = LatLng(double.parse(latestLocalisation.latitude!),
        double.parse(latestLocalisation.longitude!));

    // latLng =
    // ignore: unnecessary_this
    this.setState(
      () {
        SetMarker(latLng);
      },
    );
  }

  void SetMarker(LatLng latLng) {
    marker = Marker(
      markerId: const MarkerId('car_marker'),
      position: latLng,
      rotation: 180,
      zIndex: 2,
      draggable: false,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      // icon: BitmapDescriptor.fromBytes(markerImageData),
      infoWindow: const InfoWindow(
        title: 'car_marker',
        snippet: '65528-A-8',
      ),
    );
    circle = Circle(
      circleId: const CircleId('car_circle'),
      // radius: location.accuracy! * 5,
      strokeColor: Colors.red,
      strokeWidth: 2,
      zIndex: 1,
      center: latLng,
      fillColor: Colors.red.withAlpha(70),
    );
  }

  Future<void> sendNewLocation() async {
    location = await _location.getLocation();
    firstTime = false;

    _locationSubscription =
        _location.onLocationChanged.listen((locationx) async {
      try {
        // bool localisationChanged = await updateLocationOnlyIfLocationChanges
        //     .handleLocationUpdate(Localisation(
        //         locationx.latitude.toString(), locationx.longitude.toString()));
        // localisationChanged = true;

        await userPatchLatLng!.updateCurrentUserInformation(
          LatLng(
            double.parse((location.latitude!).toStringAsFixed(4)),
            double.parse((location.longitude!).toStringAsFixed(4)),
          ),
        );
        updateCarPosition();
        Print.red('location updated');
      } catch (e) {
        Print.red('location not updated');
      }
    });

    updateZoom = true;
  }

  Future<void> getCurrontLocation() async {
    try {
      // Uint8List markerImageData = await getMarker();

      latestLocalisation = await ApiLocalisation().getlatestlocalisation();

      updateMarkerAndCircle(
        latestLocalisation,
        // markerImageData,
      );

      if (_controller != null) {
        var zoom = await _controller!.getZoomLevel();
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(double.parse(latestLocalisation!.latitude!),
                  double.parse(latestLocalisation!.longitude!)),
              tilt: 0,
              zoom: updateZoom ? 15 : zoom,
            ),
          ),
        );

        updateZoom = false;
        updateMarkerAndCircle(
          latestLocalisation,
          // markerImageData,
        );
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Permission denied');
      }
    }
  }

  Widget oldMap() {
    return GoogleMap(
      mapType: (mapCarte) ? MapType.hybrid : MapType.normal,
      initialCameraPosition: initialCameraPosition,
      // onMapCreated: _onMapCreated,
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        // _onMapCreated(controller);
      },
      // onLongPress: (LatLng latLng) {
      //   //share location
      //   Share.share(
      //       '$googleShareLocation${latLng.latitude},${latLng.longitude}');
      // },
      // ignore: unnecessary_null_comparison
      markers: Set.of((marker != null) ? [marker!] : []),
      // ignore: unnecessary_null_comparison
      circles: Set.of((circle != null) ? [circle!] : []),
      onTap: (LatLng latLng) {
        setState(() {
          Print.red('Tapped on $latLng');
          // _markers.add(Marker(
          //   markerId: MarkerId(
          //     'marker_id_${_markers.length + 1}',
          //   ),
          //   position: latLng,
          //   infoWindow: InfoWindow(
          //     title: 'Marker',
          //     snippet: 'This is my home',
          //   ),
          // ));
        });
      },
    );
    // const ReturnButton(),
  }
}

// class ReturnButton extends StatelessWidget {
//   const ReturnButton({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.topLeft,
//       margin: const EdgeInsets.only(top: 40, left: 10),
//       height: 45.0,
//       width: 45.0,
//       child: FittedBox(
//         child: FloatingActionButton(
//           backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
//           elevation: 0,
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Padding(
//             padding: EdgeInsets.only(left: 8.0),
//             child: Icon(
//               Icons.arrow_back_ios,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ButtonTextNewPosition extends StatelessWidget {
//   const ButtonTextNewPosition({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           alignment: Alignment.bottomCenter,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Text(
//               'enregistrer',
//               // '1337 future is loading',
//               style: TextStyle(
//                   color: Theme.of(context).primaryColorLight,
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ButtonSharePosition extends StatelessWidget {
//   const ButtonSharePosition({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.bottomCenter,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Text(
//           'enregistrer',
//           // '1337 future is loading',
//           style: TextStyle(
//               color: Theme.of(context).primaryColorLight,
//               fontSize: 10,
//               fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
