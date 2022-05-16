import 'package:cached_network_image/cached_network_image.dart';
import 'package:carlock/model/user_me_model.dart';
import 'package:carlock/presentation/profile/bloc/profile_bloc.dart';
import 'package:carlock/services/user_me_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PanelController _panelController = PanelController();
  bool _panelOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(RepositoryProvider.of<UserMeServices>(context))
            ..add(const LoadUserMeEvent('test')),
      child: BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        if (state is ProfileInitial) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProfileLoadedState) {
          UserMeModel userMe = state.userMe;
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                FractionallySizedBox(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.8,
                  child: userMe.picture != null
                      ? CachedNetworkImage(
                          imageUrl: '${userMe.picture}',
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          height: 90,
                          width: 90,
                          key: const ValueKey('user_image1'),
                          cacheKey: 'user_image1',
                        )
                      : const Center(child: Text('No image')),
                ),

                FractionallySizedBox(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.3,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),

                // ! slding panel
                SlidingUpPanel(
                    controller: _panelController,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    maxHeight: MediaQuery.of(context).size.height * 0.60,
                    minHeight: MediaQuery.of(context).size.height * 0.25,
                    // panel: Container(color: Colors.red),
                    body: GestureDetector(
                      onTap: () {
                        _panelOpen
                            ? _panelController.close()
                            : _panelController.open();
                        setState(() {
                          _panelOpen = !_panelOpen;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                    panelBuilder: (ScrollController scrollController) {
                      return GestureDetector(
                          onTap: () {
                            _panelOpen
                                ? _panelController.close()
                                : _panelController.open();
                            setState(() {
                              _panelOpen = !_panelOpen;
                            });
                          },
                          child: _panelBody(scrollController, context, userMe));
                    }),
                Positioned(
                  top: 30,
                  left: 5,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                ),
              ],
            ),
          );
        }
        return Container(
          color: Colors.red,
        );
      }),
    );
  }

  SingleChildScrollView _panelBody(ScrollController scrollController,
      BuildContext context, UserMeModel userMe) {
    double hPadding = 40;

    return SingleChildScrollView(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: hPadding),
                height: MediaQuery.of(context).size.height * 0.3,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Text('data'),
                    const SizedBox(height: 8),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.008,
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    titleInfo(userMe),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    infoSection(context, userMe),
                  ],
                )),
            // SizedBox(height: MediaQuery.of(context).size.height * ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: MediaQuery.of(context).size.height * 0.3,
              child: 1 == 1
                  ? GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        bearing: 0,
                        target: LatLng(double.parse(userMe.latitude.toString()),
                            double.parse(userMe.longitude.toString())),
                        tilt: 59.440717697143555,
                        zoom: 10.4746,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(userMe.lastName.toString()),
                          position: LatLng(
                              double.parse(userMe.latitude.toString()),
                              double.parse(userMe.longitude.toString())),
                          infoWindow: InfoWindow(
                            title: userMe.lastName.toString(),
                            snippet: userMe.firstName.toString(),
                          ),
                        ),
                      },
                      // onMapCreated: (GoogleMapController controller) {
                      //   _googleMapController = controller;
                      // },
                    )
                  : const Text('data'),
            ),
            // const Center(
            //   child: Text('More info', style: TextStyle(fontSize: 20)),
            // )
          ],
        ));
  }

  Row infoSection(BuildContext context, UserMeModel userMe) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        infoCell(
          title: 'id',
          value: '${userMe.id}',
        ),
        Container(
          width: 1,
          height: MediaQuery.of(context).size.height * 0.04,
          color: Colors.grey[300],
        ),
        infoCell(
          title: 'matches',
          value: '12',
        ),
        Container(
          width: 1,
          height: MediaQuery.of(context).size.height * 0.04,
          color: Colors.grey[300],
        ),
        infoCell(
          title: 'connected',
          value: 'vpn1',
        ),
      ],
    );
  }

  Widget titleInfo(UserMeModel userMe) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Text(
          '${userMe.firstName} ${userMe.lastName}',
          style: const TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 10),
        Text(
          '@${userMe.username}',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }

  Widget infoCell({String? title, String? value}) {
    return Column(
      children: [
        Text(
          '$title',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          '$value',
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
