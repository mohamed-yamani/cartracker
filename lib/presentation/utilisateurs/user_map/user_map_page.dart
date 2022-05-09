import 'package:carlock/model/utilisateurs_model.dart';
import 'package:flutter/material.dart';
import 'package:carlock/presentation/utilisateurs/utilisateurs.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserMapPage extends StatelessWidget {
  UserMapPage({Key? key}) : super(key: key);

  final marker = <Marker>[];

  @override
  Widget build(BuildContext context) {
    Results result = ModalRoute.of(context)?.settings.arguments as Results;
    return Scaffold(
      appBar: AppBar(
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
          '${result.firstName} ${result.lastName} est sur la carte',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          bearing: 0,
          target: LatLng(
              double.parse(result.latitude!), double.parse(result.longitude!)),
          tilt: 59.440717697143555,
          zoom: 14.4746,
        ),
        markers: <Marker>{
          Marker(
            markerId: MarkerId(result.id.toString()),
            position: LatLng(double.parse(result.latitude!),
                double.parse(result.longitude!)),
            infoWindow: InfoWindow(
              title: '${result.firstName} ${result.lastName}',
            ),
          ),
        },
      ),
    );
  }
}
