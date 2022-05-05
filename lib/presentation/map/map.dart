import 'dart:async';

import 'package:carlock/model/latestLocalisation.dart';
import 'package:carlock/repository/localisation.dart';
import 'package:carlock/repository/user_patch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:print_color/print_color.dart';
import 'dart:typed_data';

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

  @override
  void initState() {
    // TODO: implement initState
    sendNewLocation();
    updateCarPosition();
    super.initState();
  }

  void updateCarPosition() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        getCurrontLocation();
      });
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    _timer.cancel();
    // _locationSubscription.di
    _controller?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    // ! check if _controller is null assign it to controller
    _controller ??= controller;
    setState(() {
      _markers.add(const Marker(
        markerId: MarkerId(
          'marker_id_1',
        ),
        position: LatLng(32.8821743, -6.897816),
        infoWindow: InfoWindow(
          title: 'share location',
          snippet: 'long press to share location',
        ),
      ));
    });
  }

  static CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(32.8821743, -6.897816),
    zoom: 14.4746,
  );

  final _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: (mapCarte) ? MapType.hybrid : MapType.normal,
            initialCameraPosition: initialCameraPosition,
            // onMapCreated: _onMapCreated,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              // _onMapCreated(controller);
            },
            onLongPress: (LatLng latLng) {
              //share location
              Share.share(
                  'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}');
            },
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
          ),
          const ReturnButton(),
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
                  color: (mapCarte) ? Colors.blue : Colors.grey,
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

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load('assets/images/marker.png');
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(
      LatestLocalisation latestLocalisation, Uint8List markerImageData) {
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
    var location = await _location.getLocation();

    _locationSubscription =
        _location.onLocationChanged.listen((locationx) async {
      await userPatchLatLng!.updateCurrentUserInformation(
        LatLng(
          double.parse((location.latitude!).toStringAsFixed(5)),
          double.parse((location.longitude!).toStringAsFixed(5)),
        ),
      );
      updateCarPosition();

      Print.red('location updated');
    });

    updateZoom = true;
  }

  Future<void> getCurrontLocation() async {
    try {
      Uint8List markerImageData = await getMarker();

      LatestLocalisation latestLocalisation =
          await ApiLocalisation().getlatestlocalisation();

      updateMarkerAndCircle(
        latestLocalisation,
        markerImageData,
      );

      if (_controller != null) {
        var zoom = await _controller!.getZoomLevel();
        _controller?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(double.parse(latestLocalisation.latitude!),
                  double.parse(latestLocalisation.longitude!)),
              tilt: 0,
              zoom: updateZoom ? 15 : zoom,
            ),
          ),
        );
        updateZoom = false;
        updateMarkerAndCircle(
          latestLocalisation,
          markerImageData,
        );
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint('Permission denied');
      }
    }
  }
}

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

class ReturnButton extends StatelessWidget {
  const ReturnButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 40, left: 10),
      height: 45.0,
      width: 45.0,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
          elevation: 0,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Icon(
              Icons.arrow_back_ios,
            ),
          ),
        ),
      ),
    );
  }
}
