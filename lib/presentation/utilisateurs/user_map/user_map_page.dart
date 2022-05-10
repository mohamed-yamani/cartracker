import 'dart:async';

import 'package:carlock/model/latestLocalisation.dart';
import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/repository/localisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:print_color/print_color.dart';

class UserMapPage extends StatefulWidget {
  const UserMapPage({Key? key}) : super(key: key);

  @override
  State<UserMapPage> createState() => _UserMapPageState();
}

class _UserMapPageState extends State<UserMapPage> {
  // final marker = <Marker>[];
  Marker? marker;
  late Timer timer;
  LatestLocalisation? latestLocalisation;
  GoogleMapController? _googleMapController;
  bool updateZoom = true;
  bool mapCarte = false;

  @override
  void initState() {
    updateCarPosition();
    super.initState();
  }

  void updateCarPosition() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          getCurrontLocation();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Results result = ModalRoute.of(context)?.settings.arguments as Results;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
                !mapCarte ? Icons.public_outlined : Icons.public_off_outlined),
            onPressed: () {
              setState(() {
                mapCarte = !mapCarte;
              });
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        centerTitle: true,
        title: Text(
          '${result.firstName} ${result.lastName} sur la carte',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GoogleMap(
        mapType: !mapCarte ? MapType.normal : MapType.satellite,
        initialCameraPosition: CameraPosition(
          bearing: 0,
          target: LatLng(
              double.parse(result.latitude!), double.parse(result.longitude!)),
          tilt: 59.440717697143555,
          zoom: 10.4746,
        ),
        markers: Set.of((marker != null) ? [marker!] : []),
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
    );
  }

  Future<void> getCurrontLocation() async {
    try {
      // Uint8List markerImageData = await getMarker();
      Results result = ModalRoute.of(context)?.settings.arguments as Results;
      latestLocalisation =
          await ApiLocalisation().getlatestlocalisation(result.id?.toString());
      Print.red(result);
      Print.red(
          'latutude: ${latestLocalisation?.latitude}  longitude: ${latestLocalisation?.longitude}');
      updateMarkerAndCircle(
        latestLocalisation,
        // markerImageData,
      );

      if (_googleMapController != null) {
        var zoom = await _googleMapController!.getZoomLevel();
        _googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              // bearing: 192.8334901395799,
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

  void updateMarkerAndCircle(
    latestLocalisation,
    // Uint8List markerImageData
  ) {
    LatLng latLng = LatLng(double.parse(latestLocalisation.latitude!),
        double.parse(latestLocalisation.longitude!));

    // ignore: unnecessary_this
    this.setState(
      () {
        SetMarker(latLng);
      },
    );
  }

  void SetMarker(LatLng latLng) {
    Results result = ModalRoute.of(context)?.settings.arguments as Results;
    marker = Marker(
      markerId: const MarkerId('car_marker'),
      position: latLng,
      // rotation: 180,
      zIndex: 2,
      draggable: false,
      flat: true,
      anchor: const Offset(0.5, 0.5),
      // icon: BitmapDescriptor.fromBytes(markerImageData),
      infoWindow: InfoWindow(
        title: '${result.firstName} ${result.lastName}',
        // snippet: '65528-A-8',
      ),
    );
  }
}
