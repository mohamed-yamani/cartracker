import 'package:carlock/presentation/profile/bloc/profile_bloc.dart';
import 'package:carlock/services/user_me_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ProfileLoadedState) {
          return Scaffold(
            // appBar: AppBar(
            //   centerTitle: true,
            //   leading: IconButton(
            //     icon: const Icon(
            //       Icons.arrow_back_ios,
            //       color: Colors.white,
            //       size: 25,
            //     ),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            //   ),
            //   title: const Text('Profile', style: TextStyle(fontSize: 13)),
            // ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                FractionallySizedBox(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.8,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile_test.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
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
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                          child: _panelBody(scrollController, context));
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
        return Container();
      }),
    );
  }

  SingleChildScrollView _panelBody(
      ScrollController scrollController, BuildContext context) {
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
                    titleInfo(),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    infoSection(context)
                  ],
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            const Center(
              child: Text('More info', style: TextStyle(fontSize: 20)),
            )
          ],
        ));
  }

  Row infoSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        infoCell(
          title: 'location',
          value: 'casablanca',
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

  Widget titleInfo() {
    return Column(
      children: const [
        SizedBox(height: 25),
        Text(
          'John Doe',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 10),
        Text(
          '@johndoe',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
      ],
    );
  }

  Widget infoCell({String? title, String? value}) {
    return Column(
      children: [
        Text(
          title!,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          value!,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    );
  }
}
