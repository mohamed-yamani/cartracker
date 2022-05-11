import 'package:cached_network_image/cached_network_image.dart';
import 'package:carlock/constants/urls.dart';
import 'package:carlock/presentation/matches/bloc/bloc/matches_bloc.dart';
import 'package:carlock/presentation/matches/nav_bar.dart';
import 'package:carlock/model/matches_model.dart';
import 'package:carlock/services/matches.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:print_color/print_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share/share.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({Key? key}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  Icon customIcon = const Icon(
    Icons.date_range,
    color: Colors.white,
    size: 25,
  );

  Icon customIcon2 = const Icon(
    Icons.directions_car_outlined,
    color: Colors.white,
    size: 25,
  );

  Widget custombar = const Text(
    'HISTORIQUE DES MATCHES',
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MatchesBloc(RepositoryProvider.of<MatchesServices>(context))
            ..add(const LoadMatchesEvent('')),
      child: Scaffold(
        drawer: BlocProvider.value(
          value: MatchesBloc(MatchesServices()),
          child: const NavBar(),
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          // centerTitle: true,
          title: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.0),
            child: custombar,
          ),
          actions: [
            BlocBuilder<MatchesBloc, MatchesState>(
              builder: (context, state) {
                return IconButton(
                  icon: customIcon,
                  onPressed: () {
                    // matchesBloc
                    //     .add(const MatchesSearchDateEvent('jean', 'jojo'));

                    setState(() {
                      if (customIcon.icon == Icons.date_range) {
                        customIcon = const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        );
                        custombar = TextField(
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            Print.red('Recherche par date');

                            BlocProvider.of<MatchesBloc>(context)
                                .add(MatchesSearchDateEvent(
                              '',
                              value,
                            ));
                          },
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Recherche par date',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                          ),
                        );
                      } else {
                        BlocProvider.of<MatchesBloc>(context)
                            .add(const MatchesSearchDateEvent(
                          '',
                          '',
                        ));
                        customIcon = const Icon(
                          Icons.date_range,
                          color: Colors.white,
                          size: 25,
                        );
                        custombar = const Text(
                          'HISTORIQUE DES MATCHES',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    });
                    // showSearch(context: context, delegate: SearchDelegate());
                  },
                  tooltip: 'Recherche par date',
                );
              },
            ),
            BlocBuilder<MatchesBloc, MatchesState>(
              builder: (context, state) {
                return IconButton(
                  icon: customIcon2,
                  onPressed: () {
                    // matchesBloc
                    //     .add(const MatchesSearchDateEvent('jean', 'jojo'));
                    setState(() {
                      if (customIcon2.icon == Icons.directions_car_outlined) {
                        customIcon2 = const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        );
                        custombar = TextField(
                          textInputAction: TextInputAction.search,
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            Print.red('recherche par matricule');

                            BlocProvider.of<MatchesBloc>(context)
                                .add(MatchesSearchRegisterNumberEvent(
                              '',
                              value,
                            ));
                          },
                          cursorColor: Colors.white,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Recherche par matricule',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                          ),
                        );
                      } else {
                        BlocProvider.of<MatchesBloc>(context)
                            .add(const MatchesSearchRegisterNumberEvent(
                          '',
                          '',
                        ));
                        customIcon2 = const Icon(
                          Icons.directions_car_outlined,
                          color: Colors.white,
                          size: 25,
                        );
                        custombar = const Text(
                          'HISTORIQUE DES MATCHES',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                    });
                  },
                  tooltip: 'recherche par matricule',
                );
              },
            ),
          ],
          // bottom: const PreferredSize(
          //     child: Text('test'), preferredSize: Size.fromHeight(50)),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;

            if (connected) {
              return OurBody();
            }
            return Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/caveman.gif',
                      width: 600,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Veuillez vérifier votre connexion internet',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
            );
          },
          child: const CircularProgressIndicator(),
        ),

        // const OurBody(),
      ),
    );
  }
}

// ignore: must_be_immutable
class OurBody extends StatelessWidget {
  OurBody({
    Key? key,
  }) : super(key: key);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesBloc, MatchesState>(
      builder: (context, state) {
        if (state is MatchesLoadingState) {
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColorLight,
              child: const Center(
                child: CircularProgressIndicator(),
              ));
        }

        if (state is MatchesLoadedState) {
          return SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: false,
            onRefresh: () {
              Print.blue('onRefresh');
              final matchesBloc = BlocProvider.of<MatchesBloc>(context)
                ..add(const MatchesRefreshEvent(
                  '',
                ));
              matchesBloc.add(const MatchesRefreshEvent(''));
              refreshController.refreshCompleted();
            },
            header: const WaterDropMaterialHeader(),
            child: ListView(children: [
/*
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        final matchesBloc =
                            BlocProvider.of<MatchesBloc>(context)
                              ..add(const MatchesSearchDateEvent(
                                '',
                                '',
                              ));
                        matchesBloc
                            .add(const MatchesSearchDateEvent('jean', 'jojo'));
                      },
                      icon: const Icon(Icons.date_range)),
                  const SizedBox(height: 20),
                  IconButton(
                      onPressed: () {
                        final matchesBloc =
                            BlocProvider.of<MatchesBloc>(context)
                              ..add(const MatchesSearchRegisterNumberEvent(
                                '',
                                '',
                              ));
                        matchesBloc.add(const MatchesSearchRegisterNumberEvent(
                            'jean', 'jojo'));
                      },
                      icon: const Icon(Icons.directions_car_outlined)),
                ],
              ),
              */
              ...state.matches.results!.map((result) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 2),
                  child: _getCard(result),
                );
              }).toList(),
            ]),
          );
        }
        if (state is MatchesErrorState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 17, color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}

class _getCard extends StatelessWidget {
  late Results result;
  _getCard(this.result);
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.grey[200],
        child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                          size: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          result.createdAt.toString().substring(0, 10) +
                              ' à ' +
                              result.createdAt.toString().substring(11, 16),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Share.share(
                          '$googleShareLocation${result.latitude},${result.longitude}',
                        );
                      },
                      child: const Icon(
                        Icons.share,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CachedNetworkImage(
                  key: Key(result.id.toString()),
                  cacheKey: result.id.toString(),
                  imageUrl: result.picture ??
                      'https://us.123rf.com/450wm/infadel/infadel1712/infadel171200119/91684826-a-black-linear-photo-camera-logo-like-no-image-available-.jpg',
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        result.picture != null && 1 > 2
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: CachedNetworkImageProvider(
                                    result.picture!,
                                    cacheKey: result.id.toString() + 'picture'),
                                key: ValueKey(result.id.toString() + 'picture'),
                                radius: 25,
                              )
                            : const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage('assets/images/no_image.png'),
                                key: ValueKey('no_image.png'),
                                radius: 25,
                              ),
                      ],
                    ),
                    Text(
                      '${result.matriculeStr}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/map_page',
                          arguments: result,
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: CachedNetworkImageProvider(
                            'https://img.phonandroid.com/2016/04/comment-utiliser-google-maps-gps.jpg',
                            cacheKey: 'comment-utiliser-google-maps-gps.jpg'),
                        key: Key('comment-utiliser-google-maps-gps.jpg'),
                        radius: 25,
                      ),
                      // child: Container(
                      //   width: 40,
                      //   height: 40,
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(50)),
                      //   child: Center(
                      //     child: Icon(
                      //       Icons.location_on_outlined,
                      //       color: Theme.of(context).primaryColor,
                      //       size: 30,
                      //     ),
                      //   ),
                      // ),
                    ),
                  ],
                ),
              ],
            )));
  }
}
