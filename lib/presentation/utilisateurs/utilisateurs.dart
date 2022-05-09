import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carlock/model/utilisateurs_model.dart';
import 'package:carlock/presentation/utilisateurs/bloc/utilisateurs_bloc.dart';
import 'package:carlock/services/utilisateurs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:print_color/print_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UtilisateursPage extends StatefulWidget {
  const UtilisateursPage({Key? key}) : super(key: key);

  @override
  State<UtilisateursPage> createState() => _UtilisateursPageState();
}

class _UtilisateursPageState extends State<UtilisateursPage> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            //button pour actualiser la liste
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                final itemsBloc = BlocProvider.of<UtilisateursBloc>(context)
                  ..add(const UtilisateursRefreshEvent(
                    '',
                  ));
                itemsBloc.add(const UtilisateursRefreshEvent(''));
                // Navigator.pushReplacementNamed(context, '/utilisateurs');
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
          title: const Text(
            'list des utilisateurs',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;

            if (connected) {
              return UtilisateursPageBody();
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
        ));
  }
}

class UtilisateursPageBody extends StatelessWidget {
  UtilisateursPageBody({
    Key? key,
  }) : super(key: key);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          UtilisateursBloc(RepositoryProvider.of<UtilisateursServices>(context))
            ..add(const LoadUtilisateursEvent('  ')),
      child: BlocBuilder<UtilisateursBloc, UtilisateursState>(
        builder: (context, state) {
          if (state is UtilisateursInitial) {
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColorLight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }

          if (state is UtilisateursLoadingState) {
            return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColorLight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ));
          }

          if (state is UtilisateursLoadedState) {
            return SmartRefresher(
              controller: refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () {
                Print.blue('onRefresh');
                final itemsBloc = BlocProvider.of<UtilisateursBloc>(context)
                  ..add(const UtilisateursRefreshEvent(
                    '',
                  ));
                itemsBloc.add(const UtilisateursRefreshEvent(''));
                refreshController.refreshCompleted();
              },
              header: const WaterDropMaterialHeader(),
              child: ListView(children: [
                // IconButton(
                //   icon: const Icon(Icons.refresh),
                //   onPressed: () {
                //     final itemsBloc = BlocProvider.of<UtilisateursBloc>(context)
                //       ..add(const UtilisateursRefreshEvent(
                //         '',
                //       ));
                //     itemsBloc.add(const UtilisateursRefreshEvent(''));
                //     // Navigator.pushReplacementNamed(context, '/utilisateurs');
                //   },
                // ),
                //Text('je suis chargé'),
                ...state.utilisateurs.results!.map((result) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 2),
                    // child: Text(result.firstName.toString()),
                    child: UtilisateursCard(result),
                  );
                }).toList(),
              ]),
            );
          }
          if (state is UtilisateursErrorState) {
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
      ),
    );
  }
}

class UtilisateursCard extends StatelessWidget {
  final Results result;
  const UtilisateursCard(this.result, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 45,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://i.pinimg.com/originals/f0/0c/f0/f00cf06bbb48a178c56f1269c038cdf6.jpg',
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 120,
                        width: 120,
                        key: const ValueKey(
                            'f00cf06bbb48a178c56f1269c038cdf6.jpg'),
                        cacheKey: 'f00cf06bbb48a178c56f1269c038cdf6.jpg',
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                          padding: const EdgeInsets.all(7.5),
                          decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(90.0),
                              color: Colors.green)))
                ],
              ),
              const SizedBox(width: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  '${result.firstName} ${result.lastName}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                (result.codeVpn != null)
                    ? Text(
                        'connecté ${result.codeVpn}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.green,
                        ),
                      )
                    : const Text(
                        'deconnecté',
                      ),
                const SizedBox(height: 5),
                const Text(
                  '43278-A-72',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  '09 mai 2022, à 10:00',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ])
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.grey,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/user_map_page',
                      arguments: result);
                },
                child: Column(
                  children: const [
                    Icon(Icons.location_on),
                    Text('Position'),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/user_live_page',
                      arguments: result);
                },
                child: Column(
                  children: const [
                    Icon(Icons.live_tv_outlined),
                    Text('Live Stream'),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );

    // ignore: dead_code
    return UserAccountsDrawerHeader(
      accountName: Text(
        '${result.firstName} ${result.lastName}',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).primaryColorDark,
          fontWeight: FontWeight.bold,
        ),
      ),
      arrowColor: Colors.black,
      accountEmail: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 18,
        ),
        child: AnimatedTextKit(totalRepeatCount: 1, animatedTexts: [
          TypewriterAnimatedText(
            'Salut ',
          ),
          TypewriterAnimatedText('carlock est un service de ...'),
        ]),
      ),
      currentAccountPicture: CircleAvatar(
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl:
                'https://i.pinimg.com/originals/f0/0c/f0/f00cf06bbb48a178c56f1269c038cdf6.jpg',
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
            height: 90,
            width: 90,
            key: const ValueKey('f00cf06bbb48a178c56f1269c038cdf6.jpg'),
            cacheKey: 'f00cf06bbb48a178c56f1269c038cdf6.jpg',
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // image: const DecorationImage(
        //   image: AssetImage('assets/images/sidebar.jpg'),
        //   fit: BoxFit.cover,
        // ),
      ),
    );
  }
}
